import React, { useEffect, useState } from 'react';
import OfficialPaperQuestion, { getOfficialPaper } from './OfficialPaperQuestion';
import { ArrowLeft, ArrowRight, Clock3, Flag, UserRound } from 'lucide-react';

export default function MockExam({ attempt, answers, setAnswers, clock, busy, onSubmit, onPause, onStateChange, saveStatus, error }) {
  const [index, setIndex] = useState(() => Math.max(0, Math.min(attempt.questions.length - 1, Number(attempt.exam_state?.index) || 0)));
  const [paletteOpen, setPaletteOpen] = useState(false);
  useEffect(() => {
    const previousOverflow = document.body.style.overflow;
    document.body.style.overflow = 'hidden';
    return () => { document.body.style.overflow = previousOverflow; };
  }, []);
  const [visited, setVisited] = useState(() => new Set(attempt.exam_state?.visited || [attempt.questions[0]?.id]));
  const [marked, setMarked] = useState(() => new Set(attempt.exam_state?.marked || []));
  useEffect(() => {
    onStateChange?.({ index, visited: [...visited], marked: [...marked] });
  }, [index, visited, marked, onStateChange]);
  const [panel, setPanel] = useState(null);
  const questions = attempt.questions;
  const question = questions[index];
  const paper = question ? getOfficialPaper(question) : null;
  const sectionOf = item => item.section || item.question_text.match(/^\[([^\]]+)\]/)?.[1] || 'All questions';
  const sections = [...new Set(questions.map(sectionOf))];
  const activeSection = question ? sectionOf(question) : sections[0];
  const answered = item => String(answers[item.id] ?? '').trim() !== '';
  const status = item => marked.has(item.id) ? 'marked' : answered(item) ? 'answered' : visited.has(item.id) ? 'unanswered' : 'unvisited';
  const counts = { answered: questions.filter(answered).length, marked: marked.size, unanswered: questions.filter(item => visited.has(item.id) && !answered(item) && !marked.has(item.id)).length, unvisited: questions.filter(item => !visited.has(item.id) && !answered(item) && !marked.has(item.id)).length };
  const go = next => {
    if (busy || next < 0 || next >= questions.length) return;
    setIndex(next);
    setPaletteOpen(false);
    setVisited(previous => new Set([...previous, questions[next].id]));
  };
  const update = value => setAnswers(previous => ({ ...previous, [question.id]: value }));
  const clear = () => setAnswers(previous => { const next = { ...previous }; delete next[question.id]; return next; });
  const review = () => { setMarked(previous => new Set([...previous, question.id])); if (index < questions.length - 1) go(index + 1); };
  if (!question) return <p role="alert">This test has no questions.</p>;
  return <section className={`mock-exam ${paletteOpen ? 'mock-palette-open' : ''}`}>
    <header className="mock-header"><div><span className="mock-kicker">JOBFORSURE · EXAM SIMULATION</span><h2>{attempt.test_title}</h2>{/unofficial/i.test(attempt.test_description || '') && <span className="mock-unofficial">Unofficial practice - independently derived answers</span>}</div><button className="btn mock-palette-toggle" aria-expanded={paletteOpen} aria-controls="mock-sidebar" onClick={() => setPaletteOpen(value => !value)}>{paletteOpen ? 'Close palette' : 'Questions'}</button><div className="flex shrink-0 flex-col gap-2"><div className="mock-timer"><Clock3 size={19} /><div><span>Time left</span><strong role="timer" aria-label={`Time remaining ${clock}`}>{clock}</strong></div></div><button className="btn mock-exit-button justify-center text-xs" disabled={busy} title="Save your progress, pause the timer and return to Mock Tests" onClick={onPause}><ArrowLeft size={14} />{busy ? 'Saving...' : 'Save & exit'}</button><span className="mock-exit-hint">Pauses timer ? Resume later</span></div></header>
    {error && <p className="mock-error" role="alert">{error}</p>}
    <div className="mock-layout"><main className="mock-main">
      <div className="mock-sections"><b>Sections</b><div role="tablist" aria-label="Exam sections">{sections.map(section => <button key={section} role="tab" aria-selected={section === activeSection} onClick={() => go(questions.findIndex(item => sectionOf(item) === section))}>{section}</button>)}</div></div>
      <div className="mock-question-head"><h3>Question {index + 1} <span>of {questions.length}</span></h3><span>{marked.has(question.id) ? 'Flagged for review' : 'Single question view'}</span></div>
      <fieldset className={`mock-question ${paper ? 'mock-question-paper' : ''}`} key={question.id} disabled={busy} tabIndex={0} aria-label={`Question ${index + 1} and answer options`}><legend className="sr-only">Question {index + 1}</legend>{paper ? <OfficialPaperQuestion question={question} value={answers[question.id] || ''} onChange={update} /> : <>{!question.options?.[0]?.question_image?.replaces_text && <p className="mock-question-text">{question.question_text.replace(/^\[[^\]]+\]\s*/, '').split(/(\*\*[^*]+\*\*)/g).map((part, i) => part.startsWith('**') && part.endsWith('**') ? <strong key={i}>{part.slice(2, -2)}</strong> : part)}</p>}
        {question.options?.[0]?.question_image && <img src={question.options[0].question_image.url} alt={question.options[0].question_image.alt} style={{ display: 'block', width: question.options[0].question_image.replaces_text ? '520px' : '320px', maxWidth: '100%', height: 'auto', margin: '8px 0 16px' }} />}
        {question.question_type === 'mcq' && Array.isArray(question.options) ? <div className="mock-options">{question.options.map((option, optionIndex) => { const label = typeof option === 'string' ? option : option.label ?? option.text ?? String(option.value ?? optionIndex + 1); const value = typeof option === 'string' ? option : String(option.value ?? label); return <label key={optionIndex} className={answers[question.id] === value ? 'selected' : ''}><input type="radio" name={question.id} value={value} checked={answers[question.id] === value} onChange={() => update(value)} /><span className="mock-option-letter">{String.fromCharCode(65 + optionIndex)}</span><span>{label}</span></label>; })}</div> : <input className="field mt-5 max-w-sm" aria-label={`Answer for question ${index + 1}`} value={answers[question.id] || ''} onChange={event => update(event.target.value)} />}
      </>}</fieldset>
      <footer className="mock-actions"><button className="btn" onClick={review}><Flag size={14} /> Mark for Review & Next</button><button className="btn" onClick={clear}>Clear Response</button>{marked.has(question.id) && <button className="btn" onClick={() => setMarked(previous => { const next = new Set(previous); next.delete(question.id); return next; })}>Remove Review</button>}<div className="mock-navigation"><button className="btn" disabled={index === 0} onClick={() => go(index - 1)}><ArrowLeft size={14} /> Previous</button><button className="btn mock-save" onClick={() => index === questions.length - 1 ? setPanel('submit') : go(index + 1)}>Save & Next <ArrowRight size={14} /></button></div></footer>
    </main><aside className="mock-sidebar" id="mock-sidebar"><div className="mock-candidate"><UserRound size={30} /><div><b>Candidate</b><span>Mock test in progress</span></div></div><div className="mock-sidebar-body"><h3>Legend</h3><div className="mock-legend">{[['answered','Answered'],['unanswered','Not answered'],['marked','Marked for review'],['unvisited','Not visited']].map(([key,label]) => <div key={key}><span className={`mock-number ${key}`}>{counts[key]}</span><span>{label}</span></div>)}</div><p className="mock-palette-label">Question palette <strong>{activeSection}</strong></p><div className="mock-palette">{questions.map((item, number) => sectionOf(item) === activeSection && <button key={item.id} className={`mock-number ${status(item)} ${number === index ? 'current' : ''}`} aria-current={number === index ? 'step' : undefined} aria-label={`Question ${number + 1}, ${status(item)}${marked.has(item.id) && answered(item) ? ', answered' : ''}`} onClick={() => go(number)}>{number + 1}{marked.has(item.id) && answered(item) && <i />}</button>)}</div><p className="mock-hint">Click a number to jump to a question. Answers are kept as you navigate. A dot on a review flag means answered.</p><p className="mock-hint" role="status">{saveStatus}</p><div className="mock-sidebar-actions"><button className="btn" onClick={() => setPanel('instructions')}>Instructions</button><button className="btn mock-save" disabled={busy} onClick={() => setPanel('submit')}>{busy ? 'Submitting…' : 'Submit Test'}</button></div></div></aside></div>
    {panel && <div className="mock-modal-backdrop"><section className="mock-modal" role="dialog" aria-modal="true" aria-labelledby="mock-dialog-title"><h3 id="mock-dialog-title">{panel === 'submit' ? 'Submit your test?' : 'Test instructions'}</h3>{panel === 'submit' ? <p>You have answered {counts.answered} of {questions.length} questions. {questions.length - counts.answered} remain unanswered and {counts.marked} are marked for review. Answered questions marked for review will also be submitted.</p> : <p>{attempt.test_description && <><strong>{attempt.test_description}</strong><br /><br /></>}Choose one answer for MCQs, select all correct answers for MSQs, and enter a number for numerical questions. Linked-paper tests use the original PDF question numbers and options. Use the section tabs or question palette to navigate. Mark questions to revisit them, or clear a response to leave it unanswered. The timer continues while navigating. Use Save & exit to save your answers and review flags, pause the timer, and return to Mock Tests. Select Resume test to continue where you left off. Leaving or closing the browser without pausing does not stop the clock. The test submits automatically when time runs out.</p>}<div><button autoFocus className="btn" disabled={busy} onClick={() => setPanel(null)}>Back to test</button>{panel === 'submit' && <button className="btn mock-save" disabled={busy} onClick={onSubmit}>{busy ? 'Submitting…' : 'Confirm submission'}</button>}</div></section></div>}
  </section>;
}
