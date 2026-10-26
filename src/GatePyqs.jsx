import React, { useEffect, useState } from 'react';
import { supabase } from './supabase';
import { RichText, clean } from './TgpscAeePyqs';

const subjectOf = row => String(row.subject ?? '').trim() || 'Other';
const imagesOf = row => (Array.isArray(row.option_image_urls) ? row.option_image_urls : []).map(url => String(url ?? '').trim());
const optionsOf = row => (Array.isArray(row.options) ? row.options : []).filter(option => option != null && String(option).trim());

// Numerical-answer questions store accepted ranges as JSON: [[min, max], ...]. A single value uses [v, v].
const rangesOf = row => {
  let list = row.answer_ranges;
  if (typeof list === 'string') { try { list = JSON.parse(list); } catch { list = null; } }
  return (Array.isArray(list) ? list : [])
    .filter(range => Array.isArray(range) && range.length === 2 && range.every(value => Number.isFinite(Number(value))))
    .map(([low, high]) => [Number(low), Number(high)]);
};
const NUMBER = /^[+-]?(\d+\.?\d*|\.\d+)(e[+-]?\d+)?$/i;
const isNumber = text => NUMBER.test(String(text ?? '').trim());
const inRanges = (value, ranges) => ranges.some(([low, high]) => value >= Math.min(low, high) - 1e-9 && value <= Math.max(low, high) + 1e-9);
const describeRanges = ranges => ranges.map(([low, high]) => (low === high ? String(low) : `${low} to ${high}`)).join(' or ');

// Multi-select questions (MSQ) store every correct option, counting from 1, in correct_options (e.g. {1,3}).
const multiOf = row => (Array.isArray(row.correct_options) ? row.correct_options : []).map(Number).filter(value => Number.isInteger(value) && value > 0);
const letterList = numbers => [...numbers].sort((a, b) => a - b).map(value => String.fromCharCode(64 + value)).join(', ');
const sameSet = (a, b) => a.length === b.length && a.every(value => b.includes(value));

