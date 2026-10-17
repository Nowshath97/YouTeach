-- Run after social_feed.sql. Includes Supabase Storage setup for solution images.
BEGIN;
CREATE TABLE IF NOT EXISTS public.member_likes (
 kind TEXT NOT NULL CHECK(kind IN ('post','quiz')),item_id UUID NOT NULL,
 user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
 PRIMARY KEY(kind,item_id,user_id)
);
CREATE TABLE IF NOT EXISTS public.member_comments (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),kind TEXT NOT NULL CHECK(kind IN ('post','quiz')),
 item_id UUID NOT NULL,author_id UUID NOT NULL REFERENCES public.member_profiles(id) ON DELETE CASCADE,
 parent_id UUID REFERENCES public.member_comments(id) ON DELETE CASCADE,
 body TEXT NOT NULL DEFAULT '' CHECK(length(body)<=5000),image_path TEXT,
 created_at TIMESTAMPTZ NOT NULL DEFAULT now(),CHECK(length(btrim(body))>0 OR image_path IS NOT NULL)
);
CREATE INDEX IF NOT EXISTS member_comments_item_idx ON public.member_comments(kind,item_id,created_at,id);
CREATE INDEX IF NOT EXISTS member_comments_parent_idx ON public.member_comments(parent_id);
ALTER TABLE public.member_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.member_comments ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.member_likes,public.member_comments FROM anon,authenticated;
CREATE OR REPLACE FUNCTION public.check_social_item(p_kind TEXT,p_id UUID)
RETURNS VOID LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$ BEGIN
 IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Sign in to join the discussion'; END IF;
 IF p_kind='post' AND EXISTS(SELECT 1 FROM public.member_posts WHERE id=p_id) THEN RETURN; END IF;
 IF p_kind='quiz' AND EXISTS(SELECT 1 FROM public.community_quizzes WHERE id=p_id) THEN RETURN; END IF;
 RAISE EXCEPTION 'Post or quiz unavailable';
END; $$;
CREATE OR REPLACE FUNCTION public.social_interactions(p_kind TEXT,p_id UUID)
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$ BEGIN
 PERFORM public.check_social_item(p_kind,p_id);
 RETURN jsonb_build_object('likes',(SELECT count(*) FROM public.member_likes WHERE kind=p_kind AND item_id=p_id),
 'liked',EXISTS(SELECT 1 FROM public.member_likes WHERE kind=p_kind AND item_id=p_id AND user_id=auth.uid()),
 'comments',(SELECT count(*) FROM public.member_comments WHERE kind=p_kind AND item_id=p_id));
END; $$;
CREATE OR REPLACE FUNCTION public.social_like(p_kind TEXT,p_id UUID,p_liked BOOLEAN)
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$ BEGIN
 PERFORM public.check_social_item(p_kind,p_id);
 IF p_liked THEN INSERT INTO public.member_likes(kind,item_id,user_id) VALUES(p_kind,p_id,auth.uid()) ON CONFLICT DO NOTHING;
 ELSE DELETE FROM public.member_likes WHERE kind=p_kind AND item_id=p_id AND user_id=auth.uid(); END IF;
 RETURN public.social_interactions(p_kind,p_id);
END; $$;
CREATE OR REPLACE FUNCTION public.social_comments(p_kind TEXT,p_id UUID,p_offset INT DEFAULT 0)
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$ BEGIN
 PERFORM public.check_social_item(p_kind,p_id);
 RETURN coalesce((SELECT jsonb_agg(to_jsonb(t) ORDER BY t.created_at,t.id) FROM (
 SELECT c.*,p.display_name FROM public.member_comments c JOIN public.member_profiles p ON p.id=c.author_id
 WHERE c.kind=p_kind AND c.item_id=p_id ORDER BY c.created_at,c.id LIMIT 50 OFFSET greatest(0,coalesce(p_offset,0))) t),'[]'::JSONB);
END; $$;
CREATE OR REPLACE FUNCTION public.social_comment(p_kind TEXT,p_id UUID,p_body TEXT,p_parent UUID DEFAULT NULL,p_image TEXT DEFAULT NULL)
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$ DECLARE v_id UUID; BEGIN
 PERFORM public.check_social_item(p_kind,p_id);
 IF length(coalesce(p_body,''))>5000 OR (length(btrim(coalesce(p_body,'')))=0 AND p_image IS NULL) THEN RAISE EXCEPTION 'Add a comment or solution image'; END IF;
 IF p_parent IS NOT NULL AND NOT EXISTS(SELECT 1 FROM public.member_comments WHERE id=p_parent AND kind=p_kind AND item_id=p_id AND parent_id IS NULL) THEN RAISE EXCEPTION 'Reply must belong to a comment on this post'; END IF;
 IF p_image IS NOT NULL AND (split_part(p_image,'/',1)<>auth.uid()::TEXT OR NOT EXISTS(
 SELECT 1 FROM storage.objects WHERE bucket_id='solution-images' AND name=p_image)) THEN RAISE EXCEPTION 'Upload your solution image first'; END IF;
 INSERT INTO public.member_comments(kind,item_id,author_id,parent_id,body,image_path) VALUES(p_kind,p_id,auth.uid(),p_parent,btrim(coalesce(p_body,'')),p_image) RETURNING id INTO v_id;
 RETURN (SELECT to_jsonb(c)||jsonb_build_object('display_name',p.display_name) FROM public.member_comments c JOIN public.member_profiles p ON p.id=c.author_id WHERE c.id=v_id);
END; $$;

INSERT INTO storage.buckets(id,name,public,file_size_limit,allowed_mime_types)
VALUES('solution-images','solution-images',FALSE,5242880,ARRAY['image/jpeg','image/png','image/webp'])
ON CONFLICT(id) DO UPDATE SET public=FALSE,file_size_limit=5242880,allowed_mime_types=ARRAY['image/jpeg','image/png','image/webp'];
DROP POLICY IF EXISTS "Read solution images" ON storage.objects;
CREATE POLICY "Read solution images" ON storage.objects FOR SELECT TO authenticated USING(bucket_id='solution-images');
DROP POLICY IF EXISTS "Upload own solution images" ON storage.objects;
CREATE POLICY "Upload own solution images" ON storage.objects FOR INSERT TO authenticated WITH CHECK(bucket_id='solution-images' AND (storage.foldername(name))[1]=auth.uid()::TEXT);
DROP POLICY IF EXISTS "Remove unattached solution images" ON storage.objects;
CREATE OR REPLACE FUNCTION public.solution_image_attached(p_path TEXT) RETURNS BOOLEAN
LANGUAGE sql SECURITY DEFINER SET search_path='' AS $$ SELECT EXISTS(SELECT 1 FROM public.member_comments WHERE image_path=p_path) $$;
CREATE POLICY "Remove unattached solution images" ON storage.objects FOR DELETE TO authenticated USING(bucket_id='solution-images' AND (storage.foldername(name))[1]=auth.uid()::TEXT AND NOT public.solution_image_attached(name));
REVOKE ALL ON FUNCTION public.check_social_item(TEXT,UUID),public.social_interactions(TEXT,UUID),public.social_like(TEXT,UUID,BOOLEAN),public.social_comments(TEXT,UUID,INT),public.social_comment(TEXT,UUID,TEXT,UUID,TEXT),public.solution_image_attached(TEXT) FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION public.social_interactions(TEXT,UUID),public.social_like(TEXT,UUID,BOOLEAN),public.social_comments(TEXT,UUID,INT),public.social_comment(TEXT,UUID,TEXT,UUID,TEXT),public.solution_image_attached(TEXT) TO authenticated;
COMMIT;
