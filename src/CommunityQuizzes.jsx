import React, { useEffect, useRef, useState } from 'react';
import { createPortal } from 'react-dom';
import { supabase } from './supabase';
import InlineQuiz from './InlineQuiz';

const blankQuestion = () => ({ text: '', options: ['', '', '', ''], correct: '0' });

function QuizWindow({ title, children, onClose, busy }) {
  const ref = useRef(null);
  const close = useRef(onClose);
  close.current = onClose;
  useEffect(() => {
    const previous = document.activeElement;
    const overflow = document.body.style.overflow;
    document.body.style.overflow = 'hidden';
    ref.current?.querySelector('button')?.focus();
    const keydown = event => {
      if (event.key === 'Escape') close.current();
      if (event.key !== 'Tab') return;
      const items = [...ref.current.querySelectorAll('button:not(:disabled),input:not(:disabled),textarea:not(:disabled),select:not(:disabled)')];
      const first = items[0], last = items[items.length - 1];
      if (event.shiftKey && document.activeElement === first) { event.preventDefault(); last?.focus(); }
      else if (!event.shiftKey && document.activeElement === last) { event.preventDefault(); first?.focus(); }
    };
    document.addEventListener('keydown', keydown);
    return () => { document.body.style.overflow = overflow; document.removeEventListener('keydown', keydown); previous?.focus(); };
  }, []);
  return createPortal(<div className="attempt-modal-backdrop"><section ref={ref} className="attempt-modal" role="dialog" aria-modal="true" aria-labelledby="community-quiz-title"><header className="attempt-modal-header"><h2 id="community-quiz-title">{title}</h2><button className="btn" disabled={busy} onClick={onClose}>Close</button></header><div className="attempt-modal-body">{children}</div></section></div>, document.body);
}

