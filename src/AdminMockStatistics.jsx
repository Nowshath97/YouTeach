import React, {useEffect, useState} from 'react';
import {BarChart3, Users, CheckCircle2, Clock3, RefreshCw, Search, ChevronLeft, ChevronRight} from 'lucide-react';
import {supabase} from './supabase';

const number = value => Number(value || 0).toLocaleString();
export default function AdminMockStatistics() {
 const [summary,setSummary]=useState([]);
 const [result,setResult]=useState({rows:[],total:0});
 const [test,setTest]=useState('');
 const [status,setStatus]=useState('');
 const [search,setSearch]=useState('');
 const [page,setPage]=useState(0);
 const [refresh,setRefresh]=useState(0);
 const [loading,setLoading]=useState(true);
 const [error,setError]=useState('');
 useEffect(()=>{
  let active=true;
  setLoading(true);setError('');setResult({rows:[],total:0});
  const timer=setTimeout(async()=>{
   try {
    const [s,a]=await Promise.all([
     supabase.rpc('admin_mock_summary'),
     supabase.rpc('admin_mock_attempts',{p_test:test||null,p_status:status||null,p_search:search,p_page:page}),
    ]);
    if(!active)return;
    if(s.error||a.error)throw s.error||a.error;
    setSummary(s.data||[]);setResult(a.data||{rows:[],total:0});
   }catch(e){if(active){setSummary([]);setError(e.message||'Unable to load statistics.');}}
   finally{if(active)setLoading(false);}
  },250);
  return()=>{active=false;clearTimeout(timer);};
 },[test,status,search,page,refresh]);
 const totals=summary.reduce((a,r)=>({attempts:a.attempts+Number(r.attempts),submitted:a.submitted+Number(r.submitted),in_progress:a.in_progress+Number(r.in_progress)}),{attempts:0,submitted:0,in_progress:0});
 const selectedSummary = summary.find(r => r.id === test);
 const dateParts = value => value ? [new Date(value).toLocaleDateString(undefined,{day:'2-digit',month:'short',year:'numeric'}),new Date(value).toLocaleTimeString(undefined,{hour:'2-digit',minute:'2-digit'})] : null;
 const renderDate = value => {const parts=dateParts(value);return parts?<><span>{parts[0]}</span><small>{parts[1]}</small></>:<span className="stats-muted">&mdash;</span>;};
 const renderScore = (value,max) => value == null ? <span className="stats-muted">&mdash;</span> : <><strong>{Number(value).toLocaleString(undefined,{maximumFractionDigits:2})}</strong><span className="stats-score-max"> / {number(max)}</span></>;
 return <section className="admin-stats">
  <header className="stats-page-header"><div><div className="stats-eyebrow"><BarChart3 size={14}/> ADMIN WORKSPACE</div><h1>Mock test statistics</h1><p>Track participation, completed attempts and learner scores.</p></div><button className="btn stats-refresh" onClick={()=>setRefresh(r=>r+1)} disabled={loading}><RefreshCw size={15} className={loading?'stats-spinning':''}/> Refresh data</button></header>
  {error&&<p role="alert" className="stats-error">{error}</p>}
  <div className="stats-metrics">{[['Total attempts',totals.attempts,Users,'indigo'],['Submitted',totals.submitted,CheckCircle2,'green'],['In progress / paused',totals.in_progress,Clock3,'amber']].map(([label,value,Icon,tone])=><div className={`stats-metric stats-metric-${tone}`} key={label}><div><p>{label}</p><strong>{loading&&!summary.length?'\u2014':number(value)}</strong></div><span className="stats-metric-icon"><Icon size={22}/></span></div>)}</div>
  <section className="stats-panel" aria-labelledby="mock-summary-heading">
   <div className="stats-panel-heading"><div><h2 id="mock-summary-heading">Performance by mock</h2><p>Final scores include submitted and expired attempts.</p></div><span className="stats-count">{summary.length} mocks</span></div>
   <div className="stats-table-scroll" tabIndex={0} role="region" aria-label="Mock performance table" aria-busy={loading}>
    <table className="stats-table stats-summary-table"><caption className="sr-only">Participation and scores for each mock test</caption><colgroup><col className="stats-mock-col"/>{Array.from({length:5},(_,i)=><col key={i} className="stats-number-col"/>)}<col className="stats-score-col"/><col className="stats-score-col"/></colgroup><thead><tr><th scope="col">Mock test</th>{['Learners','Attempts','Submitted','Expired','In progress','Avg. score','Best score'].map(h=><th scope="col" className="stats-numeric" key={h}>{h}</th>)}</tr></thead><tbody>
     {summary.map(r=><tr key={r.id} className={test===r.id?'stats-selected-row':''}><td><button className="stats-mock-link" onClick={()=>{setTest(r.id);setPage(0);}}>{r.title}</button><span className={`stats-publication ${r.is_published?'is-live':''}`}>{r.is_published?'Published':'Unpublished'}</span></td>{['learners','attempts','submitted','expired','in_progress'].map(k=><td className="stats-numeric" key={k}>{number(r[k])}</td>)}<td className="stats-numeric stats-score">{renderScore(r.average_score,r.total_marks)}</td><td className="stats-numeric stats-score">{renderScore(r.highest_score,r.total_marks)}</td></tr>)}
     {!summary.length&&<tr><td colSpan={8} className="stats-empty">{loading?'Loading mock statistics...':error?'Statistics are unavailable.':'No mock tests to display.'}</td></tr>}
    </tbody></table>
   </div><p className="stats-panel-note">Excludes the testing account. Repeat learner attempts are included. Scores are shown against each mock&apos;s total marks.</p>
  </section>
  <section className="stats-panel" aria-labelledby="user-attempts-heading">
   <div className="stats-panel-heading"><div><h2 id="user-attempts-heading">Learner attempts</h2><p>{selectedSummary?selectedSummary.title:'Browse attempt scores across all mock tests.'}</p></div><span className="stats-count">{loading?'Loading...':`${number(result.total)} attempts`}</span></div>
   <div className="stats-filters">
    <label>Mock test<select value={test} onChange={e=>{setTest(e.target.value);setPage(0);}}><option value="">All mock tests</option>{summary.map(r=><option key={r.id} value={r.id}>{r.title}</option>)}</select></label>
    <label>Attempt status<select value={status} onChange={e=>{setStatus(e.target.value);setPage(0);}}><option value="">All statuses</option><option value="submitted">Submitted</option><option value="expired">Expired</option><option value="in_progress">In progress / paused</option></select></label>
    <label>Search learner<div className="stats-search"><Search size={16}/><input value={search} maxLength={200} onChange={e=>{setSearch(e.target.value);setPage(0);}} placeholder="Search by email"/></div></label>
   </div>
   <div className="stats-table-scroll" tabIndex={0} role="region" aria-label="Learner attempts table" aria-busy={loading}>
    <table className="stats-table stats-attempt-table"><caption className="sr-only">Individual learner attempt scores</caption><colgroup><col style={{width:'25%'}}/><col style={{width:'28%'}}/><col style={{width:'15%'}}/><col style={{width:'10%'}}/><col style={{width:'11%'}}/><col style={{width:'11%'}}/></colgroup><thead><tr><th scope="col">Learner</th><th scope="col">Mock test</th><th scope="col">Status</th><th scope="col" className="stats-numeric">Score</th><th scope="col">Started</th><th scope="col">Finished</th></tr></thead><tbody>
     {!loading&&result.rows.map(r=><tr key={r.id}><td><div className="stats-learner"><span className="stats-avatar">{(r.email||'U').slice(0,1).toUpperCase()}</span><span className="stats-email" title={r.email||r.student_id}>{r.email||r.student_id}</span></div></td><td className="stats-attempt-title">{r.title}</td><td><span className={`stats-status stats-status-${r.status}`}><i/>{r.status==='in_progress'?'In progress':r.status==='submitted'?'Submitted':'Expired'}</span></td><td className="stats-numeric stats-score">{renderScore(r.score,r.total_marks)}</td><td className="stats-date">{renderDate(r.started_at)}</td><td className="stats-date">{renderDate(r.submitted_at)}</td></tr>)}
     {(loading||!result.rows.length)&&<tr><td colSpan={6} className="stats-empty"><BarChart3 size={26}/><span role="status">{loading?'Loading learner attempts...':error?'Attempts are unavailable.':'No attempts match your filters.'}</span></td></tr>}
    </tbody></table>
   </div>
   <footer className="stats-pagination"><span>{loading?'Loading...':Number(result.total)>0?`Showing ${number(page*50+1)}-${number(page*50+result.rows.length)} of ${number(result.total)} attempts`:'0 attempts'}<span className="stats-page-number">Page {page+1}</span></span><div><button className="btn" disabled={loading||page===0} onClick={()=>setPage(p=>p-1)}><ChevronLeft size={14}/> Previous</button><button className="btn" disabled={loading||(page+1)*50>=Number(result.total)} onClick={()=>setPage(p=>p+1)}>Next <ChevronRight size={14}/></button></div></footer>
  </section>
 </section>;
}
