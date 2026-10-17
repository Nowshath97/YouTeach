-- Run once in Supabase SQL Editor. Quizzes are separate from official mock tests.
BEGIN;
CREATE TABLE IF NOT EXISTS public.community_quizzes (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 author_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
 title TEXT NOT NULL CHECK (length(title) BETWEEN 1 AND 120),
 topic TEXT NOT NULL CHECK (length(topic) BETWEEN 1 AND 100),
 questions JSONB NOT NULL,
 created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
ALTER TABLE public.community_quizzes ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.community_quizzes FROM anon, authenticated;

CREATE OR REPLACE FUNCTION public.publish_community_quiz(p_title TEXT,p_topic TEXT,p_questions JSONB)
RETURNS UUID LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$
DECLARE q JSONB; opt JSONB; v_id UUID;
BEGIN
 IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Sign in to publish a quiz'; END IF;
 IF p_title IS NULL OR length(btrim(p_title)) NOT BETWEEN 1 AND 120
 OR p_topic IS NULL OR length(btrim(p_topic)) NOT BETWEEN 1 AND 100 THEN RAISE EXCEPTION 'Enter a title and topic'; END IF;
 IF jsonb_typeof(p_questions) IS DISTINCT FROM 'array' THEN RAISE EXCEPTION 'Questions must be an array'; END IF;
 IF jsonb_array_length(p_questions) NOT BETWEEN 1 AND 10 OR octet_length(p_questions::text)>50000 THEN RAISE EXCEPTION 'Use 1 to 10 questions'; END IF;
 FOR q IN SELECT value FROM jsonb_array_elements(p_questions) LOOP
  IF jsonb_typeof(q->'text') IS DISTINCT FROM 'string' OR length(btrim(q->>'text')) NOT BETWEEN 1 AND 1500
  OR jsonb_typeof(q->'options') IS DISTINCT FROM 'array' THEN RAISE EXCEPTION 'Invalid question'; END IF;
  IF jsonb_array_length(q->'options')<>4 OR coalesce(q->>'correct','') NOT IN ('0','1','2','3') THEN RAISE EXCEPTION 'Provide four choices and one correct answer'; END IF;
  FOR opt IN SELECT value FROM jsonb_array_elements(q->'options') LOOP
   IF jsonb_typeof(opt) IS DISTINCT FROM 'string' OR length(btrim(opt #>> '{}')) NOT BETWEEN 1 AND 500 THEN RAISE EXCEPTION 'Invalid answer choice'; END IF;
  END LOOP;
  IF (SELECT count(DISTINCT lower(btrim(value))) FROM jsonb_array_elements_text(q->'options'))<>4 THEN RAISE EXCEPTION 'Answer choices must be distinct'; END IF;
 END LOOP;
 INSERT INTO public.community_quizzes(author_id,title,topic,questions) VALUES(auth.uid(),btrim(p_title),btrim(p_topic),p_questions) RETURNING id INTO v_id;
 RETURN v_id;
END; $$;

CREATE OR REPLACE FUNCTION public.list_community_quizzes()
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$
BEGIN
 IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Sign in to view quizzes'; END IF;
 RETURN coalesce((SELECT jsonb_agg(to_jsonb(t)) FROM (
 SELECT id,title,topic,created_at,jsonb_array_length(questions) AS question_count
 FROM public.community_quizzes ORDER BY created_at DESC,id LIMIT 30) t),'[]'::JSONB);
END; $$;

CREATE OR REPLACE FUNCTION public.open_community_quiz(p_id UUID)
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$
DECLARE v_quiz public.community_quizzes%ROWTYPE;
BEGIN
 IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Sign in to take a quiz'; END IF;
 SELECT * INTO v_quiz FROM public.community_quizzes WHERE id=p_id;
 IF NOT FOUND THEN RAISE EXCEPTION 'Quiz unavailable'; END IF;
 RETURN jsonb_build_object('id',v_quiz.id,'title',v_quiz.title,'topic',v_quiz.topic,'questions',
 (SELECT jsonb_agg(jsonb_build_object('text',value->'text','options',value->'options') ORDER BY n)
 FROM jsonb_array_elements(v_quiz.questions) WITH ORDINALITY AS q(value,n)));
END; $$;

CREATE OR REPLACE FUNCTION public.grade_community_quiz(p_id UUID,p_answers JSONB)
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$
DECLARE v_questions JSONB; v_score INT;
BEGIN
 IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Sign in to submit a quiz'; END IF;
 SELECT questions INTO v_questions FROM public.community_quizzes WHERE id=p_id;
 IF NOT FOUND THEN RAISE EXCEPTION 'Quiz unavailable'; END IF;
 IF jsonb_typeof(p_answers) IS DISTINCT FROM 'object' OR octet_length(p_answers::text)>2000 THEN RAISE EXCEPTION 'Invalid responses'; END IF;
 SELECT count(*) INTO v_score FROM jsonb_array_elements(v_questions) WITH ORDINALITY q(value,n)
 WHERE p_answers->>((n-1)::text)=value->>'correct';
 RETURN jsonb_build_object('score',v_score,'total',jsonb_array_length(v_questions),'review',
 (SELECT jsonb_agg(jsonb_build_object('correct',value->>'correct') ORDER BY n)
 FROM jsonb_array_elements(v_questions) WITH ORDINALITY q(value,n)));
END; $$;

REVOKE ALL ON FUNCTION public.publish_community_quiz(TEXT,TEXT,JSONB), public.list_community_quizzes(), public.open_community_quiz(UUID), public.grade_community_quiz(UUID,JSONB) FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION public.publish_community_quiz(TEXT,TEXT,JSONB), public.list_community_quizzes(), public.open_community_quiz(UUID), public.grade_community_quiz(UUID,JSONB) TO authenticated;
COMMIT;
