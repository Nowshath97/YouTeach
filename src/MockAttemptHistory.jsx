import React, { useEffect, useState } from 'react';

const marks = value => Number(value || 0).toLocaleString(undefined, { maximumFractionDigits: 2 });
export function AttemptScorecard({ result, onClose }) {
  const sections = result.sections || [];
  const weakest = [...sections].filter(s => Number(s.total_marks) > 0).sort((a,b) => a.score/a.total_marks - b.score/b.total_marks).slice(0, 2);
  return <section className="rounded-2xl border border-indigo-100 bg-white p-5" aria-label="Attempt scorecard">
    <div className="flex flex-wrap items-start justify-between gap-3"><div><div className="eyebrow">ATTEMPT SCORECARD</div><h3 className="mt-2 font-bold">{result.title || 'Mock test result'}</h3></div>{onClose && <button className="btn" onClick={onClose}>Close scorecard</button>}</div>
    {result.status !== 'submitted' ? <p className="mt-3 text-sm">{result.status === 'expired' ? 'This attempt expired without a scored submission.' : 'This attempt has not been submitted yet.'}</p> : <>
      <p className="mt-4 text-3xl font-extrabold text-indigo-700">{marks(result.score)} <span className="text-base text-slate-500">{result.total_marks != null ? `/ ${marks(result.total_marks)} marks` : 'marks'}</span></p>
      <p className="small mt-2">{result.correct_answers} correct · {result.incorrect_answers} incorrect · {result.unanswered ?? Math.max(0, result.total_questions-result.correct_answers-result.incorrect_answers)} unanswered{result.time_taken_seconds != null && ` · ${Math.floor(result.time_taken_seconds/60)}m ${result.time_taken_seconds%60}s`}</p>
      {sections.length > 0 && <div className="mt-5 overflow-x-auto"><table className="w-full text-left text-sm"><caption className="mb-2 text-left font-bold">Section performance</caption><thead><tr className="border-b text-slate-500">{['Section','Marks','Correct','Incorrect','Unanswered'].map(h => <th className="p-2" key={h}>{h}</th>)}</tr></thead><tbody>{sections.map(s => <tr className="border-b border-slate-100" key={s.section}><th className="p-2 font-semibold">{s.section}</th><td className="p-2">{marks(s.score)} / {marks(s.total_marks)}</td><td className="p-2">{s.correct}</td><td className="p-2">{s.incorrect}</td><td className="p-2">{s.unanswered}</td></tr>)}</tbody></table></div>}
      {weakest.length > 0 && <div className="mt-4 rounded-xl bg-indigo-50 p-4"><h4 className="text-sm font-bold">Where to concentrate next</h4><ul className="mt-2 space-y-2 text-sm">{weakest.map(s => <li key={s.section}><strong>{s.section}:</strong> {Number(s.incorrect) > Number(s.unanswered) ? 'Review mistakes and revise the concepts before another timed attempt.' : Number(s.unanswered) > 0 ? 'Practise timed questions to improve coverage and pacing.' : s.score/s.total_marks >= 0.8 ? 'Maintain your performance with regular practice.' : 'Revise this section and practise a fresh set of questions.'}</li>)}</ul><p className="small mt-2">Based on section marks in this attempt. Topic-level weaknesses cannot be inferred from section totals alone.</p></div>}
    </>}
  </section>;
}

export default function MockAttemptHistory({ supabase, user, refresh, onSelect, open }) {
  const [rows,setRows] = useState([]);
  const [loading,setLoading] = useState(false);
  const [error,setError] = useState('');
  const [more,setMore] = useState(false);
  async function load(offset=0) {
    if (!supabase || !user) return;
    setLoading(true); setError('');
    const {data,error: e} = await supabase.rpc('get_mock_attempt_history',{p_limit:20,p_offset:offset});
    if (e) setError('Attempt history is unavailable. '+e.message);
    else { setRows(previous => offset ? [...previous,...data] : data || []); setMore(data?.length === 20); }
    setLoading(false);
  }
  useEffect(() => { if (open) load(); },[open,refresh,user?.id]);
  if (!open) return null;
  return <section id="mock-attempt-history" aria-label="My attempt history" className="border-b border-slate-100 px-5 pb-4">
    {open && <div className="mt-4">{!user && <p className="small">Sign in to view your attempts.</p>}{error && <p role="alert" className="text-sm text-rose-700">{error}</p>}{!loading && !error && user && !rows.length && <p className="small">No attempts yet. Start a mock test to begin.</p>}<div className="divide-y divide-slate-100">{rows.map(row => <div key={row.attempt_id} className="flex flex-wrap items-center justify-between gap-3 py-3"><div><p className="text-sm font-bold">{row.title}</p><p className="small mt-1">{new Date(row.started_at).toLocaleString()} · {row.status.replace('_',' ')}{row.status==='submitted' && ` · ${marks(row.score)} / ${marks(row.total_marks)} marks`}</p></div><button className="btn" onClick={() => onSelect(row)}>View {row.status==='submitted' ? 'scorecard' : 'details'}</button></div>)}</div>{loading && <p className="small" role="status">Loading attempts…</p>}{more && <button className="btn mt-3" disabled={loading} onClick={() => load(rows.length)}>Load older attempts</button>}</div>}
  </section>;
}
