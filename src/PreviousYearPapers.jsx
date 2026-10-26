import React, { useRef, useState } from 'react';
import { ArrowLeft, ArrowRight, BookOpen, ExternalLink, FileQuestion, GraduationCap, Search } from 'lucide-react';
import { examCatalog, examFamilies } from './mockExamCatalog.mjs';
import { revealMobileResults } from './catalogNavigation.mjs';
import UpscPyqs from './UpscPyqs';
import TgpscAeePyqs from './TgpscAeePyqs';
import GatePyqs from './GatePyqs';

export const previousYearPapers = [
  { code: 'ME', branch: 'Mechanical Engineering', title: 'GATE 2025 Mechanical Engineering', pages: 41 },
  { code: 'EE', branch: 'Electrical Engineering', title: 'GATE 2025 Electrical Engineering', pages: 50 },
  { code: 'CE1', branch: 'Civil Engineering', title: 'GATE 2025 Civil Engineering - Session 1', pages: 43 },
].map(paper => ({ ...paper, examId: 'gate', url: `https://gate2025.iitr.ac.in/doc/2025/2025_QP/${paper.code}.pdf`, keyUrl: `https://gate2025.iitr.ac.in/doc/2025/2025_Key/${paper.code}_Keys.pdf` }));

export const isLinkedPaperMock = test => previousYearPapers.some(paper => paper.title === test.title)
  && /linked PDF viewer|master paper shown below/i.test(test.description || '');

