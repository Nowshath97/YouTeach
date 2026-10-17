-- Read-only validation. Run after importing either the combined package or both separate seeds.
DO $validate$
DECLARE t RECORD; v_count INT := 0;
BEGIN
 FOR t IN SELECT * FROM public.mock_tests WHERE title IN
 ('TGPSC AEE 2026 - General Studies Full Length Mock 01',
  'TGPSC AEE 2026 - Civil Engineering Full Length Mock 01') LOOP
  v_count := v_count + 1;
  IF t.duration_minutes<>150 OR t.total_marks<>(CASE WHEN t.title LIKE '%General Studies%' THEN 150 ELSE 300 END)
   OR (SELECT count(*) FROM public.mock_questions WHERE mock_test_id=t.id)<>150
   OR (SELECT count(DISTINCT display_order) FROM public.mock_questions WHERE mock_test_id=t.id)<>150
   OR (SELECT min(display_order) FROM public.mock_questions WHERE mock_test_id=t.id)<>1
   OR (SELECT max(display_order) FROM public.mock_questions WHERE mock_test_id=t.id)<>150
   OR (SELECT sum(marks) FROM public.mock_questions WHERE mock_test_id=t.id)<>t.total_marks THEN
   RAISE EXCEPTION 'Paper structure invalid: %',t.title;
  END IF;
  IF EXISTS(SELECT 1 FROM public.mock_questions q WHERE q.mock_test_id=t.id AND
    (q.question_type<>'mcq' OR q.correct_answer NOT IN ('A','B','C','D')
     OR length(btrim(q.question_text))=0 OR coalesce(length(btrim(q.explanation)),0)=0
     OR q.negative_marks<>0 OR q.marks<>(CASE WHEN t.total_marks=150 THEN 1 ELSE 2 END)
     OR jsonb_typeof(q.options) IS DISTINCT FROM 'array')) THEN
   RAISE EXCEPTION 'Question fields invalid: %',t.title;
  END IF;
  IF EXISTS(SELECT 1 FROM public.mock_questions q WHERE q.mock_test_id=t.id AND
    (jsonb_array_length(q.options)<>4
     OR (SELECT count(DISTINCT o->>'value') FROM jsonb_array_elements(q.options) o
         WHERE o->>'value' IN ('A','B','C','D'))<>4
     OR (SELECT count(DISTINCT lower(btrim(o->>'text'))) FROM jsonb_array_elements(q.options) o
         WHERE jsonb_typeof(o->'text')='string' AND length(btrim(o->>'text'))>0)<>4)) THEN
   RAISE EXCEPTION 'Options invalid: %',t.title;
  END IF;
 END LOOP;
 IF v_count<>2 THEN RAISE EXCEPTION 'Expected exactly two separate mock records, found %',v_count; END IF;
 RAISE NOTICE 'Validated: GS 150 questions / 150 marks; Civil 150 questions / 300 marks; independent 150-minute papers. Content sign-off remains separate.';
END;
$validate$;
SELECT t.title,t.duration_minutes,t.total_marks,t.is_published,count(q.id) AS questions
FROM public.mock_tests t JOIN public.mock_questions q ON q.mock_test_id=t.id
WHERE t.title IN ('TGPSC AEE 2026 - General Studies Full Length Mock 01','TGPSC AEE 2026 - Civil Engineering Full Length Mock 01')
GROUP BY t.id ORDER BY t.total_marks;
