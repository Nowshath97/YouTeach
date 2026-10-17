-- Run after social_feed.sql. Personal revision saves and feed controls.
BEGIN;
CREATE TABLE IF NOT EXISTS public.member_feed_preferences (
 user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
 kind TEXT NOT NULL CHECK(kind IN ('post','quiz')),item_id UUID NOT NULL,
 saved BOOLEAN NOT NULL DEFAULT FALSE,hidden BOOLEAN NOT NULL DEFAULT FALSE,
 updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),PRIMARY KEY(user_id,kind,item_id)
);
ALTER TABLE public.member_feed_preferences ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.member_feed_preferences FROM anon,authenticated;
CREATE OR REPLACE FUNCTION public.social_set_feed_preference(p_kind TEXT,p_id UUID,p_action TEXT,p_enabled BOOLEAN)
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$ BEGIN
 IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Sign in to manage your feed'; END IF;
 IF p_action IS NULL OR p_action NOT IN ('save','hide') OR p_enabled IS NULL THEN RAISE EXCEPTION 'Invalid feed action'; END IF;
 IF NOT ((p_kind='post' AND EXISTS(SELECT 1 FROM public.member_posts WHERE id=p_id)) OR
 (p_kind='quiz' AND EXISTS(SELECT 1 FROM public.community_quizzes WHERE id=p_id))) THEN RAISE EXCEPTION 'Post or quiz unavailable'; END IF;
 INSERT INTO public.member_feed_preferences(user_id,kind,item_id,saved,hidden)
 VALUES(auth.uid(),p_kind,p_id,CASE WHEN p_action='save' THEN p_enabled ELSE FALSE END,CASE WHEN p_action='hide' THEN p_enabled ELSE FALSE END)
 ON CONFLICT(user_id,kind,item_id) DO UPDATE SET
 saved=CASE WHEN p_action='save' THEN p_enabled ELSE member_feed_preferences.saved END,
 hidden=CASE WHEN p_action='hide' THEN p_enabled ELSE member_feed_preferences.hidden END,updated_at=now();
 RETURN (SELECT jsonb_build_object('saved',saved,'hidden',hidden) FROM public.member_feed_preferences WHERE user_id=auth.uid() AND kind=p_kind AND item_id=p_id);
END; $$;
CREATE OR REPLACE FUNCTION public.social_learning_feed(p_author UUID DEFAULT NULL,p_filter TEXT DEFAULT 'following',p_search TEXT DEFAULT '',p_offset INT DEFAULT 0)
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$ BEGIN
 IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Sign in to view your study feed'; END IF;
 IF p_filter IS NULL OR p_filter NOT IN ('following','post','quiz','saved','hidden') THEN RAISE EXCEPTION 'Invalid feed filter'; END IF;
 RETURN coalesce((SELECT jsonb_agg(to_jsonb(t) ORDER BY t.created_at DESC,t.id DESC) FROM (
 SELECT f.*,p.display_name,p.headline,coalesce(pref.saved,FALSE) AS saved,coalesce(pref.hidden,FALSE) AS hidden
 FROM (
 SELECT id,author_id,body,''::TEXT AS title,''::TEXT AS topic,0 AS question_count,created_at,'post'::TEXT AS kind FROM public.member_posts
 UNION ALL
 SELECT id,author_id,''::TEXT,title,topic,jsonb_array_length(questions),created_at,'quiz'::TEXT FROM public.community_quizzes
 ) f JOIN public.member_profiles p ON p.id=f.author_id
 LEFT JOIN public.member_feed_preferences pref ON pref.user_id=auth.uid() AND pref.kind=f.kind AND pref.item_id=f.id
 WHERE (p_author IS NULL OR f.author_id=p_author)
 AND (p_filter IN ('saved','hidden') OR p_author IS NOT NULL OR f.author_id=auth.uid()
 OR EXISTS(SELECT 1 FROM public.member_follows WHERE follower_id=auth.uid() AND following_id=f.author_id))
 AND (p_filter NOT IN ('post','quiz') OR f.kind=p_filter)
 AND (p_filter<>'saved' OR coalesce(pref.saved,FALSE))
 AND (CASE WHEN p_filter='hidden' THEN coalesce(pref.hidden,FALSE)
 WHEN p_filter='saved' THEN TRUE ELSE NOT coalesce(pref.hidden,FALSE) END)
 AND (coalesce(p_search,'')='' OR position(lower(left(p_search,150)) IN lower(f.body||' '||f.title||' '||f.topic||' '||p.display_name))>0)
 ORDER BY f.created_at DESC,f.id DESC LIMIT 20 OFFSET greatest(0,least(coalesce(p_offset,0),100000))) t),'[]'::JSONB);
END; $$;
REVOKE ALL ON FUNCTION public.social_set_feed_preference(TEXT,UUID,TEXT,BOOLEAN),public.social_learning_feed(UUID,TEXT,TEXT,INT) FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION public.social_set_feed_preference(TEXT,UUID,TEXT,BOOLEAN),public.social_learning_feed(UUID,TEXT,TEXT,INT) TO authenticated;
COMMIT;
