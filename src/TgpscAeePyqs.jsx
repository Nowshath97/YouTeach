import React, { useEffect, useState } from 'react';
import { supabase } from './supabase';
import { AiChatDrawer, AskAiButton, useAiDrawerState } from './AskAi';

// options is JSONB: accepts ["a","b"] or [{text:"a"}] / [{value:"A",text:"a"}]
const optionText = option => typeof option === 'string' ? option : option?.text ?? option?.label ?? String(option ?? '');
const normalizeOptions = raw => {
  let list = raw;
  if (typeof list === 'string') { try { list = JSON.parse(list); } catch { list = []; } }
  if (list && !Array.isArray(list)) list = Object.values(list);
  return (list || []).map(optionText);
};

// Image URL may live in any text column (name unknown): prefer image-ish column names, else any http(s) value that looks like an image.
const IMAGE_URL = /^https?:\/\/\S+$/i;
const IMAGE_EXT = /\.(png|jpe?g|gif|webp|svg|avif)(\?|#|$)|\/storage\/v1\/object\//i;
const findImageUrl = row => {
  const entries = Object.entries(row).filter(([, value]) => typeof value === 'string' && IMAGE_URL.test(value.trim()));
  const named = entries.find(([key]) => /image|img|diagram|figure|photo|pic/i.test(key));
  const match = named || entries.find(([, value]) => IMAGE_EXT.test(value));
  return match ? match[1].trim() : '';
};

// Text may contain real line breaks or a literal "\n" (typed into the table editor); keep both as line breaks.
const clean = text => String(text ?? '').replace(/\\r\\n|\\n|\\r/g, '\n').replace(/\r\n?/g, '\n').trim();
const MULTILINE = { whiteSpace: 'pre-line' };
// Text shown under the diagram (e.g. "Where S1 and S2 are specific gravity ...")
const findCaption = row => {
  const key = Object.keys(row).find(name => /caption|image_text|image_note|image_desc|figure_text|diagram_text/i.test(name) && typeof row[name] === 'string' && row[name].trim());
  return key ? clean(row[key]) : '';
};

// Consecutive lines containing "|" are drawn as a table (first line = header); an optional |---|---| separator line is skipped.
const isTableLine = line => line.includes('|') && line.split('|').filter(cell => cell.trim()).length >= 2;
const isSeparator = line => /^[\s|:-]+$/.test(line);
const splitCells = line => line.replace(/^\s*\|/, '').replace(/\|\s*$/, '').split('|').map(cell => cell.trim());
// "Match the following" rows keep their two columns separated by a tab (real, or typed as the characters "\t").
const splitTabbed = line => line.replace(/\\t/g, '\t').split(/\t+/).map(cell => cell.trim()).filter(Boolean);
const hasLabel = cell => /^([A-Za-z]+|\d+)\s*[.)]\s+/.test(cell);
const CELL = { border: '1px solid #cbd5e1', padding: '6px 10px' };
function RichText({ text }) {
  const blocks = [];
  let table = [];
  let matching = [];
  const flush = () => { if (table.length) blocks.push({ table }); table = []; };
  const flushMatching = () => { if (matching.length) blocks.push({ matching }); matching = []; };
  clean(text).split('\n').forEach(line => {
    const cells = splitTabbed(line);
    if (cells.length === 2 && hasLabel(cells[0]) && hasLabel(cells[1])) { flush(); matching.push(cells); return; }
    flushMatching();
    if (isTableLine(line)) { if (!isSeparator(line)) table.push(splitCells(line)); }
    else { flush(); blocks.push({ line }); }
  });
  flush();
  flushMatching();
  return <>{blocks.map((block, index) => block.matching
    ? <div key={index} style={{ overflowX: 'auto', margin: '8px 0' }}><table aria-label="Lists to match" style={{ borderCollapse: 'collapse', fontSize: '0.92em' }}>
      <thead><tr><th style={{ ...CELL, background: '#f1f5f9', textAlign: 'left' }}>List I</th><th style={{ ...CELL, background: '#f1f5f9', textAlign: 'left' }}>List II</th></tr></thead>
      <tbody>{block.matching.map((cells, r) => <tr key={r}>{cells.map((cell, i) => <td key={i} style={CELL}>{cell}</td>)}</tr>)}</tbody>
    </table></div>
    : block.table
    ? <div key={index} style={{ overflowX: 'auto', margin: '8px 0' }}><table style={{ borderCollapse: 'collapse', fontSize: '0.92em' }}>
      <thead><tr>{block.table[0].map((cell, i) => <th key={i} style={{ border: '1px solid #cbd5e1', padding: '6px 10px', background: '#f1f5f9', textAlign: 'left' }}>{cell}</th>)}</tr></thead>
      <tbody>{block.table.slice(1).map((cells, r) => <tr key={r}>{cells.map((cell, i) => <td key={i} style={{ border: '1px solid #cbd5e1', padding: '6px 10px' }}>{cell}</td>)}</tr>)}</tbody>
    </table></div>
    : <div key={index} style={MULTILINE}>{block.line}</div>)}</>;
}

