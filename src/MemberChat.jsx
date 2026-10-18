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
  const [inbox, setInbox] = useState([]);
  const [notification, setNotification] = useState(null);
  const [notificationError, setNotificationError] = useState('');
  const refreshInbox = useRef(() => {});
  useEffect(() => {
    if (!supabase) return;
    let active = true, running = false;
    const seen = new Set();
    const load = async () => {
      if (running) return;
      running = true;
      try {
        const data = await rpc('chat_inbox');
        if (!active) return;
        setInbox(data); setNotificationError('');
        const incoming = data.find(item => !seen.has(item.message_id));
        data.forEach(item => seen.add(item.message_id));
        if (incoming && document.visibilityState === 'visible') setNotification(incoming);
      } catch (e) {
        if (active) setNotificationError('Message notifications unavailable. ' + e.message);
      } finally { running = false; }
    };
    setInbox([]); setNotification(null);
    refreshInbox.current = load;
    load();
    const interval = setInterval(load, 5000);
    const visible = () => { if (document.visibilityState === 'visible') load(); };
    document.addEventListener('visibilitychange', visible);
    return () => { active = false; clearInterval(interval); document.removeEventListener('visibilitychange', visible); };
  }, [user.id]);
  useEffect(() => {
    if (!notification) return;
    const timer = setTimeout(() => setNotification(null), 8000);
    return () => clearTimeout(timer);
  }, [notification]);
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
    const load = () => rpc('chat_messages', { p_peer: peer.id }).then(async data => {
      if (!active) return;
      setMessages(previous => [...new Map([...previous,...data].map(m => [m.id,m])).values()].sort((a,b) => a.created_at.localeCompare(b.created_at) || a.id.localeCompare(b.id)));
      setMore(previous => previous || data.length === 50);
      if (document.visibilityState === 'visible') {
        const ids = data.filter(m => m.recipient_id === user.id).map(m => m.id);
        if (ids.length) {
          await rpc('chat_mark_read', { p_message_ids: ids });
          if (active) {
            setNotification(current => current?.id === peer.id ? null : current);
            refreshInbox.current();
          }
        }
      }
    }).catch(e => { if (active) setError(e.message); }).finally(() => { if (active) setLoading(false); });
    load(); const interval = setInterval(load, 5000);
    return () => { active = false; clearInterval(interval); };
  }, [open, peer?.id, user.id]);
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
  const unread = inbox.reduce((sum, item) => sum + Number(item.unread_count), 0);
  return <>
    <button ref={trigger} className="header-round-action chat-trigger" aria-label={`Messages${unread ? `, ${unread} unread` : ''}`} aria-expanded={open} aria-controls="member-chat" onClick={() => setOpen(value=>!value)}><MessageCircle size={20} />{unread > 0 && <span className="chat-unread-badge">{unread > 99 ? '99+' : unread}</span>}</button>
    {notification && !(open && peer?.id === notification.id) && <div className="chat-notification" role="status"><button className="chat-notification-open" onClick={() => { setPeer(notification); setOpen(true); setNotification(null); }}><b>New message from {notification.display_name}</b><span>{notification.body}</span><small>Open conversation</small></button><button className="btn" aria-label="Dismiss message notification" onClick={() => setNotification(null)}><X size={16} /></button></div>}
    {open && <section ref={panel} id="member-chat" className="member-chat" role="region" aria-label="Private messaging">
      <header>{peer && <button className="btn" aria-label="Back to conversations" onClick={()=>setPeer(null)}><ArrowLeft size={16} /></button>}<div className="min-w-0 flex-1"><b>{peer?.display_name || 'Messaging'}</b><p className="small truncate">{peer ? peer.headline || 'Private conversation' : 'Followers & people you follow'}</p></div><button className="btn" aria-label="Close messaging" onClick={()=>{setOpen(false);trigger.current?.focus();}}><X size={16} /></button></header>
      {error && <p className="auth-message m-3" role="alert">{error}</p>}
      {notificationError && <p className="auth-message m-3" role="alert">{notificationError}</p>}
      {!peer ? <div className="p-4 overflow-y-auto"><label className="sr-only" htmlFor="chat-search">Search conversations</label><input id="chat-search" className="field" placeholder="Search people" value={search} onChange={e=>setSearch(e.target.value)} />{contacts.filter(c=>c.display_name.toLowerCase().includes(search.toLowerCase())).map(contact=><button className="chat-contact" key={contact.id} onClick={()=>setPeer(contact)}><span className="account-avatar account-avatar-fallback">{contact.display_name.slice(0,1).toUpperCase()}</span><span><b>{contact.display_name}</b><small>{contact.headline || (contact.can_message ? 'Start a conversation' : 'Previous conversation')}</small></span>{inbox.some(item => item.id === contact.id) && <span className="chat-unread-badge" aria-label={`${inbox.find(item => item.id === contact.id).unread_count} unread messages`}>{inbox.find(item => item.id === contact.id).unread_count}</span>}</button>)}{!loading && !contacts.length && <p className="small mt-4">Follow someone or gain a follower to start chatting.</p>}</div> : <>
        <div ref={scroll} className="chat-messages" aria-live="polite" aria-label="Conversation messages">{more && messages.length>0 && <button className="btn mb-3" disabled={loading} onClick={loadOlder}>Older messages</button>}{messages.map(message=><div key={message.id} className={`chat-message ${message.sender_id===user.id ? 'mine' : ''}`}><p>{message.body}</p><time>{new Date(message.created_at).toLocaleString()}</time></div>)}{!messages.length && !loading && <p className="small">Say hello to {peer.display_name}.</p>}</div>
        <form onSubmit={send} className="chat-compose"><label className="sr-only" htmlFor="chat-message">Your message</label><textarea id="chat-message" className="field" placeholder={connected ? 'Write a message...' : 'Follow this person to send messages'} maxLength={4000} disabled={!connected || busy} value={drafts[peer.id] || ''} onChange={e=>setDrafts(previous=>({...previous,[peer.id]:e.target.value}))} /><button className="btn btn-primary" aria-label="Send message" disabled={!connected || busy || !drafts[peer.id]?.trim()}><Send size={16} /></button></form>
      </>}{loading && <p role="status" className="small px-4 pb-2">Loading...</p>}
    </section>}
  </>;
}
