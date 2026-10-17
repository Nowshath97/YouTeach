-- Minimal UUID-based prerequisites for the mock-test catalogue and secure RPCs.
-- Run in Supabase SQL Editor BEFORE mock_simulation_functions.sql and mock seeds.
-- Does not delete or convert existing tables or attempt history.
BEGIN;

-- The old schema.sql uses bigint subject IDs and cannot be mixed with UUID seeds.
DO $check$
BEGIN
    IF to_regclass('public.subjects') IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'public' AND table_name = 'subjects'
          AND column_name = 'id' AND udt_name = 'uuid'
    ) THEN
        RAISE EXCEPTION 'public.subjects uses an incompatible ID type. This setup requires UUID subjects; do not drop existing data. Use a fresh project or a separately reviewed legacy migration.';
    END IF;
END;
$check$;

CREATE TABLE IF NOT EXISTS public.engineering_branches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    code TEXT NOT NULL UNIQUE,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.subjects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    branch_id UUID NOT NULL REFERENCES public.engineering_branches(id),
    name TEXT NOT NULL,
    code TEXT NOT NULL UNIQUE,
    description TEXT,
    display_order INT NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (branch_id, name)
);

CREATE TABLE IF NOT EXISTS public.mock_tests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT,
    exam_type TEXT NOT NULL DEFAULT 'OTHER',
    subject_id UUID REFERENCES public.subjects(id),
    duration_minutes INT NOT NULL CHECK (duration_minutes > 0),
    total_marks NUMERIC(10,2) NOT NULL CHECK (total_marks >= 0),
    passing_marks NUMERIC(10,2) NOT NULL DEFAULT 0,
    is_published BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.mock_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    mock_test_id UUID NOT NULL REFERENCES public.mock_tests(id) ON DELETE CASCADE,
    question_text TEXT NOT NULL,
    question_type TEXT NOT NULL DEFAULT 'mcq' CHECK (question_type IN ('mcq', 'numerical', 'text')),
    options JSONB,
    correct_answer TEXT NOT NULL,
    marks NUMERIC(8,2) NOT NULL DEFAULT 1 CHECK (marks >= 0),
    negative_marks NUMERIC(8,2) NOT NULL DEFAULT 0 CHECK (negative_marks >= 0),
    display_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.mock_attempts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    mock_test_id UUID NOT NULL REFERENCES public.mock_tests(id),
    student_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    status TEXT NOT NULL DEFAULT 'in_progress' CHECK (status IN ('in_progress', 'submitted', 'expired')),
    total_questions INT NOT NULL DEFAULT 0,
    started_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    submitted_at TIMESTAMPTZ,
    score NUMERIC(10,2) NOT NULL DEFAULT 0,
    correct_answers INT NOT NULL DEFAULT 0,
    incorrect_answers INT NOT NULL DEFAULT 0,
    time_taken_seconds INT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS public.mock_attempt_answers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    attempt_id UUID NOT NULL REFERENCES public.mock_attempts(id) ON DELETE CASCADE,
    mock_test_id UUID NOT NULL REFERENCES public.mock_tests(id),
    question_id UUID NOT NULL REFERENCES public.mock_questions(id),
    selected_answer TEXT NOT NULL,
    is_correct BOOLEAN NOT NULL,
    marks_awarded NUMERIC(8,2) NOT NULL,
    UNIQUE (attempt_id, question_id)
);

CREATE INDEX IF NOT EXISTS idx_mock_questions_test_order ON public.mock_questions(mock_test_id, display_order);
CREATE INDEX IF NOT EXISTS idx_mock_attempts_student ON public.mock_attempts(student_id);

ALTER TABLE public.engineering_branches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subjects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mock_tests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mock_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mock_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mock_attempt_answers ENABLE ROW LEVEL SECURITY;

-- Only catalogue data is available directly. Questions and grading go through RPCs.
GRANT SELECT ON public.engineering_branches, public.subjects, public.mock_tests TO authenticated;
REVOKE ALL ON public.mock_questions, public.mock_attempts, public.mock_attempt_answers FROM anon, authenticated;

DO $policies$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'engineering_branches' AND policyname = 'mock_setup_active_branches') THEN
        CREATE POLICY mock_setup_active_branches ON public.engineering_branches FOR SELECT TO authenticated USING (is_active);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'subjects' AND policyname = 'mock_setup_active_subjects') THEN
        CREATE POLICY mock_setup_active_subjects ON public.subjects FOR SELECT TO authenticated USING (is_active);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'mock_tests' AND policyname = 'mock_setup_published_tests') THEN
        CREATE POLICY mock_setup_published_tests ON public.mock_tests FOR SELECT TO authenticated USING (is_published);
    END IF;
END;
$policies$;

COMMIT;
