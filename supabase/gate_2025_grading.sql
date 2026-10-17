-- Uses the EXISTING mock_questions.correct_answer and options JSONB columns.
-- No tables or columns are created. Run before gate_2025_previous_year_mock_seed.sql.
-- Preserve this helper and upgraded submit function alongside the existing start RPC.
BEGIN;
CREATE OR REPLACE FUNCTION public.evaluate_mock_response(
    p_key TEXT, p_selected TEXT, p_type TEXT, p_marks NUMERIC, p_negative NUMERIC
) RETURNS JSONB
LANGUAGE plpgsql IMMUTABLE SET search_path = '' AS $grade$
DECLARE
    v_key JSONB;
    v_kind TEXT;
    v_correct BOOLEAN := FALSE;
    v_awarded NUMERIC;
    v_number NUMERIC;
    v_range JSONB;
    v_selected TEXT[];
    v_expected TEXT[];
    v_numeric_pattern TEXT := '^[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)([eE][+-]?[0-9]+)?$';
BEGIN
    IF left(p_key,9) = 'GATE2025:' THEN
        v_key := substr(p_key,10)::JSONB;
        v_kind := v_key->>'kind';
        IF v_kind='NAT' THEN
            IF btrim(p_selected) ~ v_numeric_pattern THEN
                BEGIN
                    v_number := btrim(p_selected)::NUMERIC;
                    FOR v_range IN SELECT value FROM jsonb_array_elements(v_key->'ranges') LOOP
                        IF v_number BETWEEN (v_range->>0)::NUMERIC AND (v_range->>1)::NUMERIC THEN
                            v_correct := TRUE;
                        END IF;
                    END LOOP;
                EXCEPTION WHEN numeric_value_out_of_range OR invalid_text_representation THEN
                    v_correct := FALSE;
                END;
            END IF;
        ELSIF v_kind='MSQ' THEN
            IF btrim(p_selected) ~* '^[A-D]([;,][A-D])*$' THEN
                SELECT array_agg(DISTINCT x ORDER BY x) INTO v_selected
                FROM unnest(regexp_split_to_array(upper(btrim(p_selected)), '[;,]')) AS t(x);
                SELECT array_agg(x ORDER BY x) INTO v_expected
                FROM jsonb_array_elements_text(v_key->'answers') AS t(x);
                v_correct := v_selected = v_expected;
            END IF;
        ELSIF v_kind='MCQ' THEN
            v_correct := upper(btrim(p_selected)) = v_key->'answers'->>0;
        ELSE
            RAISE EXCEPTION 'Unsupported imported-paper grading kind';
        END IF;
        -- Keep rational MCQ penalties until the final score is rounded to two decimals.
        v_awarded := CASE WHEN v_correct THEN p_marks
                          WHEN v_kind='MCQ' THEN -p_marks/3
                          ELSE 0 END;
    ELSE
        -- Existing SSC JE, TGPSC and plain-text keys retain their previous behavior.
        IF p_type='numerical' AND btrim(p_selected) ~ v_numeric_pattern AND btrim(p_key) ~ v_numeric_pattern THEN
            v_correct := btrim(p_selected)::NUMERIC = btrim(p_key)::NUMERIC;
        ELSE
            v_correct := lower(btrim(p_selected)) = lower(btrim(p_key));
        END IF;
        v_awarded := CASE WHEN v_correct THEN p_marks ELSE -p_negative END;
    END IF;
    RETURN jsonb_build_object('is_correct',COALESCE(v_correct,FALSE),'marks_awarded',v_awarded);
