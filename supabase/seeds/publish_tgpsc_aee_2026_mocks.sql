-- Run in Supabase SQL Editor AFTER importing both separate AEE 2026 mock seeds.
-- Makes only these two practice mocks visible. Does not change questions or attempts.
BEGIN;
DO $publish$
DECLARE t RECORD; v_count INT := 0;
BEGIN
 FOR t IN SELECT * FROM public.mock_tests
 WHERE title IN ('TGPSC AEE 2026 - General Studies Full Length Mock 01',
                 'TGPSC AEE 2026 - Civil Engineering Full Length Mock 01')
 FOR UPDATE LOOP
  v_count := v_count + 1;
  IF t.duration_minutes<>150
   OR t.total_marks<>(CASE WHEN t.title LIKE '%General Studies%' THEN 150 ELSE 300 END)
   OR (SELECT count(*) FROM public.mock_questions WHERE mock_test_id=t.id)<>150
   OR (SELECT count(DISTINCT display_order) FROM public.mock_questions WHERE mock_test_id=t.id)<>150
   OR (SELECT sum(marks) FROM public.mock_questions WHERE mock_test_id=t.id)<>t.total_marks THEN
   RAISE EXCEPTION 'Incomplete or inconsistent mock: %. Rerun its seed/validation before publishing.',t.title;
  END IF;
 END LOOP;
 IF v_count<>2 THEN
  RAISE EXCEPTION 'Expected both mock seeds to be imported; found % matching tests. No publication changes made.',v_count;
 END IF;
 UPDATE public.mock_tests SET is_published=TRUE
 WHERE title IN ('TGPSC AEE 2026 - General Studies Full Length Mock 01',
                 'TGPSC AEE 2026 - Civil Engineering Full Length Mock 01');
END;
$publish$;
COMMIT;
SELECT title,is_published,duration_minutes,total_marks
FROM public.mock_tests
WHERE title IN ('TGPSC AEE 2026 - General Studies Full Length Mock 01',
                'TGPSC AEE 2026 - Civil Engineering Full Length Mock 01');