// Shows a GATE paper's questions from the gate_pyqs table; falls back to the supplied PDF viewer
// when the table is unreachable or has no rows for this paper.
export default function GatePyqs({ paper, year = 2025, fallback }) {
  const [rows, setRows] = useState([]);
  const [loading, setLoading] = useState(true);
  const [failed, setFailed] = useState('');
  const [subject, setSubject] = useState('');
  const [query, setQuery] = useState('');
  const [responses, setResponses] = useState({});
  const [submissions, setSubmissions] = useState({});

  useEffect(() => {
    let active = true;
    setLoading(true); setFailed(''); setRows([]); setSubject(''); setResponses({}); setSubmissions({});
    if (!supabase) { setFailed('Supabase is not configured.'); setLoading(false); return undefined; }
    supabase.from('gate_pyqs').select('*').eq('exam_year', year).eq('branch', paper.code).order('question_number', { ascending: true })
      .then(({ data, error }) => {
        if (!active) return;
        if (error) setFailed(`The database returned an error: ${error.message}`);
        else if (!data?.length) setFailed(`No rows in gate_pyqs for exam_year ${year} and branch "${paper.code}". Check the branch code stored in the table, and that signed-in users are allowed to read it.`);
        else setRows(data);
        setLoading(false);
      });
    return () => { active = false; };
  }, [paper.code, year]);

  if (loading) return <p role="status" className="p-4">Loading questions...</p>;
  if (failed) return <>
    <p className="auth-notice" role="status" style={{ margin: 12 }}>Showing the original PDF instead of the question bank. {failed}</p>
    {fallback}
  </>;

  const subjectCounts = rows.reduce((counts, row) => counts.set(subjectOf(row), (counts.get(subjectOf(row)) || 0) + 1), new Map());
  const search = query.trim().toLowerCase();
  const visible = rows.filter(row => (!subject || subjectOf(row) === subject)
    && (!search || `${row.question_text} ${optionsOf(row).join(' ')}`.toLowerCase().includes(search)));
  const anyGraded = rows.some(row => Number.isInteger(row.correct_option) || rangesOf(row).length > 0 || multiOf(row).length > 0);
  const typeNumber = (id, value) => {
    setResponses(current => ({ ...current, [id]: value }));
    setSubmissions(current => { const next = { ...current }; delete next[id]; return next; });
  };
  const submitNumber = id => {
    const typed = String(responses[id] ?? '').trim();
    if (isNumber(typed)) setSubmissions(current => ({ ...current, [id]: Number(typed) }));
  };
  const toggleOption = (id, number) => {
    setResponses(current => {
      const picked = Array.isArray(current[id]) ? current[id] : [];
      const next = picked.includes(number) ? picked.filter(value => value !== number) : [...picked, number];
      const updated = { ...current };
      if (next.length) updated[id] = next; else delete updated[id];
      return updated;
    });
    setSubmissions(current => { const next = { ...current }; delete next[id]; return next; });
  };
  const submitOptions = id => {
    const picked = Array.isArray(responses[id]) ? responses[id] : [];
    if (picked.length) setSubmissions(current => ({ ...current, [id]: [...picked] }));
  };
  const clearAnswer = id => {
    setResponses(current => { const next = { ...current }; delete next[id]; return next; });
    setSubmissions(current => { const next = { ...current }; delete next[id]; return next; });
  };

  return <div className="p-4">
    <div className="pyq-subject-cards" role="group" aria-label="Filter by subject">
      {[['', rows.length], ...subjectCounts].map(([name, count]) => <button key={name || 'all'} type="button" aria-pressed={subject === name} className={`pyq-subject-card${subject === name ? ' is-active' : ''}`} onClick={() => setSubject(name)}>
        <strong>{name || 'All subjects'}</strong><span>{count} question{count === 1 ? '' : 's'}</span>
      </button>)}
    </div>
    <div className="upsc-pyq-filters">
      <label>Search questions <input value={query} onChange={event => setQuery(event.target.value)} placeholder={`Search ${paper.title}`} /></label>
    </div>
    <p role="status" className="mt-4">{visible.length} questions &middot; {Object.keys(responses).length} answered</p>
    {!anyGraded && <p className="small mt-1">Answers are not graded here. Compare your choices with the official answer key.</p>}
    <div className="upsc-pyq-list">{visible.map(row => {
      const options = optionsOf(row);
      const images = imagesOf(row);
      const count = Math.max(options.length, images.length);
      const chosen = responses[row.id];
      const hasAnswer = Number.isInteger(row.correct_option) && count > 0;
      const ranges = rangesOf(row);
      const submitted = submissions[row.id];
      const multi = multiOf(row);
      const picked = Array.isArray(chosen) ? chosen : [];
      const choose = value => setResponses(current => ({ ...current, [row.id]: value }));
      return <article key={row.id} className="mock-catalog-card">
        <div className="mock-catalog-top"><strong>Question {row.question_number}</strong><span>
          <span className="previous-paper-badge">{subjectOf(row)}</span>
        </span></div>
        <div className="upsc-pyq-stem"><RichText text={row.question_text} /></div>
        {row.diagram_url && <figure style={{ margin: '8px 0' }}>
          <img src={row.diagram_url} alt={`Diagram for question ${row.question_number}`} loading="lazy" style={{ maxWidth: '100%', maxHeight: 260, width: 'auto', height: 'auto', objectFit: 'contain' }} />
        </figure>}
        {count > 0 && multi.length > 0
          ? <form onSubmit={event => { event.preventDefault(); submitOptions(row.id); }}>
            <fieldset className="upsc-pyq-options"><legend className="sr-only">Select all correct answers for question {row.question_number}</legend>
              <p className="small">Select all options that are correct.</p>
              {Array.from({ length: count }, (_, index) => {
                const number = index + 1;
                const isPicked = picked.includes(number);
                const state = Array.isArray(submitted) ? (multi.includes(number) ? 'is-correct' : isPicked ? 'is-incorrect' : '') : isPicked ? 'is-selected' : '';
                return <label key={number} className={state}>
                  <input type="checkbox" checked={isPicked} onChange={() => toggleOption(row.id, number)} />
                  <span style={{ whiteSpace: 'pre-line' }}><strong>{String.fromCharCode(64 + number)}.</strong> {images[index]
                    ? <img src={images[index]} alt={`Option ${String.fromCharCode(64 + number)}`} loading="lazy" style={{ display: 'block', marginTop: 6, maxWidth: '100%', maxHeight: 180, objectFit: 'contain' }} />
                    : clean(options[index])}</span>
                </label>;
              })}
            </fieldset>
            <button className="btn btn-primary" type="submit" disabled={!picked.length}>Submit answer</button>
          </form>
          : count > 0
          ? <fieldset className="upsc-pyq-options"><legend className="sr-only">Choose an answer for question {row.question_number}</legend>{Array.from({ length: count }, (_, index) => {
            const number = index + 1;
            const state = chosen && hasAnswer ? (number === row.correct_option ? 'is-correct' : chosen === number ? 'is-incorrect' : '') : chosen === number ? 'is-selected' : '';
            return <label key={number} className={state}>
              <input type="radio" name={`gate-${row.id}`} value={number} checked={chosen === number} onChange={() => choose(number)} />
              <span style={{ whiteSpace: 'pre-line' }}><strong>{String.fromCharCode(64 + number)}.</strong> {images[index]
                ? <img src={images[index]} alt={`Option ${String.fromCharCode(64 + number)}`} loading="lazy" style={{ display: 'block', marginTop: 6, maxWidth: '100%', maxHeight: 180, objectFit: 'contain' }} />
                : clean(options[index])}</span>
            </label>;
          })}</fieldset>
          : <form onSubmit={event => { event.preventDefault(); submitNumber(row.id); }} style={{ display: 'flex', flexWrap: 'wrap', alignItems: 'flex-end', gap: 8, marginBottom: 4 }}>
              <label className="small" style={{ display: 'grid', gap: 6, width: 220 }}>Your numerical answer
                <input className="field" inputMode="decimal" autoComplete="off" value={chosen ?? ''} onChange={event => typeNumber(row.id, event.target.value)} aria-invalid={Boolean(chosen) && !isNumber(chosen)} /></label>
              <button className="btn btn-primary" type="submit" disabled={!isNumber(chosen)}>Submit answer</button>
              {Boolean(chosen) && !isNumber(chosen) && <span className="small" role="alert" style={{ color: '#be123c' }}>Enter a number, for example 12.5</span>}
            </form>}
        {submitted != null && count === 0 && ranges.length === 0 && <div className="upsc-pyq-feedback" role="status">
          <strong>Answer submitted.</strong> You entered {submitted}. This question is not marked here yet, so compare it with the official answer key.
        </div>}
        {submitted != null && ranges.length > 0 && <div className="upsc-pyq-feedback" role="status">
          <strong>{inRanges(submitted, ranges) ? 'Correct!' : 'Incorrect.'}</strong> You entered {submitted}. Accepted answer: {describeRanges(ranges)}.
        </div>}
        {Array.isArray(submitted) && multi.length > 0 && <div className="upsc-pyq-feedback" role="status">
          <strong>{sameSet(submitted, multi) ? 'Correct!' : 'Incorrect.'}</strong> You selected {letterList(submitted)}. Correct options: {letterList(multi)}. All correct options must be selected, with no extras.
        </div>}
        {chosen && hasAnswer && <div className="upsc-pyq-feedback" role="status">
          <strong>{chosen === row.correct_option ? 'Correct!' : 'Incorrect.'} Answer: {String.fromCharCode(64 + row.correct_option)}.{images[row.correct_option - 1] ? '' : ` ${clean(options[row.correct_option - 1])}`}</strong>
        </div>}
        {chosen != null && chosen !== '' && <button type="button" className="btn" style={{ alignSelf: 'flex-start', marginTop: 12 }} onClick={() => clearAnswer(row.id)}>{count === 0 || multi.length > 0 ? 'Clear answer' : 'Clear selection'}</button>}
      </article>;
    })}</div>
    {!visible.length && <p className="explorer-empty">No questions found.</p>}
  </div>;
}
