-- Secure question paging and answer grading for the supplied student schema.
-- Run this after the student learning schema in the Supabase SQL Editor.

CREATE TABLE IF NOT EXISTS public.practice_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    subject_id UUID NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
    topic_id UUID,
    question_text TEXT NOT NULL,
    question_type VARCHAR(20) NOT NULL DEFAULT 'mcq'
        CHECK (question_type IN ('mcq', 'numerical', 'text')),
    options JSONB,
    correct_answer TEXT NOT NULL,
    explanation TEXT,
    difficulty VARCHAR(20) NOT NULL DEFAULT 'medium'
        CHECK (difficulty IN ('easy', 'medium', 'hard')),
    question_date DATE,
    points INT NOT NULL DEFAULT 10 CHECK (points >= 0),
    display_order INT NOT NULL DEFAULT 0,
    is_published BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    FOREIGN KEY (topic_id, subject_id)
        REFERENCES public.topics(id, subject_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_practice_questions_subject_order
    ON public.practice_questions(subject_id, display_order, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_practice_questions_topic
    ON public.practice_questions(topic_id);
ALTER TABLE public.practice_questions ENABLE ROW LEVEL SECURITY;

CREATE TABLE IF NOT EXISTS public.practice_question_answers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    question_id UUID NOT NULL REFERENCES public.practice_questions(id) ON DELETE CASCADE,
    submitted_answer TEXT NOT NULL,
    is_correct BOOLEAN NOT NULL,
    score NUMERIC(8, 2) NOT NULL DEFAULT 0 CHECK (score >= 0),
    submitted_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (student_id, question_id)
);

CREATE INDEX IF NOT EXISTS idx_practice_question_answers_student
    ON public.practice_question_answers(student_id);
ALTER TABLE public.practice_question_answers ENABLE ROW LEVEL SECURITY;

-- Preserve the existing daily-question bank and answers as reusable practice records.
INSERT INTO public.practice_questions (
    id, subject_id, topic_id, question_text, question_type, options,
    correct_answer, explanation, difficulty, question_date, points,
    is_published, created_at
)
SELECT id, subject_id, topic_id, question_text, question_type, options,
       correct_answer, explanation, difficulty, question_date, points,
       TRUE, created_at
FROM public.daily_questions
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.practice_question_answers (
    student_id, question_id, submitted_answer, is_correct, score, submitted_at
)
SELECT answer.student_id, answer.question_id, answer.submitted_answer,
       COALESCE(answer.is_correct, FALSE), answer.score, answer.submitted_at
FROM public.student_answers answer
JOIN public.practice_questions question ON question.id = answer.question_id
ON CONFLICT (student_id, question_id) DO NOTHING;

CREATE OR REPLACE FUNCTION public.get_practice_questions(
    p_subject_id UUID,
    p_topic_id UUID DEFAULT NULL,
    p_page INT DEFAULT 1
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
    v_page INT := GREATEST(COALESCE(p_page, 1), 1);
    v_offset INT;
    v_total BIGINT;
    v_items JSONB;
BEGIN
    v_offset := (v_page - 1) * 15;

    SELECT COUNT(*) INTO v_total
        FROM public.practice_questions q
        WHERE q.subject_id = p_subject_id
            AND q.is_published = TRUE
      AND (p_topic_id IS NULL OR q.topic_id = p_topic_id);

    SELECT COALESCE(
        jsonb_agg(
            jsonb_build_object(
                'id', page_rows.id,
                'subject_id', page_rows.subject_id,
                'topic_id', page_rows.topic_id,
                'topic_title', page_rows.topic_title,
                'question_text', page_rows.question_text,
                'question_type', page_rows.question_type,
                'options', page_rows.options,
                'difficulty', page_rows.difficulty,
                'question_date', page_rows.question_date,
                'points', page_rows.points
            ) ORDER BY page_rows.display_order, page_rows.created_at DESC, page_rows.id
        ),
        '[]'::JSONB
    ) INTO v_items
    FROM (
                SELECT q.id, q.subject_id, q.topic_id, t.title AS topic_title,
               q.question_text, q.question_type, q.options, q.difficulty,
                             q.question_date, q.points, q.display_order, q.created_at
                FROM public.practice_questions q
        LEFT JOIN public.topics t ON t.id = q.topic_id
        WHERE q.subject_id = p_subject_id
                    AND q.is_published = TRUE
          AND (p_topic_id IS NULL OR q.topic_id = p_topic_id)
                ORDER BY q.display_order, q.created_at DESC, q.id
        LIMIT 15 OFFSET v_offset
    ) AS page_rows;

    RETURN jsonb_build_object(
        'items', v_items,
        'total', v_total,
        'page', v_page,
        'page_size', 15
    );
END;
$$;

CREATE OR REPLACE FUNCTION public.submit_practice_answer(
    p_question_id UUID,
    p_submitted_answer TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
    v_student_id UUID := (SELECT auth.uid());
    v_question public.practice_questions%ROWTYPE;
    v_is_correct BOOLEAN;
    v_previous_score NUMERIC(8, 2) := 0;
    v_new_score NUMERIC(8, 2) := 0;
    v_total_points INT;
BEGIN
    IF v_student_id IS NULL THEN
        RAISE EXCEPTION 'Sign in to submit an answer';
    END IF;
    IF p_submitted_answer IS NULL OR btrim(p_submitted_answer) = '' THEN
        RAISE EXCEPTION 'Answer cannot be empty';
    END IF;

    SELECT * INTO v_question
    FROM public.practice_questions
    WHERE id = p_question_id AND is_published = TRUE;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Question is not available';
    END IF;

    IF v_question.question_type = 'numerical'
       AND btrim(p_submitted_answer) ~ '^-?[0-9]+(\.[0-9]+)?$'
       AND btrim(v_question.correct_answer) ~ '^-?[0-9]+(\.[0-9]+)?$' THEN
        v_is_correct := btrim(p_submitted_answer)::NUMERIC = btrim(v_question.correct_answer)::NUMERIC;
    ELSE
        v_is_correct := lower(btrim(p_submitted_answer)) = lower(btrim(v_question.correct_answer));
    END IF;

    v_new_score := CASE WHEN v_is_correct THEN v_question.points ELSE 0 END;

    PERFORM 1 FROM public.profiles WHERE id = v_student_id FOR UPDATE;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Student profile is not available';
    END IF;

    SELECT score INTO v_previous_score
    FROM public.practice_question_answers
    WHERE student_id = v_student_id AND question_id = p_question_id
    FOR UPDATE;

    IF FOUND THEN
        UPDATE public.practice_question_answers
        SET submitted_answer = p_submitted_answer,
            is_correct = v_is_correct,
            score = v_new_score,
            submitted_at = now()
        WHERE student_id = v_student_id AND question_id = p_question_id;
    ELSE
        INSERT INTO public.practice_question_answers (
            student_id, question_id, submitted_answer, is_correct, score
        ) VALUES (
            v_student_id, p_question_id, p_submitted_answer, v_is_correct, v_new_score
        );
    END IF;

    UPDATE public.profiles
    SET total_points = GREATEST(0, total_points + (v_new_score - COALESCE(v_previous_score, 0))::INT)
    WHERE id = v_student_id
    RETURNING total_points INTO v_total_points;

    RETURN jsonb_build_object(
        'is_correct', v_is_correct,
        'score', v_new_score,
        'total_points', v_total_points,
        'explanation', v_question.explanation
    );
END;
$$;

REVOKE ALL ON FUNCTION public.get_practice_questions(UUID, UUID, INT) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.get_practice_questions(UUID, UUID, INT) TO anon, authenticated;
REVOKE ALL ON FUNCTION public.submit_practice_answer(UUID, TEXT) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.submit_practice_answer(UUID, TEXT) TO authenticated;