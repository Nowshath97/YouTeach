-- Run after mock_test_setup.sql. Read-only review of owned, submitted attempts.
BEGIN;
CREATE OR REPLACE FUNCTION public.get_mock_test_review(p_attempt_id UUID)
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$
DECLARE v_attempt public.mock_attempts%ROWTYPE;
BEGIN
 IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Sign in to review a test'; END IF;
 SELECT * INTO v_attempt FROM public.mock_attempts
 WHERE id=p_attempt_id AND student_id=auth.uid();
 IF NOT FOUND THEN RAISE EXCEPTION 'Attempt unavailable'; END IF;
 IF v_attempt.status <> 'submitted' THEN RAISE EXCEPTION 'Only completed tests can be reviewed'; END IF;
 RETURN jsonb_build_object('attempt_id',v_attempt.id,'questions',(
 SELECT coalesce(jsonb_agg(jsonb_build_object(
 'id',q.id,'question_text',q.question_text,'question_type',q.question_type,
 'options',q.options,'correct_answer',q.correct_answer,
 'selected_answer',a.selected_answer,'is_correct',a.is_correct,
 'marks_awarded',coalesce(a.marks_awarded,0),'marks',q.marks,
 'explanation',coalesce(to_jsonb(q)->>'explanation',to_jsonb(q)->>'solution')
 ) ORDER BY q.display_order,q.id),'[]'::JSONB)
 FROM public.mock_questions q LEFT JOIN public.mock_attempt_answers a
 ON a.question_id=q.id AND a.attempt_id=v_attempt.id
 WHERE q.mock_test_id=v_attempt.mock_test_id));
END; $$;
REVOKE ALL ON FUNCTION public.get_mock_test_review(UUID) FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION public.get_mock_test_review(UUID) TO authenticated;
COMMIT;