export default function CommunityQuizzes({ quizRow, onPublished }) {
  const [mode, setMode] = useState(null);
  const [title, setTitle] = useState('');
  const [topic, setTopic] = useState('');
  const [questions, setQuestions] = useState([blankQuestion()]);
  const [quiz, setQuiz] = useState(null);
  const [answers, setAnswers] = useState({});
  const [result, setResult] = useState(null);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState('');
  const [notice, setNotice] = useState('');
  const close = () => { if (!busy) { setMode(null); setError(''); } };
  const update = (index, change) => setQuestions(previous => previous.map((q, n) => n === index ? { ...q, ...change } : q));
  async function publish(event) {
    event.preventDefault(); setBusy(true); setError('');
    try {
      const clean = questions.map(q => ({ ...q, text: q.text.trim(), options: q.options.map(o => o.trim()) }));
      if (clean.some(q => new Set(q.options.map(o => o.toLowerCase())).size !== 4)) throw new Error('Use four distinct choices for each question.');
      const { error: e } = await supabase.rpc('publish_community_quiz', { p_title: title.trim(), p_topic: topic.trim(), p_questions: clean });
      if (e) throw e;
      setMode(null); setTitle(''); setTopic(''); setQuestions([blankQuestion()]); setNotice('Your quiz has been posted to the community.'); onPublished?.();
    } catch (e) { setError(e.message); } finally { setBusy(false); }
  }
  async function open(row) {
    setMode('take'); setQuiz(null); setAnswers({}); setResult(null); setError(''); setBusy(true);
    try { const { data, error: e } = await supabase.rpc('open_community_quiz', { p_id: row.id }); if (e) throw e; setQuiz(data); }
    catch (e) { setError(e.message); } finally { setBusy(false); }
  }
  async function grade(event) {
    event.preventDefault(); setBusy(true); setError('');
    try { const { data, error: e } = await supabase.rpc('grade_community_quiz', { p_id: quiz.id, p_answers: answers }); if (e) throw e; setResult(data); }
    catch (e) { setError(e.message); } finally { setBusy(false); }
  }
  if (quizRow) return <InlineQuiz quizRow={quizRow} />;
  return <>
    <button className="btn" type="button" disabled={!supabase} onClick={() => { if (quizRow) open(quizRow); else { setMode('create'); setError(''); setNotice(''); } }}>{quizRow ? 'Take quiz' : 'Post a quiz'}</button>
    {notice && <span className="sr-only" role="status">{notice}</span>}
    {mode && <QuizWindow title={mode === 'create' ? 'Post a quiz' : quiz?.title || 'Loading quiz'} onClose={close} busy={busy}>
      {mode === 'create' ? <form onSubmit={publish} className="space-y-4">
        <label className="block text-xs font-bold">Quiz title<input className="field mt-2" value={title} onChange={e => setTitle(e.target.value)} maxLength={120} required disabled={busy} /></label>
        <label className="block text-xs font-bold">Topic<input className="field mt-2" placeholder="e.g. Soil mechanics" value={topic} onChange={e => setTopic(e.target.value)} maxLength={100} required disabled={busy} /></label>
        <p className="small">{questions.length} / 10 questions. Four choices and one correct answer per question. Review your answers before publishing.</p>
        {questions.map((q, index) => <fieldset key={index} disabled={busy} className="rounded-xl border border-slate-200 p-4 space-y-3"><legend className="px-2 text-sm font-bold">Question {index + 1}</legend>
          <label className="block text-xs">Question<textarea className="field mt-1" value={q.text} onChange={e => update(index, { text: e.target.value })} maxLength={1500} required /></label>
          {q.options.map((option, n) => <label key={n} className="block text-xs">Choice {'ABCD'[n]}<input className="field mt-1" value={option} onChange={e => update(index, { options: q.options.map((o, i) => i === n ? e.target.value : o) })} maxLength={500} required /></label>)}
          <label className="block text-xs">Correct answer<select className="field mt-1" value={q.correct} onChange={e => update(index, { correct: e.target.value })}>{q.options.map((_, n) => <option key={n} value={n}>Choice {'ABCD'[n]}</option>)}</select></label>
          {questions.length > 1 && <button className="btn" type="button" onClick={() => setQuestions(previous => previous.filter((_, n) => n !== index))}>Remove question</button>}
        </fieldset>)}
        <div className="flex flex-wrap gap-2"><button className="btn" type="button" disabled={busy || questions.length >= 10} onClick={() => setQuestions(previous => [...previous, blankQuestion()])}>Add question</button><button className="btn btn-primary" disabled={busy || !supabase}>{busy ? 'Publishing...' : 'Publish quiz'}</button></div>
      </form> : quiz ? <form className="space-y-4" onSubmit={grade}>
        <p className="small">{quiz.topic} · Community authored · 1 point per correct answer</p>
        {result && <p className="profile-success" role="status">Your score: {result.score} / {result.total}. Results for this practice quiz are shown here and are not saved to mock-test history.</p>}
        {quiz.questions.map((q, index) => <fieldset className="rounded-xl border border-slate-200 p-4" disabled={busy || Boolean(result)} key={index}><legend className="px-2 text-sm font-bold">Question {index + 1}</legend><p className="whitespace-pre-wrap text-sm mb-3">{q.text}</p>{q.options.map((option, n) => <label className="flex gap-2 items-start text-sm py-2" key={n}><input type="radio" name={`quiz-${index}`} value={n} checked={answers[index] === String(n)} onChange={() => setAnswers(previous => ({ ...previous, [index]: String(n) }))} /><span>{'ABCD'[n]}. {option}</span></label>)}{result && <p className="text-sm font-bold mt-2">Correct answer: {'ABCD'[Number(result.review[index].correct)]}</p>}</fieldset>)}
        {!result && <button className="btn btn-primary" disabled={busy}>{busy ? 'Checking...' : 'Submit answers'}</button>}
      </form> : busy && <p role="status" className="small">Loading quiz...</p>}
      {error && <p className="auth-message" role="alert">{error}</p>}
    </QuizWindow>}
  </>;
}
