-- Run in Supabase SQL Editor to reconcile an earlier '- Revised' import.
-- Keeps the matching-question edition under the original title; archives duplicates.
-- No questions, answers, attempts or scores are deleted or reassigned.
BEGIN;
LOCK TABLE public.mock_attempts IN SHARE MODE;
LOCK TABLE public.mock_tests IN SHARE ROW EXCLUSIVE MODE;
DO $reconcile$
DECLARE
 v_title TEXT;
 v_keep UUID;
 v_candidate RECORD;
BEGIN
 FOREACH v_title IN ARRAY ARRAY[
  'TGPSC AEE 2026 - General Studies Full Length Mock 01',
  'TGPSC AEE 2026 - Civil Engineering Full Length Mock 01'
 ] LOOP
  PERFORM pg_advisory_xact_lock(hashtext(v_title));
  -- Prefer an already-updated original; otherwise retain the earlier revised edition.
  SELECT t.id INTO v_keep FROM public.mock_tests t
  WHERE t.title IN (v_title,v_title||' - Revised')
   AND t.duration_minutes=150
   AND t.total_marks=CASE WHEN v_title LIKE '%General Studies%' THEN 150 ELSE 300 END
   AND (SELECT count(*) FROM public.mock_questions q WHERE q.mock_test_id=t.id)=150
   AND (SELECT count(DISTINCT q.display_order) FROM public.mock_questions q WHERE q.mock_test_id=t.id)=150
   AND (SELECT sum(q.marks) FROM public.mock_questions q WHERE q.mock_test_id=t.id)=t.total_marks
   AND (SELECT count(*) FROM public.mock_questions q WHERE q.mock_test_id=t.id
        AND q.question_text LIKE '%Match List I%')=3
  ORDER BY (t.title=v_title) DESC,t.created_at,t.id LIMIT 1;
  IF v_keep IS NULL THEN
   RAISE EXCEPTION 'No complete matching-question edition found for %. Run the matching revision first.',v_title;
  END IF;
  FOR v_candidate IN SELECT id FROM public.mock_tests
   WHERE title IN (v_title,v_title||' - Revised') AND id<>v_keep LOOP
   -- Unpublished tests cannot be resumed by the current saved-session RPC.
   IF EXISTS(SELECT 1 FROM public.mock_attempts WHERE mock_test_id=v_candidate.id AND status='in_progress') THEN
    RAISE EXCEPTION 'Duplicate % has in-progress attempts. Clear your own testing attempts with clear_my_aee_2026_inprogress.sql first; other users must finish their attempts.',v_candidate.id;
   END IF;
   UPDATE public.mock_tests
   SET title=v_title||' - Archived edition '||v_candidate.id::TEXT,is_published=FALSE
   WHERE id=v_candidate.id;
  END LOOP;
  UPDATE public.mock_tests SET title=v_title,is_published=TRUE WHERE id=v_keep;
 END LOOP;
END;
$reconcile$;
COMMIT;
SELECT id,title,is_published FROM public.mock_tests
WHERE title LIKE 'TGPSC AEE 2026 - %Full Length Mock 01%'
ORDER BY title;
