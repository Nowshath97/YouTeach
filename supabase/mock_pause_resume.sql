-- Run LAST, after mock_simulation_functions.sql and gate_2025_grading.sql (if used).
-- Adds saved sessions without changing submitted answers or scores.
BEGIN;
ALTER TABLE public.mock_attempts
    ADD COLUMN IF NOT EXISTS paused_at TIMESTAMPTZ,
    ADD COLUMN IF NOT EXISTS paused_duration INTERVAL NOT NULL DEFAULT INTERVAL '0 seconds',
    ADD COLUMN IF NOT EXISTS draft_answers JSONB NOT NULL DEFAULT '{}'::JSONB,
    ADD COLUMN IF NOT EXISTS draft_state JSONB NOT NULL DEFAULT '{}'::JSONB,
    ADD COLUMN IF NOT EXISTS session_token UUID;

CREATE OR REPLACE FUNCTION public.get_saved_mock_attempts()
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$
DECLARE v_user UUID := auth.uid(); v_rows JSONB;
BEGIN
    IF v_user IS NULL THEN RAISE EXCEPTION 'Sign in to view saved tests'; END IF;
    SELECT coalesce(jsonb_agg(to_jsonb(s)), '[]'::JSONB) INTO v_rows FROM (
        SELECT DISTINCT ON (a.mock_test_id) a.id AS attempt_id,a.mock_test_id,
            a.paused_at IS NOT NULL AS is_paused,
            greatest(0,t.duration_minutes*60-floor(extract(epoch FROM
                (coalesce(a.paused_at,now())-a.started_at-a.paused_duration)))::INT) AS remaining_seconds,
            (SELECT count(*) FROM jsonb_object_keys(a.draft_answers)) AS answered_count
        FROM public.mock_attempts a JOIN public.mock_tests t ON t.id=a.mock_test_id
        WHERE a.student_id=v_user AND a.status='in_progress' AND t.is_published
          AND coalesce(a.paused_at,now()) < a.started_at+make_interval(mins=>t.duration_minutes)+a.paused_duration
        ORDER BY a.mock_test_id,a.started_at DESC,a.id
    ) s;
    RETURN v_rows;
END;
$$;

CREATE OR REPLACE FUNCTION public.open_mock_attempt(
    p_mock_test_id UUID, p_attempt_id UUID DEFAULT NULL, p_restart BOOLEAN DEFAULT FALSE
)
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$
DECLARE v_user UUID := auth.uid(); v_attempt public.mock_attempts%ROWTYPE;
    v_test public.mock_tests%ROWTYPE; v_id UUID; v_payload JSONB; v_token UUID;
