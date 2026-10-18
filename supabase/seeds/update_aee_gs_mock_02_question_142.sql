-- Removes only the hint from Full Length Mock 02 question 142.
BEGIN;
DO $update$
DECLARE v_count INT;
BEGIN
 IF (SELECT count(*) FROM public.mock_tests
     WHERE title='TGPSC AEE 2026 - General Studies Full Length Mock 02')<>1 THEN
  RAISE EXCEPTION 'Expected exactly one General Studies Full Length Mock 02';
 END IF;
 UPDATE public.mock_questions q
 SET question_text='[Logical Reasoning, Analytical Ability & Data Interpretation] Find the next term: 4, 9, 18, 31, 48, __.'
 FROM public.mock_tests t
 WHERE q.mock_test_id=t.id
 AND t.title='TGPSC AEE 2026 - General Studies Full Length Mock 02'
 AND q.display_order=142
 AND q.question_text IN (
 '[Logical Reasoning, Analytical Ability & Data Interpretation] Find the next term: 4, 9, 18, 31, 48, __. The pattern uses a constant increase in successive differences.',
 '[Logical Reasoning, Analytical Ability & Data Interpretation] Find the next term: 4, 9, 18, 31, 48, __.');
 GET DIAGNOSTICS v_count=ROW_COUNT;
 IF v_count<>1 THEN
  RAISE EXCEPTION 'Expected question 142 with the original number series; found %. Update cancelled.',v_count;
 END IF;
END;
$update$;
COMMIT;
