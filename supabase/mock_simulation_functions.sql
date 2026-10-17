-- Run after the student learning schema. Correct answers remain in PostgreSQL.
CREATE OR REPLACE FUNCTION public.start_mock_attempt(p_mock_test_id UUID)
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path = '' AS $$
DECLARE
    v_student_id UUID := (SELECT auth.uid());
    v_test public.mock_tests%ROWTYPE;
    v_attempt_id UUID;
    v_questions JSONB;
BEGIN
    IF v_student_id IS NULL THEN RAISE EXCEPTION 'Sign in to start a mock test'; END IF;
    SELECT * INTO v_test FROM public.mock_tests WHERE id = p_mock_test_id AND is_published = TRUE;
    IF NOT FOUND THEN RAISE EXCEPTION 'Mock test is not available'; END IF;
    IF NOT EXISTS (SELECT 1 FROM public.mock_questions WHERE mock_test_id = p_mock_test_id) THEN RAISE EXCEPTION 'This mock test has no questions'; END IF;
    INSERT INTO public.mock_attempts (mock_test_id, student_id, total_questions)
    SELECT p_mock_test_id, v_student_id, COUNT(*) FROM public.mock_questions WHERE mock_test_id = p_mock_test_id
    RETURNING id INTO v_attempt_id;
    SELECT jsonb_agg(jsonb_build_object('id', id, 'question_text', question_text, 'question_type', question_type, 'options', options) ORDER BY display_order, id)
    INTO v_questions FROM public.mock_questions WHERE mock_test_id = p_mock_test_id;
    RETURN jsonb_build_object('attempt_id', v_attempt_id, 'test_title', v_test.title, 'duration_minutes', v_test.duration_minutes, 'questions', v_questions);
END;
$$;

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
    v_score NUMERIC(10,2) := 0;
    v_correct INT := 0;
    v_incorrect INT := 0;
BEGIN
    IF v_student_id IS NULL THEN RAISE EXCEPTION 'Sign in to submit a mock test'; END IF;
    IF jsonb_typeof(p_answers) <> 'array' THEN RAISE EXCEPTION 'Answers must be an array'; END IF;
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
        IF v_question_type = 'numerical' AND btrim(v_selected) ~ '^-?[0-9]+(\.[0-9]+)?$' AND btrim(v_correct_answer) ~ '^-?[0-9]+(\.[0-9]+)?$' THEN
            v_is_correct := btrim(v_selected)::NUMERIC = btrim(v_correct_answer)::NUMERIC;
        ELSE
            v_is_correct := lower(btrim(v_selected)) = lower(btrim(v_correct_answer));
        END IF;
        IF v_is_correct THEN v_correct := v_correct + 1; v_score := v_score + v_marks;
        ELSE v_incorrect := v_incorrect + 1; v_score := v_score - v_negative; END IF;
        INSERT INTO public.mock_attempt_answers (attempt_id, mock_test_id, question_id, selected_answer, is_correct, marks_awarded)
        VALUES (p_attempt_id, v_attempt.mock_test_id, v_question_id, v_selected, v_is_correct, CASE WHEN v_is_correct THEN v_marks ELSE -v_negative END);
    END LOOP;
    UPDATE public.mock_attempts SET status = 'submitted', submitted_at = now(), score = v_score,
        correct_answers = v_correct, incorrect_answers = v_incorrect,
        time_taken_seconds = GREATEST(0, floor(extract(epoch FROM (now() - started_at)))::INT)
    WHERE id = p_attempt_id;
    RETURN jsonb_build_object('status', 'submitted', 'score', v_score, 'correct_answers', v_correct, 'incorrect_answers', v_incorrect, 'total_questions', v_attempt.total_questions);
END;
$$;

REVOKE ALL ON FUNCTION public.start_mock_attempt(UUID) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.submit_mock_attempt(UUID, JSONB) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.start_mock_attempt(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.submit_mock_attempt(UUID, JSONB) TO authenticated;