BEGIN
    IF v_user IS NULL THEN RAISE EXCEPTION 'Sign in to start or resume a test'; END IF;
    PERFORM pg_advisory_xact_lock(hashtext(v_user::TEXT||p_mock_test_id::TEXT));
    SELECT * INTO v_test FROM public.mock_tests WHERE id=p_mock_test_id AND is_published;
    IF NOT FOUND THEN RAISE EXCEPTION 'Mock test is not available'; END IF;
    IF p_restart THEN
        -- Retain prior attempt records; a new attempt gets the full duration.
        UPDATE public.mock_attempts SET status='expired',submitted_at=now(),
            time_taken_seconds=greatest(0,floor(extract(epoch FROM (coalesce(paused_at,now())-started_at-paused_duration)))::INT)
        WHERE mock_test_id=p_mock_test_id AND student_id=v_user AND status='in_progress';
    ELSE
        SELECT * INTO v_attempt FROM public.mock_attempts
        WHERE mock_test_id=p_mock_test_id AND student_id=v_user AND status='in_progress'
          AND (p_attempt_id IS NULL OR id=p_attempt_id)
        ORDER BY started_at DESC,id LIMIT 1 FOR UPDATE;
        IF p_attempt_id IS NOT NULL AND v_attempt.id IS NULL THEN
            RAISE EXCEPTION 'Saved test is not available for this account';
        END IF;
        IF v_attempt.id IS NOT NULL AND coalesce(v_attempt.paused_at,now()) >=
            v_attempt.started_at+make_interval(mins=>v_test.duration_minutes)+v_attempt.paused_duration THEN
            UPDATE public.mock_attempts SET status='expired',submitted_at=now() WHERE id=v_attempt.id;
            RETURN jsonb_build_object('status','expired');
        END IF;
    END IF;
    IF p_restart OR v_attempt.id IS NULL THEN
        v_payload := public.start_mock_attempt(p_mock_test_id);
        v_id := (v_payload->>'attempt_id')::UUID;
    ELSE
        v_id := v_attempt.id;
        UPDATE public.mock_attempts SET
            paused_duration=paused_duration+CASE WHEN paused_at IS NULL THEN INTERVAL '0 seconds' ELSE now()-paused_at END,
            paused_at=NULL WHERE id=v_id;
    END IF;
    v_token := gen_random_uuid();
    UPDATE public.mock_attempts SET session_token=v_token WHERE id=v_id RETURNING * INTO v_attempt;
    SELECT coalesce(jsonb_agg(jsonb_build_object('id',id,'question_text',question_text,
        'question_type',question_type,'options',options) ORDER BY display_order,id),'[]'::JSONB)
    INTO v_payload FROM public.mock_questions WHERE mock_test_id=p_mock_test_id;
    RETURN jsonb_build_object('status','in_progress','attempt_id',v_id,'mock_test_id',p_mock_test_id,
        'session_token',v_token,'test_title',v_test.title,'test_description',v_test.description,
        'total_marks',v_test.total_marks,'duration_minutes',v_test.duration_minutes,'questions',v_payload,
        'answers',v_attempt.draft_answers,'exam_state',v_attempt.draft_state,
        'remaining_seconds',greatest(0,v_test.duration_minutes*60-floor(extract(epoch FROM
            (now()-v_attempt.started_at-v_attempt.paused_duration)))::INT));
END;
$$;

CREATE OR REPLACE FUNCTION public.save_mock_attempt(
    p_attempt_id UUID,p_session_token UUID,p_answers JSONB,p_state JSONB DEFAULT '{}'::JSONB,p_pause BOOLEAN DEFAULT FALSE
)
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$
DECLARE v_user UUID := auth.uid(); v_attempt public.mock_attempts%ROWTYPE; v_duration INT; v_remaining INT;
BEGIN
    IF v_user IS NULL THEN RAISE EXCEPTION 'Sign in to save a test'; END IF;
    IF jsonb_typeof(p_answers) IS DISTINCT FROM 'object' OR jsonb_typeof(p_state) IS DISTINCT FROM 'object'
       OR octet_length(p_answers::TEXT)>200000 OR octet_length(p_state::TEXT)>100000 THEN
        RAISE EXCEPTION 'Invalid saved test data';
    END IF;
    SELECT * INTO v_attempt FROM public.mock_attempts WHERE id=p_attempt_id AND student_id=v_user FOR UPDATE;
    IF NOT FOUND OR v_attempt.status<>'in_progress' OR v_attempt.paused_at IS NOT NULL
       OR v_attempt.session_token IS DISTINCT FROM p_session_token OR p_session_token IS NULL THEN
        RAISE EXCEPTION 'This session is no longer active. Resume the test from Mock Tests';
    END IF;
    SELECT duration_minutes INTO v_duration FROM public.mock_tests WHERE id=v_attempt.mock_test_id;
    v_remaining := greatest(0,v_duration*60-floor(extract(epoch FROM
        (now()-v_attempt.started_at-v_attempt.paused_duration)))::INT);
    IF v_remaining=0 THEN RAISE EXCEPTION 'Time is up; submit this test'; END IF;
    IF EXISTS (SELECT 1 FROM jsonb_each(p_answers) a WHERE jsonb_typeof(a.value)<>'string'
        OR NOT EXISTS (SELECT 1 FROM public.mock_questions q WHERE q.mock_test_id=v_attempt.mock_test_id AND q.id::TEXT=a.key)) THEN
        RAISE EXCEPTION 'Saved responses contain an invalid question or answer';
    END IF;
    UPDATE public.mock_attempts SET draft_answers=p_answers,draft_state=p_state,
        paused_at=CASE WHEN p_pause THEN now() ELSE NULL END
    WHERE id=p_attempt_id;
    RETURN jsonb_build_object('is_paused',p_pause,'remaining_seconds',v_remaining,'saved_at',now());
