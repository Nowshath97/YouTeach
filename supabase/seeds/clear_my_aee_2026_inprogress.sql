-- Run in Supabase SQL Editor. Replace YOUR_SIGN_IN_EMAIL below with your login email.
-- Deletes only this account's in-progress attempts on the two named mocks.
-- Completed attempts and other users' attempts are preserved.
BEGIN;
DO $cleanup$
DECLARE
 v_email TEXT := 'YOUR_SIGN_IN_EMAIL';
 v_user UUID;
 v_deleted INT;
 v_remaining INT;
BEGIN
 IF v_email='YOUR_SIGN_IN_EMAIL' OR length(btrim(v_email))=0 THEN
  RAISE EXCEPTION 'Replace YOUR_SIGN_IN_EMAIL with your account email before running';
 END IF;
 SELECT id INTO v_user FROM auth.users WHERE lower(email)=lower(btrim(v_email));
 IF v_user IS NULL THEN RAISE EXCEPTION 'No account found for that email; nothing deleted'; END IF;

 DELETE FROM public.mock_attempts a USING public.mock_tests t
 WHERE a.mock_test_id=t.id AND a.student_id=v_user AND a.status='in_progress'
  AND t.title IN ('TGPSC AEE 2026 - General Studies Full Length Mock 01',
                  'TGPSC AEE 2026 - Civil Engineering Full Length Mock 01',
                  'TGPSC AEE 2026 - General Studies Full Length Mock 01 - Revised',
                  'TGPSC AEE 2026 - Civil Engineering Full Length Mock 01 - Revised');
 GET DIAGNOSTICS v_deleted = ROW_COUNT;

 SELECT count(*) INTO v_remaining FROM public.mock_attempts a
 JOIN public.mock_tests t ON t.id=a.mock_test_id
 WHERE t.title IN ('TGPSC AEE 2026 - General Studies Full Length Mock 01',
                   'TGPSC AEE 2026 - Civil Engineering Full Length Mock 01');
 RAISE NOTICE 'Deleted % in-progress testing attempts. % attempts remain across these mocks.',v_deleted,v_remaining;
 IF v_remaining>0 THEN
  RAISE NOTICE 'Matching-question replacement may still be blocked by preserved completed or other users attempts.';
 END IF;
END;
$cleanup$;
COMMIT;