export default function PreviousYearPapers({ preferredBranch }) {
  const [exam, setExam] = useState(null);
  const [family, setFamily] = useState('All Exams');
  const [query, setQuery] = useState('');
  const [branch, setBranch] = useState('All branches');
  const [selected, setSelected] = useState(null);
  const resultsRef = useRef(null);
  const readerRef = useRef(null);
  const activeExam = examCatalog.find(item => item.id === exam);
  const examPapers = previousYearPapers.filter(paper => paper.examId === exam);
  const branches = ['All branches', ...new Set(examPapers.map(paper => paper.branch))];
  const search = query.trim().toLowerCase();
  const visible = examPapers.filter(paper => (branch === 'All branches' || paper.branch === branch)
    && (!search || `${paper.title} ${paper.branch}`.toLowerCase().includes(search)));
  const cards = examCatalog.map(item => ({ ...item, papers: item.id === 'upsc' ? [{ title: 'Ancient History Buddhism Vedic Period', branch: 'Ancient History' }] : item.id === 'aee' ? [{ title: 'TGPSC AEE PYQs', branch: 'Questions' }] : previousYearPapers.filter(paper => paper.examId === item.id) }))
    .filter(item => (family === 'All Exams' || item.family === family)
      && (!search || `${item.name} ${item.family}`.toLowerCase().includes(search)
        || item.papers.some(paper => `${paper.title} ${paper.branch}`.toLowerCase().includes(search))));
  function openExam(item) {
    setExam(item.id);
    setBranch(item.papers.some(paper => paper.branch === preferredBranch) ? preferredBranch : 'All branches');
    setQuery('');
  }
  return <section className="exam-explorer">
    <div className="explorer-heading"><div>
      {activeExam && <button className="explorer-back" onClick={() => { setExam(null); setSelected(null); setQuery(''); }}><ArrowLeft size={15} /> All exams</button>}
      <h2>{activeExam ? `${activeExam.name} PYQs` : 'PYQs'}</h2>
      <p>Explore previous year question papers and official answer keys by exam.</p>
    </div></div>
    {exam === 'upsc' ? <UpscPyqs /> : exam === 'aee' ? <TgpscAeePyqs /> : selected ? <div ref={readerRef} tabIndex={-1} className="previous-paper-reader catalog-results">
      <div className="previous-paper-reader-toolbar"><button className="btn" onClick={() => setSelected(null)}><ArrowLeft size={14} /> All papers</button><h3>{selected.title}</h3><a className="btn" href={selected.url} target="_blank" rel="noreferrer">Open PDF <ExternalLink size={13} /></a><a className="btn" href={selected.keyUrl} target="_blank" rel="noreferrer">Answer key <ExternalLink size={13} /></a></div>
      <GatePyqs paper={selected} year={2025} fallback={<>
        <iframe src={`${selected.url}#view=FitH`} title={selected.title} />
        <p className="small p-3">If the PDF does not display in your browser, select Open PDF. Source: IIT Roorkee, GATE 2025.</p>
      </>} />
      <p className="small p-3">Source: IIT Roorkee, GATE 2025.</p>
    </div> : <>
      <label className="explorer-search"><Search size={18} /><input value={query} onChange={event => setQuery(event.target.value)} placeholder={activeExam ? 'Search papers in this exam' : 'Search exams or previous year papers'} aria-label="Search PYQs" /></label>
      {!activeExam ? <>
        <div className="explorer-filters" role="group" aria-label="Exam categories">{examFamilies.map(item => <button key={item} aria-pressed={family === item} className={family === item ? 'active' : ''} onClick={() => setFamily(item)}>{item}</button>)}</div>
        <div className="exam-explorer-grid">{cards.map(item => <button key={item.id} disabled={!item.papers.length} className={`exam-explorer-card exam-tone-${item.tone}`} onClick={() => openExam(item)}>
          <span className="exam-card-top"><span className="exam-card-icon">{item.family === 'Engineering' ? <GraduationCap size={26} /> : <FileQuestion size={25} />}</span><span><strong>{item.name}</strong><span className="exam-family-tag">{item.family}</span></span></span>
          <span className="exam-card-count">{item.id === 'upsc' ? '39 questions' : item.id === 'aee' ? 'Question bank' : item.papers.length ? `${item.papers.length} ${item.papers.length === 1 ? 'paper' : 'papers'}` : 'Coming soon'}</span>
          <span className="exam-card-bottom"><span>{item.id === 'upsc' ? 'Browse questions by topic and year' : item.id === 'aee' ? 'Practice previous year questions' : item.papers.length ? 'Original papers and official answer keys' : 'Papers will be added for this exam.'}</span><span className="exam-card-arrow"><ArrowRight size={17} /></span></span>
        </button>)}</div>
        {!cards.length && <p className="explorer-empty">No exams match your search.</p>}
      </> : <>
        <section className="mock-branch-cards-section" aria-label="Choose a branch"><div className="mock-branch-cards-heading"><h3>Choose your branch</h3><p>Browse papers by discipline.</p></div>
          <div className="mock-branch-cards" role="group" aria-label="Filter PYQs by branch">{branches.map(item => <button type="button" key={item} className={`mock-branch-choice ${branch === item ? 'is-selected' : ''}`} aria-pressed={branch === item} onClick={() => { setBranch(item); revealMobileResults(resultsRef); }}>{item}</button>)}</div>
        </section>
        <div ref={resultsRef} tabIndex={-1} className="exam-list-toolbar catalog-results" aria-label="Filtered previous year papers"><p role="status"><strong>{visible.length}</strong> available {visible.length === 1 ? 'paper' : 'papers'}<span className="ml-2">in {branch}</span></p></div>
        {!visible.length && <p className="explorer-empty">No papers match your search or branch.</p>}
        <div className="mock-catalog-grid">{visible.map(paper => <article className="mock-catalog-card" key={paper.code}><div className="mock-catalog-top"><div className="mock-catalog-icon"><FileQuestion size={21} /></div><span className="previous-paper-badge">PDF PAPER</span></div><div className="mock-catalog-category">{paper.branch}</div><h4>{paper.title}</h4><p className="mock-catalog-description">Original question paper published by IIT Roorkee, with its final official answer key.</p><div className="mock-catalog-details"><span>65 questions</span><span>{paper.pages} pages</span></div><button className="btn btn-primary mock-catalog-start" onClick={() => { setSelected(paper); revealMobileResults(readerRef); }}><BookOpen size={14} /> View question paper</button><a className="previous-paper-key" href={paper.keyUrl} target="_blank" rel="noreferrer">View final answer key <ExternalLink size={12} /></a></article>)}</div>
        <p className="small mt-4">Source: <a href="https://gate2025.iitr.ac.in/question-papers.html" target="_blank" rel="noreferrer" className="text-indigo-700 underline">IIT Roorkee official GATE 2025 archive</a>. PDFs open from the official website and require an internet connection.</p>
      </>}
    </>}
  </section>;
}
