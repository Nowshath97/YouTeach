-- Deploy the updated app first, then apply to existing imported questions.
UPDATE public.mock_questions q
SET question_text = '[Quantitative Aptitude] Evaluate the continued fraction:',
    options = jsonb_set(q.options, '{0,question_image}',
    '{"url":"/images/ssc-cgl/q53-equation.svg","replaces_text":true,"alt":"Evaluate the continued fraction: x = 2 + 1/(3 + 1/(4 + 1/2))"}'::JSONB, TRUE)
FROM public.mock_tests t
WHERE q.mock_test_id = t.id
  AND t.title = 'SSC CGL Tier-I Similar-Based Paper 12 Sept, 2025 Shift 2'
  AND q.display_order = 53;
