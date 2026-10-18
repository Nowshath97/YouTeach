-- Prerequisite: mock_test_setup.sql. Roles are assigned only through trusted SQL.
BEGIN;
CREATE TABLE IF NOT EXISTS public.app_user_roles (
 user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
 role TEXT NOT NULL DEFAULT 'student' CHECK (role IN ('student','admin'))
);
ALTER TABLE public.app_user_roles ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.app_user_roles FROM PUBLIC, anon, authenticated;
CREATE INDEX IF NOT EXISTS idx_mock_attempts_test_student ON public.mock_attempts(mock_test_id,student_id);

CREATE OR REPLACE FUNCTION public.get_my_app_role() RETURNS TEXT
LANGUAGE sql STABLE SECURITY DEFINER SET search_path='' AS $$
 SELECT CASE WHEN auth.uid() IS NULL THEN 'student'
 ELSE coalesce((SELECT role FROM public.app_user_roles WHERE user_id=auth.uid()),'student') END;
$$;

CREATE OR REPLACE FUNCTION public.admin_mock_summary() RETURNS JSONB
LANGUAGE plpgsql STABLE SECURITY DEFINER SET search_path='' AS $$
BEGIN
 IF auth.uid() IS NULL OR public.get_my_app_role()<>'admin' THEN
  RAISE EXCEPTION 'Administrator access required' USING ERRCODE='42501';
 END IF;
 RETURN (SELECT coalesce(jsonb_agg(to_jsonb(s) ORDER BY s.title),'[]'::jsonb) FROM (
  SELECT t.id,t.title,t.is_published,t.total_marks,
   count(a.id) AS attempts,count(DISTINCT a.student_id) AS learners,
   count(a.id) FILTER(WHERE a.status='submitted') AS submitted,
   count(a.id) FILTER(WHERE a.status='expired') AS expired,
   count(a.id) FILTER(WHERE a.status='in_progress') AS in_progress,
   round(avg(a.score) FILTER(WHERE a.status IN ('submitted','expired')),2) AS average_score,
   max(a.score) FILTER(WHERE a.status IN ('submitted','expired')) AS highest_score
  FROM public.mock_tests t LEFT JOIN public.mock_attempts a ON a.mock_test_id=t.id
   AND EXISTS (SELECT 1 FROM auth.users u WHERE u.id=a.student_id
    AND lower(coalesce(u.email,''))<>'testnaushad@gmail.com')
  GROUP BY t.id
 ) s);
END; $$;

CREATE OR REPLACE FUNCTION public.admin_mock_attempts(
 p_test UUID DEFAULT NULL,p_status TEXT DEFAULT NULL,p_search TEXT DEFAULT '',
 p_page INT DEFAULT 0
) RETURNS JSONB LANGUAGE plpgsql STABLE SECURITY DEFINER SET search_path='' AS $$
DECLARE v_total BIGINT; v_rows JSONB;
BEGIN
 IF auth.uid() IS NULL OR public.get_my_app_role()<>'admin' THEN
  RAISE EXCEPTION 'Administrator access required' USING ERRCODE='42501';
 END IF;
 IF p_page IS NULL OR p_page<0 OR p_page>1000000 THEN RAISE EXCEPTION 'Invalid page'; END IF;
 IF p_status IS NOT NULL AND p_status NOT IN ('in_progress','submitted','expired') THEN RAISE EXCEPTION 'Invalid status'; END IF;
 SELECT count(*) INTO v_total FROM public.mock_attempts a
 JOIN auth.users u ON u.id=a.student_id
 WHERE lower(coalesce(u.email,''))<>'testnaushad@gmail.com'
 AND (p_test IS NULL OR a.mock_test_id=p_test) AND (p_status IS NULL OR a.status=p_status)
 AND (coalesce(p_search,'')='' OR position(lower(left(p_search,200)) IN lower(coalesce(u.email,'')))>0);
 SELECT coalesce(jsonb_agg(to_jsonb(r) ORDER BY r.started_at DESC,r.id DESC),'[]'::jsonb) INTO v_rows FROM (
  SELECT a.id,a.mock_test_id,t.title,a.student_id,u.email,
   a.status,a.started_at,a.submitted_at,a.time_taken_seconds,t.total_marks,
   CASE WHEN a.status IN ('submitted','expired') THEN a.score ELSE NULL END AS score
  FROM public.mock_attempts a JOIN auth.users u ON u.id=a.student_id
  JOIN public.mock_tests t ON t.id=a.mock_test_id
  WHERE lower(coalesce(u.email,''))<>'testnaushad@gmail.com'
 AND (p_test IS NULL OR a.mock_test_id=p_test) AND (p_status IS NULL OR a.status=p_status)
  AND (coalesce(p_search,'')='' OR position(lower(left(p_search,200)) IN lower(coalesce(u.email,'')))>0)
  ORDER BY a.started_at DESC,a.id DESC LIMIT 50 OFFSET p_page*50
 ) r;
 RETURN jsonb_build_object('total',v_total,'rows',v_rows,'page_size',50);
END; $$;

-- Public catalogue statistics contain no identities, answers or scores.
-- Count each learner once per mock. Repeated testing/admin sessions do not inflate popularity.
CREATE OR REPLACE FUNCTION public.mock_popularity() RETURNS JSONB
LANGUAGE plpgsql STABLE SECURITY DEFINER SET search_path='' AS $$
BEGIN
 IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Sign in required' USING ERRCODE='42501'; END IF;
 RETURN (WITH eligible AS (
  SELECT DISTINCT a.mock_test_id,a.student_id
  FROM public.mock_attempts a JOIN public.mock_tests t ON t.id=a.mock_test_id
  JOIN auth.users u ON u.id=a.student_id
  WHERE t.is_published AND lower(coalesce(u.email,''))<>'testnaushad@gmail.com'
  AND NOT EXISTS(SELECT 1 FROM public.app_user_roles r WHERE r.user_id=a.student_id AND r.role='admin')
 ), denominator AS (SELECT count(DISTINCT student_id) AS n FROM eligible), stats AS (
  SELECT t.id AS mock_test_id,count(e.student_id) AS learners,d.n AS total_learners,
   CASE WHEN d.n>0 THEN round(count(e.student_id)*100.0/d.n,1) ELSE 0 END AS learner_percentage
  FROM public.mock_tests t CROSS JOIN denominator d LEFT JOIN eligible e ON e.mock_test_id=t.id
  WHERE t.is_published GROUP BY t.id,d.n
 ) SELECT coalesce(jsonb_agg(to_jsonb(stats)),'[]'::jsonb) FROM stats);
END; $$;

REVOKE ALL ON FUNCTION public.get_my_app_role(),public.admin_mock_summary(),public.admin_mock_attempts(UUID,TEXT,TEXT,INT),public.mock_popularity() FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION public.get_my_app_role(),public.admin_mock_summary(),public.admin_mock_attempts(UUID,TEXT,TEXT,INT),public.mock_popularity() TO authenticated;
COMMIT;