export default function TgpscAeePyqs() {
  const [rows, setRows] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [query, setQuery] = useState('');
  const [subject, setSubject] = useState('');
  const [responses, setResponses] = useState({});
  const ai = useAiDrawerState();

  useEffect(() => {
    let active = true;
    if (!supabase) { setError('Supabase is not configured.'); setLoading(false); return; }
    supabase.from('tgpsc_aee_pyqs').select('*').order('question_number', { ascending: true })
      .then(({ data, error: err }) => {
        if (!active) return;
        if (err) setError(err.message); else setRows(data || []);
        setLoading(false);
      });
    return () => { active = false; };
  }, []);

  const search = query.trim().toLowerCase();
  const subjectOf = row => String(row.subject ?? '').trim() || 'Other';
  const subjectCounts = rows.reduce((counts, row) => counts.set(subjectOf(row), (counts.get(subjectOf(row)) || 0) + 1), new Map());
  const subjects = [...subjectCounts.entries()].sort((a, b) => b[1] - a[1] || a[0].localeCompare(b[0]));
  const visible = rows.filter(row => (!subject || subjectOf(row) === subject)
    && (!search || `${row.question_text} ${normalizeOptions(row.options).join(' ')}`.toLowerCase().includes(search)));

  return <div>
    <div className="explorer-heading"><div><h3>TGPSC AEE · Previous Year Questions</h3><p>{rows.length} questions</p></div></div>
    {subjects.length > 0 && <div className="pyq-subject-cards" role="group" aria-label="Filter by subject">
      {[['', rows.length], ...subjects].map(([name, count]) => <button key={name || 'all'} type="button" aria-pressed={subject === name} className={`pyq-subject-card${subject === name ? ' is-active' : ''}`} onClick={() => setSubject(name)}>
        <strong>{name || 'All subjects'}</strong><span>{count} question{count === 1 ? '' : 's'}</span>
      </button>)}
    </div>}
    <div className="upsc-pyq-filters">
      <label>Search questions <input value={query} onChange={event => setQuery(event.target.value)} placeholder="Search TGPSC AEE PYQs" /></label>
    </div>
    {loading && <p role="status" className="mt-4">Loading questions…</p>}
    {error && <p role="alert" className="explorer-empty">Could not load questions: {error}</p>}
    {!loading && !error && <p role="status" className="mt-4">{visible.length} questions · {Object.keys(responses).length} selected</p>}
    <div className="upsc-pyq-list">{visible.map(row => {
      const options = normalizeOptions(row.options);
      const chosen = responses[row.id];
      const hasAnswer = Number.isInteger(row.correct_option);
      return <article key={row.id} className="mock-catalog-card">
        <div className="mock-catalog-top"><strong>Question {row.question_number}</strong><span><span className="previous-paper-badge">{row.exam_year || 'Year not provided'}</span>{row.subject && <span className="previous-paper-badge" style={{ marginLeft: 6 }}>{row.subject}</span>}</span></div>
        <div className="upsc-pyq-stem"><RichText text={row.question_text} /></div>
        {findImageUrl(row) && <figure style={{ margin: '8px 0' }}>
          <img src={findImageUrl(row)} alt={`Diagram for question ${row.question_number}`} loading="lazy" style={{ maxWidth: '100%', maxHeight: 220, width: 'auto', height: 'auto', objectFit: 'contain' }} />
          {findCaption(row) && <figcaption className="small" style={{ ...MULTILINE, marginTop: 6 }}>{findCaption(row)}</figcaption>}
        </figure>}
        <fieldset className="upsc-pyq-options"><legend className="sr-only">Choose an answer for question {row.question_number}</legend>{options.map((text, index) => {
          const number = index + 1;
          const state = chosen && hasAnswer ? (number === row.correct_option ? 'is-correct' : chosen === number ? 'is-incorrect' : '') : chosen === number ? 'is-selected' : '';
          return <label key={number} className={state}>
            <input type="radio" name={`aee-${row.id}`} value={number} checked={chosen === number} onChange={() => setResponses(current => ({ ...current, [row.id]: number }))} />
            <span style={MULTILINE}><strong>{String.fromCharCode(64 + number)}.</strong> {clean(text)}</span>
          </label>;
        })}</fieldset>
        {chosen && hasAnswer && <div className="upsc-pyq-feedback" role="status">
          <strong>{chosen === row.correct_option ? 'Correct!' : 'Incorrect.'} Answer: {String.fromCharCode(64 + row.correct_option)}. {clean(options[row.correct_option - 1])}</strong>
        </div>}
        {chosen && <AskAiButton questionId={`aee-${row.id}`} examType="TGPSC_AEE" questionText={row.question_text} staticExplanation="" onOpen={ai.openDrawer} />}
        {chosen && <button className="btn" onClick={() => setResponses(current => { const next = { ...current }; delete next[row.id]; return next; })}>Clear selection</button>}
      </article>;
    })}</div>
    {!loading && !error && !visible.length && <p className="explorer-empty">No questions found.</p>}
    <AiChatDrawer isOpen={ai.isOpen} onClose={ai.closeDrawer} messages={ai.messages} isLoading={ai.isLoading} context={ai.currentQuestionContext} onSend={ai.sendMessage} />
  </div>;
}
