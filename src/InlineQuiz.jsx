import React, { useEffect, useId, useRef, useState } from 'react';
import { ArrowLeft, ArrowRight, CheckCircle2, RotateCcw } from 'lucide-react';
import { supabase } from './supabase';

export default function InlineQuiz({ quizRow }) {
  const [quiz, setQuiz] = useState(null);
  const [index, setIndex] = useState(0);
  const [answers, setAnswers] = useState({});
  const [result, setResult] = useState(null);
  const [review, setReview] = useState(false);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState('');
  const [direction, setDirection] = useState('next');
  const heading = useRef(null);
  const id = useId();
  useEffect(() => { if (quiz) heading.current?.focus(); }, [quiz, index, result, review]);
  async function start() {
    setBusy(true); setError('');
    try {
      const { data, error: e } = await supabase.rpc('open_community_quiz', { p_id: quizRow.id });
      if (e) throw e;
      if (!data?.questions?.length) throw new Error('This quiz has no questions.');
      setQuiz(data); setIndex(0); setAnswers({}); setResult(null); setReview(false);
    } catch (e) { setError(e.message); } finally { setBusy(false); }
  }
  async function submit() {
    if (busy) return;
    setBusy(true); setError('');
    try {
      const { data, error: e } = await supabase.rpc('grade_community_quiz', { p_id: quiz.id, p_answers: answers });
      if (e) throw e;
      setResult(data);
    } catch (e) { setError(e.message); } finally { setBusy(false); }
  }
  function go(next) {
    setDirection(next > index ? 'next' : 'back'); setIndex(next); setError('');
  }
  const question = quiz?.questions[index];
  const answered = Object.keys(answers).length;
  return <section className="inline-quiz" aria-label={`${quizRow.title} quiz`}>
    {!quiz ? <button className="btn btn-primary" type="button" disabled={busy || !supabase} onClick={start}>{busy ? 'Loading quiz...' : 'Take quiz'}</button> : result && !review ? <div className="inline-quiz-slide" key="result">
      <div className="flex items-center gap-2 text-emerald-700"><CheckCircle2 size={20} /><h4 ref={heading} tabIndex={-1} className="font-bold">Quiz complete</h4></div>
      <p className="inline-quiz-score" role="status">{result.score}<span> / {result.total}</span></p>
      <p className="small">{Math.round(100 * result.score / result.total)}% correct · {result.total - result.score} incorrect</p>
      <div className="flex flex-wrap gap-2 mt-4"><button type="button" className="btn" onClick={() => { setIndex(0); setReview(true); }}>Review answers</button><button type="button" className="btn" disabled={busy} onClick={start}>Try again</button></div>
      <p className="small mt-3">Practice result for this session. It is not saved to mock-test history.</p>
    </div> : <>
      <div className="inline-quiz-meta"><span>{review ? 'Answer review' : `${answered} answered`} · Question {index + 1} of {quiz.questions.length}</span><span className="inline-quiz-marks">1 Mark</span>{review && <button type="button" className="text-indigo-700 font-bold" onClick={() => setReview(false)}>Back to result</button>}</div>
      <div className="inline-quiz-progress" aria-hidden="true"><div style={{ width: `${100 * (index + 1) / quiz.questions.length}%` }} /></div>
      <div key={`${review}-${index}`} className={`inline-quiz-question-card inline-quiz-slide inline-quiz-${direction}`}>
        <h4 ref={heading} tabIndex={-1} id={`${id}-heading`} className="whitespace-pre-wrap text-sm font-semibold leading-7 mt-4">{question.text}</h4>
        <fieldset aria-labelledby={`${id}-heading`} disabled={busy || review} className="inline-quiz-options">
          {question.options.map((option, n) => <label key={n} className={`${answers[index] === String(n) ? 'chosen' : ''} ${review && Number(result.review[index].correct) === n ? 'correct' : ''}`}><input type="radio" name={`${id}-answer-${index}`} value={n} checked={answers[index] === String(n)} onChange={() => setAnswers(previous => ({ ...previous, [index]: String(n) }))} /><span className="inline-quiz-letter" aria-hidden="true">{'ABCD'[n]}</span><span>{option}</span></label>)}
        </fieldset>
        {!review && <button className="btn inline-quiz-clear" type="button" disabled={busy || answers[index] === undefined} onClick={() => setAnswers(previous => { const next = { ...previous }; delete next[index]; return next; })}><RotateCcw size={14} />Clear Answer</button>}
        {review && <p className="small mt-3">Your answer: {'ABCD'[Number(answers[index])]} · Correct answer: {'ABCD'[Number(result.review[index].correct)]}</p>}
      </div>
      <div className="inline-quiz-navigation"><button className="btn" type="button" disabled={busy || index === 0} onClick={() => go(index - 1)}><ArrowLeft size={16} />Previous</button>
        {index < quiz.questions.length - 1 ? <button className="btn btn-primary" type="button" disabled={busy || (!review && answers[index] === undefined)} onClick={() => go(index + 1)}>Next<ArrowRight size={14} /></button> : review ? <button className="btn btn-primary" type="button" onClick={() => setReview(false)}>View result</button> : <button className="btn btn-primary" type="button" disabled={busy || answered !== quiz.questions.length} onClick={submit}>{busy ? 'Checking...' : 'Finish quiz'}</button>}
      </div>
    </>}
    {error && <p className="auth-message" role="alert">{error}</p>}
  </section>;
}
