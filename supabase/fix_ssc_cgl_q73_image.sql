-- Deploy updated app assets, then run this against the existing mock tables.
UPDATE public.mock_questions q
SET question_text = '[Quantitative Aptitude] If x = √((2 + √3)/(2 − √3)), determine the value of x² + x − 9.',
    options = jsonb_set(q.options, '{0,question_image}',
    '{"url":"/images/ssc-cgl/q73-question.svg","replaces_text":true,"alt":"If x = √((2 + √3)/(2 − √3)), determine x² + x − 9."}'::JSONB, TRUE)
FROM public.mock_tests t
WHERE q.mock_test_id = t.id
  AND t.title = 'SSC CGL Tier-I Similar-Based Paper 12 Sept, 2025 Shift 2'
  AND q.display_order = 73;
