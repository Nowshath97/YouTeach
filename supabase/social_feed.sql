-- Run AFTER community_quizzes.sql. Preserves published quizzes and existing posts.
BEGIN;
CREATE TABLE IF NOT EXISTS public.member_profiles (
 id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
 display_name TEXT NOT NULL CHECK(length(btrim(display_name)) BETWEEN 1 AND 100),
 headline TEXT NOT NULL DEFAULT '' CHECK(length(headline)<=160),
 bio TEXT NOT NULL DEFAULT '' CHECK(length(bio)<=1000),
 created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
INSERT INTO public.member_profiles(id,display_name)
SELECT id,left(coalesce(nullif(btrim(raw_user_meta_data->>'full_name'),''),'Student'),100) FROM auth.users
ON CONFLICT(id) DO NOTHING;
CREATE OR REPLACE FUNCTION public.create_member_profile() RETURNS TRIGGER
LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$ BEGIN
 INSERT INTO public.member_profiles(id,display_name) VALUES(NEW.id,left(coalesce(nullif(btrim(NEW.raw_user_meta_data->>'full_name'),''),'Student'),100)) ON CONFLICT DO NOTHING;
 RETURN NEW; END; $$;
DROP TRIGGER IF EXISTS create_member_profile ON auth.users;
CREATE TRIGGER create_member_profile AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.create_member_profile();
CREATE TABLE IF NOT EXISTS public.member_follows (
 follower_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
 following_id UUID NOT NULL REFERENCES public.member_profiles(id) ON DELETE CASCADE,
 created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
 PRIMARY KEY(follower_id,following_id),CHECK(follower_id<>following_id)
);
CREATE INDEX IF NOT EXISTS member_followers_idx ON public.member_follows(following_id);
CREATE TABLE IF NOT EXISTS public.member_posts (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),author_id UUID NOT NULL REFERENCES public.member_profiles(id) ON DELETE CASCADE,
 body TEXT NOT NULL CHECK(length(btrim(body)) BETWEEN 1 AND 10000),created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS member_posts_author_idx ON public.member_posts(author_id,created_at DESC);
CREATE INDEX IF NOT EXISTS community_quizzes_author_idx ON public.community_quizzes(author_id,created_at DESC);
-- Import supported legacy schemas without replacing their original records.
DO $$ BEGIN
 IF EXISTS(SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='community_posts' AND column_name='student_id') THEN
  EXECUTE 'INSERT INTO public.member_posts(id,author_id,body,created_at) SELECT id,student_id,left(content,10000),created_at FROM public.community_posts WHERE length(btrim(content))>0 ON CONFLICT DO NOTHING';
 ELSIF EXISTS(SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='community_posts' AND column_name='author_id') THEN
  EXECUTE 'INSERT INTO public.member_posts(id,author_id,body,created_at) SELECT id,author_id,left(body,10000),created_at FROM public.community_posts WHERE NOT anonymous AND length(btrim(body))>0 ON CONFLICT DO NOTHING';
 END IF;
END $$;
ALTER TABLE public.member_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.member_follows ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.member_posts ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.member_profiles,public.member_follows,public.member_posts FROM anon,authenticated;

CREATE OR REPLACE FUNCTION public.social_profile(p_id UUID)
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$ BEGIN
 IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Sign in to view profiles'; END IF;
 RETURN (SELECT to_jsonb(p)||jsonb_build_object(
 'followers',(SELECT count(*) FROM public.member_follows WHERE following_id=p.id),
 'following',(SELECT count(*) FROM public.member_follows WHERE follower_id=p.id),
 'is_following',EXISTS(SELECT 1 FROM public.member_follows WHERE follower_id=auth.uid() AND following_id=p.id))
 FROM public.member_profiles p WHERE id=p_id);
END; $$;
CREATE OR REPLACE FUNCTION public.social_people(p_search TEXT DEFAULT '')
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$ BEGIN
 IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Sign in to find people'; END IF;
 RETURN coalesce((SELECT jsonb_agg(to_jsonb(t)) FROM (SELECT p.id,p.display_name,p.headline FROM public.member_profiles p
 WHERE p.id<>auth.uid() AND (coalesce(p_search,'')='' OR p.display_name ILIKE '%'||left(p_search,100)||'%')
 ORDER BY p.created_at DESC,p.id LIMIT 30) t),'[]'::JSONB);
END; $$;
CREATE OR REPLACE FUNCTION public.social_follow(p_id UUID,p_follow BOOLEAN)
RETURNS VOID LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$ BEGIN
 IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Sign in to follow people'; END IF;
 IF p_id=auth.uid() THEN RAISE EXCEPTION 'You cannot follow yourself'; END IF;
 IF p_follow THEN INSERT INTO public.member_follows(follower_id,following_id) VALUES(auth.uid(),p_id) ON CONFLICT DO NOTHING;
 ELSE DELETE FROM public.member_follows WHERE follower_id=auth.uid() AND following_id=p_id; END IF;
END; $$;
CREATE OR REPLACE FUNCTION public.social_update_profile(p_name TEXT,p_headline TEXT,p_bio TEXT)
RETURNS VOID LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$ BEGIN
 IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Sign in to edit your profile'; END IF;
 UPDATE public.member_profiles SET display_name=btrim(p_name),headline=coalesce(p_headline,''),bio=coalesce(p_bio,'') WHERE id=auth.uid();
END; $$;
CREATE OR REPLACE FUNCTION public.social_post(p_body TEXT)
RETURNS UUID LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$ DECLARE v_id UUID; BEGIN
 IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Sign in to post'; END IF;
 INSERT INTO public.member_posts(author_id,body) VALUES(auth.uid(),btrim(p_body)) RETURNING id INTO v_id; RETURN v_id;
END; $$;
CREATE OR REPLACE FUNCTION public.social_feed(p_author UUID DEFAULT NULL,p_offset INT DEFAULT 0)
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$ BEGIN
 IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Sign in to view your wall'; END IF;
 RETURN coalesce((SELECT jsonb_agg(to_jsonb(t) ORDER BY t.created_at DESC,t.id DESC) FROM (
 SELECT f.*,p.display_name,p.headline FROM (
 SELECT id,author_id,body,''::TEXT AS title,''::TEXT AS topic,0 AS question_count,created_at,'post'::TEXT AS kind FROM public.member_posts
 UNION ALL
 SELECT id,author_id,''::TEXT,title,topic,jsonb_array_length(questions),created_at,'quiz'::TEXT FROM public.community_quizzes
 ) f JOIN public.member_profiles p ON p.id=f.author_id
 WHERE (p_author IS NOT NULL AND f.author_id=p_author) OR (p_author IS NULL AND
 (f.author_id=auth.uid() OR EXISTS(SELECT 1 FROM public.member_follows WHERE follower_id=auth.uid() AND following_id=f.author_id)))
 ORDER BY f.created_at DESC,f.id DESC LIMIT 20 OFFSET greatest(0,least(coalesce(p_offset,0),100000))) t),'[]'::JSONB);
END; $$;
REVOKE ALL ON FUNCTION public.create_member_profile(),public.social_profile(UUID),public.social_people(TEXT),public.social_follow(UUID,BOOLEAN),public.social_update_profile(TEXT,TEXT,TEXT),public.social_post(TEXT),public.social_feed(UUID,INT) FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION public.social_profile(UUID),public.social_people(TEXT),public.social_follow(UUID,BOOLEAN),public.social_update_profile(TEXT,TEXT,TEXT),public.social_post(TEXT),public.social_feed(UUID,INT) TO authenticated;
COMMIT;
