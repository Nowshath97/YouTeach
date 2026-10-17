-- Run after social_feed.sql. Private messages between connected members.
BEGIN;
CREATE TABLE IF NOT EXISTS public.member_messages (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 sender_id UUID NOT NULL REFERENCES public.member_profiles(id) ON DELETE CASCADE,
 recipient_id UUID NOT NULL REFERENCES public.member_profiles(id) ON DELETE CASCADE,
 body TEXT NOT NULL CHECK(length(btrim(body)) BETWEEN 1 AND 4000),
 created_at TIMESTAMPTZ NOT NULL DEFAULT now(),CHECK(sender_id<>recipient_id)
);
CREATE INDEX IF NOT EXISTS member_messages_conversation_idx ON public.member_messages(sender_id,recipient_id,created_at DESC);
CREATE INDEX IF NOT EXISTS member_messages_recipient_idx ON public.member_messages(recipient_id,created_at DESC);
ALTER TABLE public.member_messages ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.member_messages FROM anon,authenticated;
CREATE OR REPLACE FUNCTION public.chat_contacts() RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$ BEGIN
 IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Sign in to chat'; END IF;
 RETURN coalesce((SELECT jsonb_agg(to_jsonb(t)) FROM (
 SELECT p.id,p.display_name,p.headline,
 EXISTS(SELECT 1 FROM public.member_follows f WHERE (f.follower_id=auth.uid() AND f.following_id=p.id) OR (f.following_id=auth.uid() AND f.follower_id=p.id)) AS can_message,
 (SELECT max(m.created_at) FROM public.member_messages m WHERE (m.sender_id=auth.uid() AND m.recipient_id=p.id) OR (m.sender_id=p.id AND m.recipient_id=auth.uid())) AS last_message_at
 FROM public.member_profiles p WHERE p.id<>auth.uid() AND (
 EXISTS(SELECT 1 FROM public.member_follows f WHERE (f.follower_id=auth.uid() AND f.following_id=p.id) OR (f.following_id=auth.uid() AND f.follower_id=p.id)) OR
 EXISTS(SELECT 1 FROM public.member_messages m WHERE (m.sender_id=auth.uid() AND m.recipient_id=p.id) OR (m.sender_id=p.id AND m.recipient_id=auth.uid())))
 ORDER BY last_message_at DESC NULLS LAST,p.display_name,p.id LIMIT 100) t),'[]'::JSONB);
END; $$;
CREATE OR REPLACE FUNCTION public.chat_messages(p_peer UUID,p_before TIMESTAMPTZ DEFAULT NULL) RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$ BEGIN
 IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Sign in to chat'; END IF;
 RETURN coalesce((SELECT jsonb_agg(to_jsonb(t) ORDER BY t.created_at,t.id) FROM (
 SELECT id,sender_id,recipient_id,body,created_at FROM public.member_messages WHERE
 ((sender_id=auth.uid() AND recipient_id=p_peer) OR (sender_id=p_peer AND recipient_id=auth.uid()))
 AND (p_before IS NULL OR created_at<p_before) ORDER BY created_at DESC,id DESC LIMIT 50) t),'[]'::JSONB);
END; $$;
CREATE OR REPLACE FUNCTION public.chat_send(p_peer UUID,p_body TEXT) RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$ DECLARE v_message public.member_messages%ROWTYPE; BEGIN
 IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Sign in to chat'; END IF;
 IF p_peer=auth.uid() OR NOT EXISTS(SELECT 1 FROM public.member_follows WHERE (follower_id=auth.uid() AND following_id=p_peer) OR (following_id=auth.uid() AND follower_id=p_peer)) THEN RAISE EXCEPTION 'Chat is available with your followers and people you follow'; END IF;
 INSERT INTO public.member_messages(sender_id,recipient_id,body) VALUES(auth.uid(),p_peer,btrim(p_body)) RETURNING * INTO v_message;
 RETURN to_jsonb(v_message);
END; $$;
REVOKE ALL ON FUNCTION public.chat_contacts(),public.chat_messages(UUID,TIMESTAMPTZ),public.chat_send(UUID,TEXT) FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION public.chat_contacts(),public.chat_messages(UUID,TIMESTAMPTZ),public.chat_send(UUID,TEXT) TO authenticated;
COMMIT;
