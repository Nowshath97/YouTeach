import React, { useState } from 'react';
import { ArrowLeft, BookOpen, ExternalLink, FileQuestion } from 'lucide-react';

export const previousYearPapers = [
  { code: 'ME', branch: 'Mechanical Engineering', title: 'GATE 2025 Mechanical Engineering', pages: 41 },
  { code: 'EE', branch: 'Electrical Engineering', title: 'GATE 2025 Electrical Engineering', pages: 50 },
  { code: 'CE1', branch: 'Civil Engineering', title: 'GATE 2025 Civil Engineering - Session 1', pages: 43 },
].map(paper => ({ ...paper, url: `https://gate2025.iitr.ac.in/doc/2025/2025_QP/${paper.code}.pdf`, keyUrl: `https://gate2025.iitr.ac.in/doc/2025/2025_Key/${paper.code}_Keys.pdf` }));

export const isLinkedPaperMock = test => previousYearPapers.some(paper => paper.title === test.title)
  && /linked PDF viewer|master paper shown below/i.test(test.description || '');

export default function PreviousYearPapers({ preferredBranch }) {
  const [branch, setBranch] = useState(preferredBranch || 'All branches');
  const [selected, setSelected] = useState(null);
  const visible = previousYearPapers.filter(paper => branch === 'All branches' || paper.branch === branch);
  return <section className="previous-papers">
    <div className="previous-papers-heading"><BookOpen size={24} /><div><h2>Previous Year Question Papers</h2><p>Read the original papers and check the official answer keys.</p></div></div>
    {selected ? <div className="previous-paper-reader">
      <div className="previous-paper-reader-toolbar"><button className="btn" onClick={() => setSelected(null)}><ArrowLeft size={14} /> All papers</button><h3>{selected.title}</h3><a className="btn" href={selected.url} target="_blank" rel="noreferrer">Open PDF <ExternalLink size={13} /></a><a className="btn" href={selected.keyUrl} target="_blank" rel="noreferrer">Answer key <ExternalLink size={13} /></a></div>
      <iframe src={`${selected.url}#view=FitH`} title={selected.title} />
      <p className="small p-3">If the PDF does not display in your browser, select Open PDF. Source: IIT Roorkee, GATE 2025.</p>
    </div> : <>
      <div className="previous-paper-filters" aria-label="Filter papers by branch">{[...new Set(['All branches', preferredBranch, ...previousYearPapers.map(paper => paper.branch)].filter(Boolean))].map(item => <button className={`btn ${branch === item ? 'btn-primary' : ''}`} key={item} onClick={() => setBranch(item)} aria-pressed={branch === item}>{item}</button>)}</div>
      {!visible.length && <p className="small my-4">No previous papers are available for this branch yet.</p>}<div className="mock-catalog-grid">{visible.map(paper => <article className="mock-catalog-card" key={paper.code}><div className="mock-catalog-top"><div className="mock-catalog-icon"><FileQuestion size={21} /></div><span className="previous-paper-badge">PDF PAPER</span></div><div className="mock-catalog-category">{paper.branch}</div><h4>{paper.title}</h4><p className="mock-catalog-description">Original question paper published by IIT Roorkee, with its final official answer key.</p><div className="mock-catalog-details"><span>65 questions</span><span>{paper.pages} pages</span></div><button className="btn btn-primary mock-catalog-start" onClick={() => setSelected(paper)}><BookOpen size={14} /> View question paper</button><a className="previous-paper-key" href={paper.keyUrl} target="_blank" rel="noreferrer">View final answer key <ExternalLink size={12} /></a></article>)}</div>
      <p className="small mt-4">Source: <a href="https://gate2025.iitr.ac.in/question-papers.html" target="_blank" rel="noreferrer" className="text-indigo-700 underline">IIT Roorkee official GATE 2025 archive</a>. PDFs open from the official website and require an internet connection.</p>
    </>}
  </section>;
}
