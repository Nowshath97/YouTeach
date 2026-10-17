import React, { useEffect, useRef, useState } from 'react';
import { ArrowLeft, MessageCircle, Send, X } from 'lucide-react';
import { supabase } from './supabase';

export default function MemberChat({ user }) {
  const [open, setOpen] = useState(false);
  const [contacts, setContacts] = useState([]);
  const [peer, setPeer] = useState(null);
  const [messages, setMessages] = useState([]);
  const [drafts, setDrafts] = useState({});
  const [search, setSearch] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const [busy, setBusy] = useState(false);
  const [older, setOlder] = useState(false);
  const [more, setMore] = useState(false);
  const panel = useRef(null);
  const scroll = useRef(null);
  const trigger = useRef(null);
  const generation = useRef(0);
  async function rpc(name, args = {}) {
    const { data, error: e } = await supabase.rpc(name, args);
    if (e) throw e; return data || [];
  }
  useEffect(() => {
    if (!open) return;
    let active = true;
    setLoading(true);
    const load = () => rpc('chat_contacts').then(data => { if (active) { setContacts(data); setError(''); } }).catch(e => { if (active) setError(e.message); }).finally(() => { if (active) setLoading(false); });
    load(); const interval = setInterval(load, 5000);
    panel.current?.querySelector('button')?.focus();
    const escape = e => { if (e.key === 'Escape') { setOpen(false); trigger.current?.focus(); } };
    document.addEventListener('keydown', escape);
    return () => { active = false; clearInterval(interval); document.removeEventListener('keydown', escape); };
  }, [open, user.id]);
  useEffect(() => {
    generation.current++;
    if (!open || !peer) return;
    let active = true;
    setMessages([]); setOlder(false); setMore(false); setLoading(true); setError('');
    const load = () => rpc('chat_messages', { p_peer: peer.id }).then(data => {
      if (!active) return;
      setMessages(previous => [...new Map([...previous,...data].map(m => [m.id,m])).values()].sort((a,b) => a.created_at.localeCompare(b.created_at) || a.id.localeCompare(b.id)));
      setMore(previous => previous || data.length === 50);
    }).catch(e => { if (active) setError(e.message); }).finally(() => { if (active) setLoading(false); });
    load(); const interval = setInterval(load, 5000);
    return () => { active = false; clearInterval(interval); };
  }, [open, peer?.id]);
  useEffect(() => { if (!older) scroll.current?.scrollTo({ top: scroll.current.scrollHeight }); }, [messages, older]);
  async function loadOlder() {
    const current = generation.current; setLoading(true); setOlder(true);
    try {
      const data = await rpc('chat_messages', { p_peer: peer.id, p_before: messages[0]?.created_at });
      if (current !== generation.current) return;
      setMessages(previous => [...new Map([...data,...previous].map(m=>[m.id,m])).values()]); setMore(data.length === 50);
    } catch (e) { if (current === generation.current) setError(e.message); } finally { if (current === generation.current) setLoading(false); }
  }
  async function send(event) {
    event.preventDefault(); const body = (drafts[peer.id] || '').trim(); if (!body || busy) return;
    const recipient = peer.id, current = generation.current;
    setBusy(true); setError('');
    try {
      const data = await rpc('chat_send', { p_peer: recipient, p_body: body });
      setDrafts(previous => ({ ...previous, [recipient]: '' }));
      if (current === generation.current) { setMessages(previous => [...previous.filter(m => m.id !== data.id),data]); setOlder(false); }
    } catch (e) { if (current === generation.current) setError(e.message); } finally { setBusy(false); }
  }
  const connected = contacts.find(c => c.id === peer?.id)?.can_message;
  return <>
    <button ref={trigger} className="header-round-action" aria-label="Messages" aria-expanded={open} aria-controls="member-chat" onClick={() => setOpen(value=>!value)}><MessageCircle size={20} /></button>
    {open && <section ref={panel} id="member-chat" className="member-chat" role="region" aria-label="Private messaging">
      <header>{peer && <button className="btn" aria-label="Back to conversations" onClick={()=>setPeer(null)}><ArrowLeft size={16} /></button>}<div className="min-w-0 flex-1"><b>{peer?.display_name || 'Messaging'}</b><p className="small truncate">{peer ? peer.headline || 'Private conversation' : 'Followers & people you follow'}</p></div><button className="btn" aria-label="Close messaging" onClick={()=>{setOpen(false);trigger.current?.focus();}}><X size={16} /></button></header>
      {error && <p className="auth-message m-3" role="alert">{error}</p>}
      {!peer ? <div className="p-4 overflow-y-auto"><label className="sr-only" htmlFor="chat-search">Search conversations</label><input id="chat-search" className="field" placeholder="Search people" value={search} onChange={e=>setSearch(e.target.value)} />{contacts.filter(c=>c.display_name.toLowerCase().includes(search.toLowerCase())).map(contact=><button className="chat-contact" key={contact.id} onClick={()=>setPeer(contact)}><span className="account-avatar account-avatar-fallback">{contact.display_name.slice(0,1).toUpperCase()}</span><span><b>{contact.display_name}</b><small>{contact.headline || (contact.can_message ? 'Start a conversation' : 'Previous conversation')}</small></span></button>)}{!loading && !contacts.length && <p className="small mt-4">Follow someone or gain a follower to start chatting.</p>}</div> : <>
        <div ref={scroll} className="chat-messages" aria-live="polite" aria-label="Conversation messages">{more && messages.length>0 && <button className="btn mb-3" disabled={loading} onClick={loadOlder}>Older messages</button>}{messages.map(message=><div key={message.id} className={`chat-message ${message.sender_id===user.id ? 'mine' : ''}`}><p>{message.body}</p><time>{new Date(message.created_at).toLocaleString()}</time></div>)}{!messages.length && !loading && <p className="small">Say hello to {peer.display_name}.</p>}</div>
        <form onSubmit={send} className="chat-compose"><label className="sr-only" htmlFor="chat-message">Your message</label><textarea id="chat-message" className="field" placeholder={connected ? 'Write a message...' : 'Follow this person to send messages'} maxLength={4000} disabled={!connected || busy} value={drafts[peer.id] || ''} onChange={e=>setDrafts(previous=>({...previous,[peer.id]:e.target.value}))} /><button className="btn btn-primary" aria-label="Send message" disabled={!connected || busy || !drafts[peer.id]?.trim()}><Send size={16} /></button></form>
      </>}{loading && <p role="status" className="small px-4 pb-2">Loading...</p>}
    </section>}
  </>;
}
