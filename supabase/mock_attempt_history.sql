-- Run against existing mock tables. No tables or grading functions are replaced.
CREATE OR REPLACE FUNCTION public.get_mock_attempt_history(p_limit INT DEFAULT 20, p_offset INT DEFAULT 0, p_attempt_id UUID DEFAULT NULL)
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path = '' AS $$
DECLARE v_user UUID := auth.uid(); v_rows JSONB;
BEGIN
    IF v_user IS NULL THEN RAISE EXCEPTION 'Sign in to view attempt history'; END IF;
    SELECT coalesce(jsonb_agg(to_jsonb(r) ORDER BY r.started_at DESC, r.attempt_id), '[]'::JSONB)
    INTO v_rows FROM (
      SELECT a.id AS attempt_id, t.title, a.status, a.started_at, a.submitted_at,
        a.time_taken_seconds, a.score, t.total_marks, a.total_questions,
        a.correct_answers, a.incorrect_answers,
        greatest(0,a.total_questions-a.correct_answers-a.incorrect_answers) AS unanswered,
        CASE WHEN a.status='submitted' THEN (
          SELECT coalesce(jsonb_agg(to_jsonb(s) ORDER BY s.first_order), '[]'::JSONB)
          FROM (
            SELECT coalesce(substring(q.question_text FROM '^\[([^]]+)\]'),'All questions') AS section,
              min(q.display_order) AS first_order, count(*) AS total_questions,
              sum(q.marks) AS total_marks, coalesce(sum(ans.marks_awarded),0) AS score,
              count(*) FILTER (WHERE ans.is_correct) AS correct,
              count(*) FILTER (WHERE ans.is_correct=FALSE) AS incorrect,
              count(*) FILTER (WHERE ans.id IS NULL) AS unanswered
            FROM public.mock_questions q
            LEFT JOIN public.mock_attempt_answers ans ON ans.question_id=q.id AND ans.attempt_id=a.id
            WHERE q.mock_test_id=a.mock_test_id
            GROUP BY coalesce(substring(q.question_text FROM '^\[([^]]+)\]'),'All questions')
          ) s
        ) ELSE '[]'::JSONB END AS sections
      FROM public.mock_attempts a JOIN public.mock_tests t ON t.id=a.mock_test_id
      WHERE a.student_id=v_user AND (p_attempt_id IS NULL OR a.id=p_attempt_id)
      ORDER BY a.started_at DESC, a.id
      LIMIT least(greatest(coalesce(p_limit,20),1),100) OFFSET greatest(coalesce(p_offset,0),0)
    ) r;
    RETURN v_rows;
END;
$$;
REVOKE ALL ON FUNCTION public.get_mock_attempt_history(INT,INT,UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_mock_attempt_history(INT,INT,UUID) TO authenticated;
