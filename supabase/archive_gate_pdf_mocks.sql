-- Optional: hide the obsolete PDF-backed mock entries without deleting questions or attempts.
-- The new Previous Papers section links directly to official PDFs and needs no SQL setup.
DO $archive$
BEGIN
    IF to_regclass('public.mock_tests') IS NOT NULL THEN
        UPDATE public.mock_tests SET is_published = FALSE
        WHERE title IN ('GATE 2025 Mechanical Engineering', 'GATE 2025 Electrical Engineering', 'GATE 2025 Civil Engineering - Session 1')
          AND description LIKE '%linked PDF viewer%';
    END IF;
END;
$archive$;