END;
$grade$;
REVOKE ALL ON FUNCTION public.evaluate_mock_response(TEXT,TEXT,TEXT,NUMERIC,NUMERIC) FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE FUNCTION public.submit_mock_attempt(p_attempt_id UUID, p_answers JSONB)
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path = '' AS $$
DECLARE
    v_student_id UUID := (SELECT auth.uid());
    v_attempt public.mock_attempts%ROWTYPE;
    v_duration INT;
    v_item JSONB;
    v_question_id UUID;
    v_selected TEXT;
    v_correct_answer TEXT;
    v_question_type TEXT;
    v_marks NUMERIC(8,2);
    v_negative NUMERIC(8,2);
    v_is_correct BOOLEAN;
    v_score NUMERIC := 0;
    v_grade JSONB;
    v_awarded NUMERIC;
    v_correct INT := 0;
    v_incorrect INT := 0;
BEGIN
    IF v_student_id IS NULL THEN RAISE EXCEPTION 'Sign in to submit a mock test'; END IF;
    IF jsonb_typeof(p_answers) <> 'array' THEN RAISE EXCEPTION 'Answers must be an array'; END IF;
    IF EXISTS (
        SELECT 1 FROM jsonb_array_elements(p_answers) AS a(value)
        GROUP BY value->>'question_id' HAVING count(*)>1
    ) THEN RAISE EXCEPTION 'Each question may be submitted only once'; END IF;
    SELECT * INTO v_attempt FROM public.mock_attempts WHERE id = p_attempt_id AND student_id = v_student_id FOR UPDATE;
    IF NOT FOUND OR v_attempt.status <> 'in_progress' THEN RAISE EXCEPTION 'Mock attempt is not active'; END IF;
    SELECT duration_minutes INTO v_duration FROM public.mock_tests WHERE id = v_attempt.mock_test_id;
    IF now() > v_attempt.started_at + make_interval(mins => v_duration) THEN
        UPDATE public.mock_attempts SET status = 'expired', submitted_at = now() WHERE id = p_attempt_id;
        RETURN jsonb_build_object('status', 'expired');
    END IF;
    FOR v_item IN SELECT value FROM jsonb_array_elements(p_answers) LOOP
        v_question_id := (v_item ->> 'question_id')::UUID;
        v_selected := v_item ->> 'selected_answer';
        SELECT correct_answer, question_type, marks, negative_marks INTO v_correct_answer, v_question_type, v_marks, v_negative
        FROM public.mock_questions WHERE id = v_question_id AND mock_test_id = v_attempt.mock_test_id;
        IF NOT FOUND THEN RAISE EXCEPTION 'Answer contains a question outside this mock test'; END IF;
        IF v_selected IS NULL OR btrim(v_selected) = '' THEN RAISE EXCEPTION 'Submitted answers must include a response'; END IF;
        v_grade := public.evaluate_mock_response(v_correct_answer,v_selected,v_question_type,v_marks,v_negative);
        v_is_correct := (v_grade->>'is_correct')::BOOLEAN;
        v_awarded := (v_grade->>'marks_awarded')::NUMERIC;
        IF v_is_correct THEN v_correct := v_correct + 1;
        ELSE v_incorrect := v_incorrect + 1; END IF;
        v_score := v_score + v_awarded;
        INSERT INTO public.mock_attempt_answers (attempt_id, mock_test_id, question_id, selected_answer, is_correct, marks_awarded)
        VALUES (p_attempt_id, v_attempt.mock_test_id, v_question_id, v_selected, v_is_correct, v_awarded);
    END LOOP;
    UPDATE public.mock_attempts SET status = 'submitted', submitted_at = now(), score = round(v_score,2),
        correct_answers = v_correct, incorrect_answers = v_incorrect,
        time_taken_seconds = GREATEST(0, floor(extract(epoch FROM (now() - started_at)))::INT)
    WHERE id = p_attempt_id;
    RETURN jsonb_build_object('status', 'submitted', 'score', round(v_score,2), 'correct_answers', v_correct, 'incorrect_answers', v_incorrect, 'total_questions', v_attempt.total_questions);
END;
$$;


REVOKE ALL ON FUNCTION public.submit_mock_attempt(UUID,JSONB) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.submit_mock_attempt(UUID,JSONB) TO authenticated;
COMMIT;
