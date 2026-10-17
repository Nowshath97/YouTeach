import React, { useEffect, useRef, useState } from 'react';
import { getOfficialPaper } from './OfficialPaperQuestion';

function answerText(answer, options) {
  if (answer == null || answer === '') return 'Unanswered';
  let value = String(answer);
  if (value.startsWith('GATE2025:')) {
    try {
      const key = JSON.parse(value.slice(9));
      if (key.kind === 'NAT') return key.ranges.map(([min, max]) => min === max ? String(min) : `${min} to ${max}`).join(' or ');
      value = key.answers.join(';');
    } catch { return 'Answer key unavailable'; }
  }
  return value.split(/[;,]/).map(part => {
    const option = options?.find(o => typeof o === 'string' ? o === part : String(o.value) === part);
    return option && typeof option === 'object' ? `${part}. ${option.text ?? option.label ?? part}` : part;
  }).join(', ');
}

export default function MockTestReview({ supabase, attemptId, onBack, onClose }) {
  const [questions, setQuestions] = useState([]);
  const [index, setIndex] = useState(0);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);
  const [retry, setRetry] = useState(0);
  const heading = useRef(null);
  useEffect(() => {
    let active = true;
    setLoading(true); setError(''); setQuestions([]); setIndex(0);
    (async () => {
      try {
        const { data, error: failure } = await supabase.rpc('get_mock_test_review', { p_attempt_id: attemptId });
        if (failure) throw failure;
        if (active) setQuestions(data?.questions || []);
      } catch (failure) { if (active) setError(`Review unavailable. ${failure.message}`); }
      finally { if (active) setLoading(false); }
    })();
    return () => { active = false; };
  }, [supabase, attemptId, retry]);
  useEffect(() => { if (!loading) { heading.current?.focus(); heading.current?.scrollIntoView({ block: 'start' }); } }, [index, loading]);
  const pageCount = Math.ceil(questions.length / 20);
  const pagination = <nav className="my-5 flex flex-wrap items-center justify-center gap-2" aria-label="Review pages">
    <button className="btn" disabled={index === 0} onClick={() => setIndex(n => n - 1)}>Previous</button>
    {Array.from({ length: pageCount }, (_, page) => <button key={page} className={`btn ${page === index ? 'btn-primary' : ''}`} aria-label={`Page ${page + 1}`} aria-current={page === index ? 'page' : undefined} onClick={() => setIndex(page)}>{page + 1}</button>)}
    <button className="btn" disabled={index >= pageCount - 1} onClick={() => setIndex(n => n + 1)}>Next</button>
    <span className="w-full text-center text-sm text-slate-500">Questions {index * 20 + 1} to {Math.min((index + 1) * 20, questions.length)} of {questions.length}</span>
  </nav>;
  return <section className="rounded-2xl border bg-white p-5 sm:p-8" aria-label="Read-only test review">
    <div className="flex flex-wrap items-center justify-between gap-3"><div><h2 ref={heading} tabIndex={-1} className="text-xl font-bold">Test review</h2><p className="small mt-2">Read only. Selected answers are green when correct and red when incorrect.</p></div><div className="flex flex-wrap gap-2"><button className="btn" onClick={onBack}>Back to scorecard</button>{onClose && <button className="btn" onClick={onClose}>Back to mock tests</button>}</div></div>
    {loading && <p role="status" className="mt-4">Loading responses...</p>}
    {error && <div role="alert" className="mt-4"><p>{error}</p><button className="btn mt-2" onClick={() => setRetry(n => n + 1)}>Retry</button></div>}
    {!loading && !error && !questions.length && <p className="mt-4">No questions available for this attempt.</p>}
    {!loading && !error && questions.length > 0 && <>{pagination}<div className="space-y-8">{questions.slice(index * 20, (index + 1) * 20).map((question, offset) => <ReviewQuestion key={question.id} question={question} number={index * 20 + offset + 1} />)}</div>{pagination}</>}
  </section>;
}

function ReviewQuestion({ question, number }) {
  const paper = getOfficialPaper(question);
  let source;
  try {
    const url = new URL(paper?.url);
    if (url.protocol === 'https:' && url.hostname === 'gate2025.iitr.ac.in' && url.pathname.endsWith('.pdf')) source = `${url.href}#page=${Math.max(1, Number(paper.page) || 1)}`;
  } catch { /* Invalid paper sources are not linked. */ }
  const image = question.options?.[0]?.question_image;
  const unanswered = question.selected_answer == null || question.selected_answer === '';
  const selected = String(question.selected_answer ?? '').split(/[;,]/).map(v => v.trim().toLowerCase());
  const status = unanswered ? 'Unanswered' : question.is_correct ? 'Correct' : 'Incorrect';
  const tone = question.is_correct ? 'border-emerald-500 bg-emerald-50 text-emerald-900' : 'border-rose-500 bg-rose-50 text-rose-900';
  const options = paper ? paper.response_type === 'NAT' ? [] : ['A','B','C','D'] : Array.isArray(question.options) ? question.options : [];
  return <article className="border-t border-slate-200 pt-6" aria-label={`Question ${number}, ${status}`}>
    <div className="flex flex-wrap justify-between gap-2"><h3 className="font-bold">Question {number}</h3><span className={`text-sm font-semibold ${unanswered ? 'text-slate-500' : question.is_correct ? 'text-emerald-700' : 'text-rose-700'}`}>{status} - {question.marks_awarded} / {question.marks} marks</span></div>
    <p className="my-4 whitespace-pre-wrap leading-7">{question.question_text}</p>
    {image && <img src={image.url} alt={image.alt || 'Question diagram'} className="my-4 max-w-full" />}
    {source && <details className="my-4"><summary className="cursor-pointer text-indigo-700">View original question {paper.number}</summary><a href={source} target="_blank" rel="noreferrer" className="underline">Open original paper</a><iframe loading="lazy" src={source} title={`Original question ${paper.number}`} className="mt-3 h-96 w-full border" /></details>}
    {options.length > 0 ? <ul className="space-y-2">{options.map((o, n) => {
      const label = typeof o === 'string' ? o : o.text ?? o.label ?? '';
      const value = typeof o === 'string' ? o : String(o.value ?? label);
      const chosen = !unanswered && selected.includes(value.trim().toLowerCase());
      return <li key={n} className={`rounded-lg border p-4 ${chosen ? `border-l-4 ${tone}` : 'border-slate-200'}`}>
        {typeof o === 'string' ? label : `${o.value ?? n + 1}. ${label}`}{chosen && <span className="ml-3 text-sm font-bold">Your selection - {status}</span>}
      </li>;
    })}</ul> : <p className={`rounded-lg border border-l-4 p-4 ${unanswered ? 'border-slate-200 bg-slate-50' : tone}`}>Your answer: {answerText(question.selected_answer, question.options)}</p>}
    <div className="mt-4 rounded-xl border border-emerald-200 bg-emerald-50 p-4 text-emerald-800"><strong>Correct answer</strong><p className="mt-2 whitespace-pre-wrap">{answerText(question.correct_answer, question.options)}</p></div>
    {question.explanation && <div className="mt-3 rounded-xl bg-slate-50 p-4"><strong>Explanation / solution</strong><p className="mt-2 whitespace-pre-wrap">{question.explanation}</p></div>}
  </article>;
}
