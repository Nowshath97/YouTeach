import React, { useEffect, useRef, useState } from 'react';

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

function ScoreStatistics({ rows }) {
  const completed = rows.filter(row => row.status === 'submitted' && Number(row.total_marks) > 0);
  if (!completed.length) return null;
  const percent = row => 100 * Number(row.score || 0) / Number(row.total_marks);
  const average = completed.reduce((sum, row) => sum + percent(row), 0) / completed.length;
  return <section className="attempt-statistics" aria-label="Score statistics">
    <div className="attempt-summary">
      <div><span>Completed tests</span><strong>{completed.length}</strong></div>
      <div><span>Average score</span><strong>{marks(average)}%</strong></div>
      <div><span>Best score</span><strong>{marks(Math.max(...completed.map(percent)))}%</strong></div>
    </div>
    <h3 className="mt-5 text-sm font-bold">Scores by attempt</h3>
    <p className="small mt-1">Based on loaded completed attempts. Percentages allow comparison across tests with different maximum marks.</p>
    <div className="attempt-chart">{[...completed].reverse().map(row => <div className="attempt-chart-row" key={row.attempt_id}>
      <div><b>{row.title}</b><span>{new Date(row.started_at).toLocaleDateString()}</span></div>
      <div className="attempt-chart-track" aria-hidden="true"><div style={{ width: `${Math.min(100, Math.max(0, percent(row)))}%` }} /></div>
      <span>{marks(row.score)} / {marks(row.total_marks)}<small>{marks(percent(row))}%</small></span>
    </div>)}</div>
  </section>;
}

export default function MockAttemptHistory({ supabase, user, refresh, open, onClose }) {
  const [rows, setRows] = useState([]);
  const [selected, setSelected] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [more, setMore] = useState(false);
  const dialog = useRef(null);
  const requestId = useRef(0);
  const backButton = useRef(null);
    async function load(offset = 0) {
    if (!supabase || !user) return;
    const current = ++requestId.current;
    setLoading(true); setError('');
    try {
      const { data, error: e } = await supabase.rpc('get_mock_attempt_history', { p_limit: 20, p_offset: offset });
      if (requestId.current !== current) return;
      if (e) throw e;
      setRows(previous => offset ? [...previous, ...(data || [])] : data || []);
      setMore(data?.length === 20);
    } catch (e) {
      if (requestId.current === current) setError('Attempt history is unavailable. ' + e.message);
    } finally { if (requestId.current === current) setLoading(false); }
  }
  useEffect(() => {
    if (open) { setRows([]); setSelected(null); setMore(false); load(); }
    return () => { requestId.current++; };
  }, [open, refresh, user?.id]);
  useEffect(() => {
    if (!open) return;
    const previousFocus = document.activeElement;
    const overflow = document.body.style.overflow;
    document.body.style.overflow = 'hidden';
    dialog.current?.querySelector('button')?.focus();
    const keydown = event => {
      if (event.key === 'Escape') { event.preventDefault(); onClose(); }
      if (event.key !== 'Tab') return;
      const controls = [...dialog.current.querySelectorAll('button:not(:disabled), a[href], [tabindex="0"]')];
      const first = controls[0], last = controls[controls.length - 1];
      if (event.shiftKey && document.activeElement === first) { event.preventDefault(); last?.focus(); }
      else if (!event.shiftKey && document.activeElement === last) { event.preventDefault(); first?.focus(); }
    };
    document.addEventListener('keydown', keydown);
    return () => {
      document.body.style.overflow = overflow;
      document.removeEventListener('keydown', keydown);
      previousFocus?.focus();
    };
  }, [open, onClose]);
  useEffect(() => { if (selected) backButton.current?.focus(); }, [selected]);
  if (!open) return null;
  return <div className="attempt-modal-backdrop" onClick={event => { if (event.target === event.currentTarget) onClose(); }}>
    <section ref={dialog} id="mock-attempt-history" className="attempt-modal" role="dialog" aria-modal="true" aria-labelledby="attempt-history-title">
      <header className="attempt-modal-header"><div><span className="eyebrow">YOUR MOCK TESTS</span><h2 id="attempt-history-title">{selected ? 'Attempt details' : 'My attempts'}</h2></div><div className="flex gap-2">
        {selected && <button ref={backButton} className="btn" onClick={() => { setSelected(null); requestAnimationFrame(() => { const button = [...(dialog.current?.querySelectorAll('[data-attempt-id]') || [])].find(item => item.dataset.attemptId === selected.attempt_id); button?.focus(); }); }}>Back to attempts</button>}
        <button className="btn" onClick={onClose}>Close</button>
      </div></header>
      <div className="attempt-modal-body">
        {selected ? <AttemptScorecard result={selected} /> : <>
          {!user && <p className="small">Sign in to view your attempts.</p>}
          {error && <p role="alert" className="text-sm text-rose-700">{error}</p>}
          {!loading && !error && user && !rows.length && <p className="small">No attempts yet. Start a mock test to begin.</p>}
          <ScoreStatistics rows={rows} />
          {rows.length > 0 && <h3 className="mt-6 text-sm font-bold">Attempt history</h3>}
          <div className="divide-y divide-slate-100">{rows.map(row => <div key={row.attempt_id} className="flex flex-wrap items-center justify-between gap-3 py-3"><div><p className="text-sm font-bold">{row.title}</p><p className="small mt-1">{new Date(row.started_at).toLocaleString()} - {row.status.replaceAll('_', ' ')}{row.status === 'submitted' && ` - ${marks(row.score)} / ${marks(row.total_marks)} marks`}</p></div><button className="btn" data-attempt-id={row.attempt_id} onClick={() => setSelected(row)}>View {row.status === 'submitted' ? 'scorecard' : 'details'}</button></div>)}</div>
          {loading && <p className="small" role="status">Loading attempts...</p>}
          {error && <button className="btn mt-3" disabled={loading} onClick={() => load()}>Retry</button>}
          {more && <button className="btn mt-3" disabled={loading} onClick={() => load(rows.length)}>Load older attempts</button>}
        </>}
      </div>
    </section>
  </div>;
}
