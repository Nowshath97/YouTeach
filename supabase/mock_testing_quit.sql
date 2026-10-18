-- Run after mock_test_setup.sql. Discard active testing attempts for one account only.
BEGIN;
CREATE OR REPLACE FUNCTION public.quit_testing_mock_attempts()
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$
DECLARE v_user UUID := auth.uid(); v_email TEXT; v_count INT;
BEGIN
 IF v_user IS NULL THEN RAISE EXCEPTION 'Sign in to quit testing attempts'; END IF;
 SELECT lower(email) INTO v_email FROM auth.users WHERE id=v_user;
 IF v_email IS DISTINCT FROM 'testnaushad@gmail.com' THEN
  RAISE EXCEPTION 'Quit is available only to the designated testing account';
 END IF;
 -- Serialize against concurrent attempt creation/saves while this cleanup runs.
 LOCK TABLE public.mock_attempts IN SHARE ROW EXCLUSIVE MODE;
 DELETE FROM public.mock_attempts WHERE student_id=v_user AND status='in_progress';
 GET DIAGNOSTICS v_count=ROW_COUNT;
 RETURN jsonb_build_object('deleted_count',v_count);
END;
$$;
REVOKE ALL ON FUNCTION public.quit_testing_mock_attempts() FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION public.quit_testing_mock_attempts() TO authenticated;
COMMIT;
