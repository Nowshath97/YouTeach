import { Bookmark, Eye, EyeOff, Search } from 'lucide-react';
import PostDiscussion from './PostDiscussion';
import React, { useEffect, useRef, useState } from 'react';
import { supabase } from './supabase';
import CommunityQuizzes from './CommunityQuizzes';

export default function SocialWall({ user, ownProfile = false, onPreferences, leftSidebar, rightSidebar }) {
  const [profileId, setProfileId] = useState(ownProfile ? user.id : null);
  const [profile, setProfile] = useState(null);
  const [feedFilter, setFeedFilter] = useState('following');
  const [feedSearch, setFeedSearch] = useState('');
  const [searchTerm, setSearchTerm] = useState('');
  const [undoHidden, setUndoHidden] = useState(null);
  const [people, setPeople] = useState([]);
  const [search, setSearch] = useState('');
  const [rows, setRows] = useState([]);
  const [draft, setDraft] = useState('');
  const [editing, setEditing] = useState(false);
  const [form, setForm] = useState({ display_name: '', headline: '', bio: '' });
  const [busy, setBusy] = useState(false);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [notice, setNotice] = useState('');
  const [more, setMore] = useState(false);
  const request = useRef(0);
  async function rpc(name, args = {}) {
    if (!supabase) throw new Error('Community is unavailable until Supabase is configured.');
    const { data, error: e } = await supabase.rpc(name, args);
    if (e) throw e;
    return data;
  }
  async function load(offset = 0) {
    const current = ++request.current;
    setLoading(true); setError('');
    try {
      const [feed, person] = await Promise.all([
        rpc('social_learning_feed', { p_author: profileId, p_filter: feedFilter, p_search: searchTerm, p_offset: offset }),
        profileId ? rpc('social_profile', { p_id: profileId }) : Promise.resolve(null),
      ]);
      if (current !== request.current) return;
      setRows(previous => offset ? [...previous, ...feed] : feed);
      setMore(feed.length === 20); setProfile(person);
    } catch (e) { if (current === request.current) setError(e.message); }
    finally { if (current === request.current) setLoading(false); }
  }
  useEffect(() => { setRows([]); setProfile(null); setEditing(false); load(); return () => { request.current++; }; }, [profileId, user.id, feedFilter, searchTerm]);
  useEffect(() => {
    let active = true;
    const timeout = setTimeout(() => {
      rpc('social_people', { p_search: search.trim() }).then(data => { if (active) setPeople(data); }).catch(e => { if (active) setError(e.message); });
    }, 250);
    return () => { active = false; clearTimeout(timeout); };
  }, [search, user.id]);
  useEffect(() => { const timer = setTimeout(() => setSearchTerm(feedSearch.trim()), 250); return () => clearTimeout(timer); }, [feedSearch]);
  async function action(work) {
    if (busy) return;
    setBusy(true); setError('');
    try { await work(); } catch (e) { setError(e.message); } finally { setBusy(false); }
  }
  function viewProfile(id) { setProfileId(id); setFeedFilter('following'); setFeedSearch(''); setSearchTerm(''); setNotice(''); setUndoHidden(null); }
  async function preference(row, type, enabled) {
    await action(async () => {
      await rpc('social_set_feed_preference', { p_kind: row.kind, p_id: row.id, p_action: type, p_enabled: enabled });
      setNotice(type === 'save' ? (enabled ? 'Saved to your revision list.' : 'Removed from your revision list.') : (enabled ? 'Hidden from your feed. You can restore it from Hidden items.' : 'Restored to your feed.'));
      setUndoHidden(type === 'hide' && enabled ? row : null);
      await load();
    });
  }
  const isMe = profileId === user.id;
  return <div className={`social-layout ${leftSidebar ? 'social-layout-with-sidebars' : ''}`}>
    {leftSidebar && <aside className="social-left-sidebar">{leftSidebar}</aside>}
    <main className="min-w-0 space-y-4">
      <div className="flex flex-wrap justify-between gap-2"><button className={`btn ${!profileId ? 'btn-primary' : ''}`} onClick={() => viewProfile(null)}>Following feed</button><button className={`btn ${isMe ? 'btn-primary' : ''}`} onClick={() => viewProfile(user.id)}>My profile &amp; posts</button></div>
      <section className="card study-feed-tools" aria-label="Study feed controls">
        <div className="study-feed-filters" aria-label="Filter feed">{[['following','All'],['post','Discussions'],['quiz','Quizzes'],['saved','Saved for revision'],['hidden','Hidden items']].map(([key,label]) => <button key={key} type="button" aria-pressed={feedFilter === key} className={`btn ${feedFilter === key ? 'btn-primary' : ''}`} onClick={() => { setFeedFilter(key); if (key === 'saved' || key === 'hidden') setProfileId(null); }}>{label}</button>)}</div>
        <label className="study-feed-search"><Search size={16} aria-hidden="true" /><span className="sr-only">Search posts, quizzes and topics</span><input type="search" placeholder="Search posts, quizzes or topics..." value={feedSearch} onChange={e => setFeedSearch(e.target.value)} maxLength={150} /></label>
        <p className="small">{feedFilter === 'saved' ? 'Your personal revision list, including saved material from other profiles.' : feedFilter === 'hidden' ? 'Only you can see this list. Restore an item to show it in your feed again.' : profileId ? 'Posts and quizzes shared by this member.' : 'Latest posts from you and people you follow.'}</p>
      </section>
      {profile && <section className="card"><div className="social-cover" /><div className="p-5"><div className="flex flex-wrap items-center justify-between gap-3"><div className="social-avatar">{profile.display_name.slice(0, 1).toUpperCase()}</div>{isMe ? <button className="btn" disabled={busy} onClick={() => { setEditing(true); setForm(profile); }}>Edit public profile</button> : <button className={`btn ${profile.is_following ? '' : 'btn-primary'}`} disabled={busy} onClick={() => action(async () => { await rpc('social_follow', { p_id: profile.id, p_follow: !profile.is_following }); await load(); })}>{profile.is_following ? 'Unfollow' : 'Follow'}</button>}</div>
        <h2 className="text-xl font-bold mt-3">{profile.display_name}</h2><p className="text-sm text-slate-600 mt-1">{profile.headline}</p><p className="text-sm whitespace-pre-wrap mt-3">{profile.bio}</p><p className="small mt-3"><b>{profile.followers}</b> followers · <b>{profile.following}</b> following · Joined {new Date(profile.created_at).toLocaleDateString()}</p>
        {editing && isMe && <form className="space-y-3 mt-4" onSubmit={event => { event.preventDefault(); action(async () => { await rpc('social_update_profile', { p_name: form.display_name.trim(), p_headline: form.headline, p_bio: form.bio }); window.dispatchEvent(new Event('member-profile-updated')); setEditing(false); await load(); }); }}>
          <label className="block text-xs font-bold">Display name<input className="field mt-1" maxLength={100} required value={form.display_name} onChange={e => setForm({ ...form, display_name: e.target.value })} disabled={busy} /></label>
          <label className="block text-xs font-bold">Headline<input className="field mt-1" maxLength={160} placeholder="e.g. Civil engineering student" value={form.headline} onChange={e => setForm({ ...form, headline: e.target.value })} disabled={busy} /></label>
          <label className="block text-xs font-bold">About<textarea className="field mt-1" maxLength={1000} value={form.bio} onChange={e => setForm({ ...form, bio: e.target.value })} disabled={busy} /></label>
          <div className="flex gap-2"><button className="btn btn-primary" disabled={busy}>Save profile</button><button type="button" className="btn" disabled={busy} onClick={() => setEditing(false)}>Cancel</button></div>
        </form>}
        {isMe && onPreferences && <button className="btn mt-4" onClick={onPreferences}>Study preferences</button>}
      </div></section>}
      {(!profileId || isMe) && <section className="card p-4"><form onSubmit={event => { event.preventDefault(); action(async () => { await rpc('social_post', { p_body: draft.trim() }); setDraft(''); setNotice('Your post is on your wall.'); await load(); }); }}>
        <label htmlFor="wall-post" className="block text-sm font-bold mb-2">Share with your followers</label><textarea id="wall-post" className="field min-h-24" placeholder="Share a question, update or study tip..." value={draft} onChange={e => setDraft(e.target.value)} maxLength={10000} disabled={busy} required />
        <div className="flex justify-end gap-2 mt-3"><CommunityQuizzes onPublished={() => { setNotice('Your quiz is on your wall.'); load(); }} /><button className="btn btn-primary" disabled={busy || !draft.trim()}>Share post</button></div>
      </form></section>}
      {notice && <div className="profile-success" role="status">{notice}{undoHidden && <button className="btn ml-3" disabled={busy} onClick={() => preference(undoHidden, 'hide', false)}>Undo hide</button>}</div>}
      {error && <div className="auth-message" role="alert">{error}<p className="mt-2">If the community has not been configured, run community_quizzes.sql, social_feed.sql and social_learning_tools.sql in Supabase.</p><button className="btn mt-2" disabled={loading} onClick={() => load()}>Retry</button></div>}
      {profileId && !loading && !error && !profile && <p className="small">Profile not found.</p>}
      {!loading && !error && !rows.length && <section className="card p-6"><h2 className="font-bold">{searchTerm ? 'No matching study material' : feedFilter === 'saved' ? 'Your revision list is empty' : feedFilter === 'hidden' ? 'No hidden items' : profileId ? 'No posts or quizzes yet' : 'Your feed starts here'}</h2><p className="small mt-2">{searchTerm ? 'Try another topic or clear your search.' : feedFilter === 'saved' ? 'Save useful discussions and quizzes to revisit them before an exam.' : feedFilter === 'hidden' ? 'Items you hide will appear here so you can restore them.' : profileId ? 'Posts and quizzes will appear here when published.' : 'Share your first post or quiz, or find people to follow.'}</p></section>}
      {rows.map(row => <article className="card p-5" key={`${row.kind}-${row.id}`}><div className="flex items-center gap-3"><button className="avatar bg-indigo-50 text-indigo-700" aria-label={`View ${row.display_name}'s profile`} onClick={() => viewProfile(row.author_id)}>{row.display_name.slice(0, 1).toUpperCase()}</button><div><button className="text-sm font-bold hover:underline" onClick={() => viewProfile(row.author_id)}>{row.display_name}</button><p className="small">{row.headline}</p><time className="small">{new Date(row.created_at).toLocaleString()}</time></div></div>
        {row.kind === 'quiz' ? <div className="mt-4"><span className="pill">COMMUNITY QUIZ</span><h3 className="font-bold mt-2">{row.title}</h3><p className="small mt-2">{row.topic} · {row.question_count} questions</p><div className="mt-3"><CommunityQuizzes quizRow={row} /></div></div> : <p className="text-sm whitespace-pre-wrap leading-7 mt-4">{row.body}</p>}
        <div className="study-item-actions"><button className={`btn ${row.saved ? 'text-indigo-700 bg-indigo-50' : ''}`} type="button" aria-pressed={row.saved} disabled={busy} onClick={() => preference(row, 'save', !row.saved)}><Bookmark size={15} fill={row.saved ? 'currentColor' : 'none'} />{row.saved ? 'Saved for revision' : 'Save for revision'}</button><button className="btn" type="button" disabled={busy} onClick={() => preference(row, 'hide', !row.hidden)}>{row.hidden ? <Eye size={15} /> : <EyeOff size={15} />}{row.hidden ? 'Restore to feed' : 'Hide'}</button></div>
        <PostDiscussion item={row} user={user} onProfile={viewProfile} />
      </article>)}
      {loading && <p className="small" role="status">Loading your wall...</p>}
      {more && <button className="btn" disabled={loading} onClick={() => load(rows.length)}>Load older posts</button>}
    </main>
    <aside className="social-right-sidebar space-y-4">{rightSidebar}<section className="card p-4 h-fit"><h2 className="font-bold text-sm">Find people</h2><label htmlFor="people-search" className="sr-only">Search people by name</label><input id="people-search" className="field mt-3" placeholder="Search by name" value={search} onChange={e => setSearch(e.target.value)} />
      <div className="divide-y divide-slate-100 mt-3">{people.map(person => <button className="block w-full py-3 text-left" key={person.id} onClick={() => viewProfile(person.id)}><b className="text-sm">{person.display_name}</b><span className="small block mt-1">{person.headline || 'View profile'}</span></button>)}</div>{!people.length && <p className="small mt-3">No other members found.</p>}
    </section></aside>
  </div>;
}
