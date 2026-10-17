import React, { useEffect, useId, useRef, useState } from 'react';
import { ImagePlus, MessageCircle, Send, ThumbsUp, X } from 'lucide-react';
import { supabase } from './supabase';

function CommentImage({ path }) {
  const [url, setUrl] = useState('');
  const [error, setError] = useState(false);
  const [retry, setRetry] = useState(0);
  useEffect(() => {
    let active = true;
    setError(false); setUrl('');
    supabase.storage.from('solution-images').createSignedUrl(path, 3600).then(({ data, error: e }) => {
      if (active) { if (e) setError(true); else setUrl(data.signedUrl); }
    }).catch(() => { if (active) setError(true); });
    return () => { active = false; };
  }, [path, retry]);
  if (error) return <button className="btn mt-2" onClick={() => setRetry(n => n + 1)}>Reload solution image</button>;
  return url ? <a href={url} target="_blank" rel="noreferrer" className="block mt-3"><img src={url} alt="Student's attached solution" loading="lazy" onError={() => setError(true)} className="discussion-solution" /><span className="small block mt-1">Open full image</span></a> : <p className="small mt-2">Loading solution image...</p>;
}

export default function PostDiscussion({ item, user, onProfile }) {
  const [stats, setStats] = useState(null);
  const [open, setOpen] = useState(false);
  const [comments, setComments] = useState([]);
  const [more, setMore] = useState(false);
  const [offset, setOffset] = useState(0);
  const [loading, setLoading] = useState(false);
  const [reply, setReply] = useState(null);
  const [text, setText] = useState('');
  const [file, setFile] = useState(null);
  const [preview, setPreview] = useState('');
  const [busy, setBusy] = useState(false);
  const [liking, setLiking] = useState(false);
  const [error, setError] = useState('');
  const [initError, setInitError] = useState(false);
  const input = useRef(null);
  const textarea = useRef(null);
  const id = useId();
  const args = { p_kind: item.kind, p_id: item.id };
  async function rpc(name, extra = {}) {
    const { data, error: e } = await supabase.rpc(name, { ...args, ...extra });
    if (e) throw e;
    return data;
  }
  useEffect(() => {
    let active = true;
    rpc('social_interactions').then(data => { if (active) setStats(data); }).catch(() => { if (active) setInitError(true); });
    return () => { active = false; };
  }, [item.id, item.kind]);
  useEffect(() => {
    if (!file) { setPreview(''); return; }
    const url = URL.createObjectURL(file); setPreview(url);
    return () => URL.revokeObjectURL(url);
  }, [file]);
  async function load(nextOffset = 0) {
    setLoading(true); setError('');
    try {
      const data = await rpc('social_comments', { p_offset: nextOffset });
      setComments(previous => nextOffset ? [...new Map([...previous, ...data].map(c => [c.id, c])).values()] : data);
      setOffset(nextOffset + data.length); setMore(data.length === 50);
    } catch (e) { setError(e.message); } finally { setLoading(false); }
  }
  async function like() {
    if (liking) return;
    setLiking(true); setError('');
    try { setStats(await rpc('social_like', { p_liked: !stats?.liked })); setInitError(false); }
    catch (e) { setError(e.message); } finally { setLiking(false); }
  }
  function chooseFile(event) {
    const chosen = event.target.files?.[0]; event.target.value = '';
    if (!chosen) return;
    if (!['image/jpeg','image/png','image/webp'].includes(chosen.type) || chosen.size > 5 * 1024 * 1024) {
      setError('Choose a JPG, PNG or WebP image up to 5 MB.'); return;
    }
    setFile(chosen); setError('');
  }
  async function send(event) {
    event.preventDefault();
    if (busy || (!text.trim() && !file)) return;
    setBusy(true); setError('');
    let path = null, saved = false;
    try {
      if (file) {
        const ext = { 'image/jpeg': 'jpg', 'image/png': 'png', 'image/webp': 'webp' }[file.type];
        path = `${user.id}/${crypto.randomUUID()}.${ext}`;
        const { error: e } = await supabase.storage.from('solution-images').upload(path, file, { contentType: file.type, upsert: false });
        if (e) throw e;
      }
      const comment = await rpc('social_comment', { p_body: text.trim(), p_parent: reply?.id || null, p_image: path });
      saved = true;
      setComments(previous => [...previous, comment]); setText(''); setFile(null); setReply(null);
      setStats(previous => previous ? { ...previous, comments: previous.comments + 1 } : previous);
    } catch (e) {
      setError(e.message);
      if (path && !saved) await supabase.storage.from('solution-images').remove([path]).catch(() => {});
    } finally { setBusy(false); }
  }
  function renderComment(comment, isReply = false) {
    return <div key={comment.id} className={`discussion-comment ${isReply ? 'discussion-reply' : ''}`}>
      <button className="discussion-avatar" onClick={() => onProfile(comment.author_id)} aria-label={`View ${comment.display_name}'s profile`}>{comment.display_name.slice(0,1).toUpperCase()}</button>
      <div className="min-w-0 flex-1"><div className="discussion-bubble"><button className="text-xs font-bold hover:underline" onClick={() => onProfile(comment.author_id)}>{comment.display_name}</button><time className="small block mt-1">{new Date(comment.created_at).toLocaleString()}</time>{comment.body && <p className="text-sm leading-6 whitespace-pre-wrap mt-2">{comment.body}</p>}{comment.image_path && <CommentImage path={comment.image_path} />}</div>
        <button className="text-xs text-indigo-700 font-semibold mt-2" disabled={busy} onClick={() => { const root = isReply ? comments.find(c => c.id === comment.parent_id) : comment; if (root) { setReply({ id: root.id, name: comment.display_name }); textarea.current?.focus(); } }}>Reply</button>
      </div>
    </div>;
  }
  const roots = comments.filter(c => !c.parent_id);
  return <section className="discussion" aria-label="Likes and discussion">
    <div className="flex justify-between text-xs text-slate-500 pb-3"><span>{stats ? `${stats.likes} likes` : 'Likes'}</span><span>{stats ? `${stats.comments} comments` : 'Comments'}</span></div>
    <div className="discussion-actions"><button className={`btn ${stats?.liked ? 'discussion-liked' : ''}`} aria-pressed={Boolean(stats?.liked)} disabled={liking} onClick={like}><ThumbsUp size={16} />{stats?.liked ? 'Liked' : 'Like'}</button><button className="btn" aria-expanded={open} aria-controls={`${id}-comments`} onClick={() => { setOpen(!open); if (!open && !comments.length) load(); }}><MessageCircle size={16} />Comment</button></div>
    {initError && <p className="small mt-2">Discussion is unavailable. Run social_discussions.sql in Supabase to enable it.</p>}
    {open && <div id={`${id}-comments`}>
      <div className="space-y-4 mt-4">{roots.map(comment => <div key={comment.id}>{renderComment(comment)}<div className="discussion-thread">{comments.filter(c => c.parent_id === comment.id).map(c => renderComment(c, true))}</div></div>)}</div>
      {loading && <p className="small mt-3" role="status">Loading comments...</p>}{!loading && !comments.length && !error && <p className="small mt-3">Start the discussion. Share your approach or a solved answer.</p>}
      {more && <button className="btn mt-3" disabled={loading} onClick={() => load(offset)}>Load more comments</button>}
      <form className="mt-4" onSubmit={send}>
        {reply && <div className="flex items-center justify-between text-xs text-indigo-700 mb-2"><span>Replying to {reply.name}</span><button type="button" disabled={busy} aria-label="Cancel reply" onClick={() => setReply(null)}><X size={14} /></button></div>}
        <label className="sr-only" htmlFor={`${id}-text`}>{reply ? 'Write a reply' : 'Write a comment'}</label><textarea ref={textarea} id={`${id}-text`} className="field" placeholder={reply ? 'Write your reply...' : 'Add a comment or share a solution...'} maxLength={5000} value={text} onChange={e => setText(e.target.value)} disabled={busy} />
        {preview && <div className="mt-3"><img src={preview} alt="Solution attachment preview" className="discussion-preview" /><button type="button" className="btn mt-2" disabled={busy} onClick={() => setFile(null)}>Remove image</button></div>}
        <input ref={input} type="file" accept="image/jpeg,image/png,image/webp" className="sr-only" aria-label="Attach solution image" tabIndex={-1} onChange={chooseFile} disabled={busy} />
        <div className="flex flex-wrap justify-between gap-2 mt-2"><button className="btn" type="button" disabled={busy} onClick={() => input.current?.click()}><ImagePlus size={15} />Attach solution</button><button className="btn btn-primary" disabled={busy || (!text.trim() && !file)}><Send size={14} />{busy ? 'Posting...' : reply ? 'Post reply' : 'Post comment'}</button></div><p className="small mt-2">JPG, PNG or WebP · Up to 5 MB</p>
      </form>
    </div>}
    {error && <p className="auth-message" role="alert">{error}</p>}
  </section>;
}
