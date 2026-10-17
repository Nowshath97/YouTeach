-- Correct the first-draft placeholder without replacing questions or attempt history.
BEGIN;
UPDATE public.mock_questions q
SET options = jsonb_set(q.options, '{2,text}', to_jsonb('x'::TEXT), FALSE)
FROM public.mock_tests t
WHERE q.mock_test_id = t.id
  AND t.title = 'SSC CGL Tier-I Similar-Based Paper 12 Sept, 2025 Shift 2'
  AND q.display_order = 51
  AND q.options->2->>'value' = 'C'
  AND q.options->2->>'text' LIKE '[Source option truncated:%';
COMMIT;

-- Verify the stored value after applying the correction.
SELECT t.title, q.display_order, q.options->2->>'text' AS option_c
FROM public.mock_questions q
JOIN public.mock_tests t ON t.id = q.mock_test_id
WHERE t.title = 'SSC CGL Tier-I Similar-Based Paper 12 Sept, 2025 Shift 2'
  AND q.display_order = 51;