END;
$$;

-- Patch ONLY the clock accounting in the installed grader, retaining its exact
-- MCQ/MSQ/NAT evaluation (including GATE range keys). Fail if it is unfamiliar.
DO $timing$
DECLARE v_definition TEXT; v_original TEXT;
BEGIN
    SELECT pg_get_functiondef('public.submit_mock_attempt(uuid,jsonb)'::regprocedure) INTO v_original;
    IF position('v_attempt.paused_duration' IN v_original)>0 THEN RETURN; END IF;
    IF position('v_attempt.started_at + make_interval(mins => v_duration)' IN v_original)=0
       OR position('(now() - started_at)' IN v_original)=0 THEN
        RAISE EXCEPTION 'Unrecognized submit_mock_attempt timing; review the installed grader before applying pause support';
    END IF;
    v_definition := replace(v_original,
        'v_attempt.started_at + make_interval(mins => v_duration)',
        'v_attempt.started_at + make_interval(mins => v_duration) + v_attempt.paused_duration');
    v_definition := replace(v_definition,'(now() - started_at)','(now() - started_at - paused_duration)');
    v_definition := replace(v_definition,
        'IF NOT FOUND OR v_attempt.status <> ''in_progress'' THEN',
        'IF NOT FOUND OR v_attempt.status <> ''in_progress'' OR v_attempt.paused_at IS NOT NULL THEN');
    EXECUTE v_definition;
END;
$timing$;

CREATE OR REPLACE FUNCTION public.submit_saved_mock_attempt(p_attempt_id UUID,p_session_token UUID,p_answers JSONB)
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$
DECLARE v_attempt public.mock_attempts%ROWTYPE;
BEGIN
    SELECT * INTO v_attempt FROM public.mock_attempts
    WHERE id=p_attempt_id AND student_id=auth.uid() FOR UPDATE;
    IF NOT FOUND OR p_session_token IS NULL OR v_attempt.session_token IS DISTINCT FROM p_session_token
       OR v_attempt.paused_at IS NOT NULL OR v_attempt.status<>'in_progress' THEN
        RAISE EXCEPTION 'This session is no longer active. Resume the test from Mock Tests';
    END IF;
    RETURN public.submit_mock_attempt(p_attempt_id,p_answers);
END;
$$;

REVOKE ALL ON FUNCTION public.get_saved_mock_attempts() FROM PUBLIC,anon;
REVOKE ALL ON FUNCTION public.open_mock_attempt(UUID,UUID,BOOLEAN) FROM PUBLIC,anon;
REVOKE ALL ON FUNCTION public.save_mock_attempt(UUID,UUID,JSONB,JSONB,BOOLEAN) FROM PUBLIC,anon;
REVOKE ALL ON FUNCTION public.submit_saved_mock_attempt(UUID,UUID,JSONB) FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION public.get_saved_mock_attempts() TO authenticated;
GRANT EXECUTE ON FUNCTION public.open_mock_attempt(UUID,UUID,BOOLEAN) TO authenticated;
GRANT EXECUTE ON FUNCTION public.save_mock_attempt(UUID,UUID,JSONB,JSONB,BOOLEAN) TO authenticated;
GRANT EXECUTE ON FUNCTION public.submit_saved_mock_attempt(UUID,UUID,JSONB) TO authenticated;
COMMIT;
