import React from 'react';
import { ExternalLink } from 'lucide-react';

export const getOfficialPaper = question => Array.isArray(question.options)
  ? question.options.find(option => option && typeof option === 'object' && option.paper)?.paper
  : null;

export default function OfficialPaperQuestion({ question, value = '', onChange }) {
  const paper = getOfficialPaper(question);
  let source;
  try {
    const url = new URL(paper.url);
    if (url.protocol === 'https:' && url.hostname === 'gate2025.iitr.ac.in' && url.pathname.endsWith('.pdf')) source = url.href;
  } catch { /* An invalid source must never become a frame URL. */ }
  const multiple = paper.response_type === 'MSQ';
  const numerical = paper.response_type === 'NAT';
  const selected = String(value).split(';').filter(Boolean);
  const toggle = letter => onChange((selected.includes(letter) ? selected.filter(item => item !== letter) : [...selected, letter]).sort().join(';'));
  const page = Math.max(1, Number(paper.page) || 1);
  const viewer = source ? `${source}#page=${page}&view=FitH` : null;
  return <div className="official-paper-question">
    <div className="official-paper-toolbar"><span><b>Original question {paper.number}</b> / {paper.response_type} / {paper.marks} {paper.marks === 1 ? 'mark' : 'marks'}</span>{viewer && <a href={viewer} target="_blank" rel="noreferrer">Open original PDF <ExternalLink size={12} /></a>}</div>
    {viewer ? <iframe className="official-paper-viewer" src={viewer} title={`Official GATE paper, question ${paper.number}, page ${page}`} /> : <p role="alert">The official paper link is unavailable.</p>}
    <div className="official-paper-response">
      <p>{numerical ? 'Enter the numerical answer requested in the paper.' : multiple ? 'Select ALL correct options from the original question. No partial credit.' : 'Select one option from the original question.'}</p>
      {numerical ? <input className="field" inputMode="decimal" aria-label={`Numerical answer for question ${paper.number}`} placeholder="Enter numerical answer" value={value} onChange={event => onChange(event.target.value)} /> : <div className="official-paper-choices">{['A','B','C','D'].map(letter => <label key={letter} className={(multiple ? selected.includes(letter) : value === letter) ? 'selected' : ''}><input type={multiple ? 'checkbox' : 'radio'} name={question.id} checked={multiple ? selected.includes(letter) : value === letter} onChange={() => multiple ? toggle(letter) : onChange(letter)} /><b>{letter}</b></label>)}</div>}
      <small>PDF page {page}. If your browser does not show or jump within PDFs, use Open original PDF and go to this page. Answer question {paper.number}; some pages contain more than one question.</small>
    </div>
  </div>;
}
