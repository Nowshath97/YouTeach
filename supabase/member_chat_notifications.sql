-- Run after member_chat.sql to enable persistent unread counts.
BEGIN;
ALTER TABLE public.member_messages ADD COLUMN IF NOT EXISTS read_at TIMESTAMPTZ;
CREATE INDEX IF NOT EXISTS member_messages_unread_idx
 ON public.member_messages(recipient_id,sender_id,created_at DESC) WHERE read_at IS NULL;

CREATE OR REPLACE FUNCTION public.chat_inbox() RETURNS JSONB
LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$ BEGIN
 IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Sign in to chat'; END IF;
 RETURN coalesce((SELECT jsonb_agg(to_jsonb(t) ORDER BY t.created_at DESC) FROM (
 SELECT p.id,p.display_name,p.headline,count(*) AS unread_count,
 (array_agg(m.id ORDER BY m.created_at DESC,m.id DESC))[1] AS message_id,
 (array_agg(m.body ORDER BY m.created_at DESC,m.id DESC))[1] AS body,
 max(m.created_at) AS created_at
 FROM public.member_messages m JOIN public.member_profiles p ON p.id=m.sender_id
 WHERE m.recipient_id=auth.uid() AND m.read_at IS NULL
 GROUP BY p.id,p.display_name,p.headline
 ) t),'[]'::JSONB);
END; $$;

CREATE OR REPLACE FUNCTION public.chat_mark_read(p_message_ids UUID[]) RETURNS VOID
LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$ BEGIN
 IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Sign in to chat'; END IF;
 UPDATE public.member_messages SET read_at=now()
 WHERE recipient_id=auth.uid() AND id=ANY(p_message_ids) AND read_at IS NULL;
END; $$;
REVOKE ALL ON FUNCTION public.chat_inbox(),public.chat_mark_read(UUID[]) FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION public.chat_inbox(),public.chat_mark_read(UUID[]) TO authenticated;
COMMIT;
