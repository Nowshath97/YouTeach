import React, { useState } from 'react';
import buddhismQuestions from './data/upscBuddhismPyqs.json';
import vedicQuestions from './data/upscVedicPyqs.json';

import { AiChatDrawer, AskAiButton, useAiDrawerState } from './AskAi';

export default function UpscPyqs() {
  const ai = useAiDrawerState();
  const [topic, setTopic] = useState('Vedic Period');
  const questions = topic === 'Vedic Period' ? vedicQuestions : buddhismQuestions;
  const [year, setYear] = useState('All years');
  const [query, setQuery] = useState('');
  const [responses, setResponses] = useState({});
  const years = [...new Set(questions.map(question => question.year).filter(Boolean))].sort((a, b) => b - a);
  const visible = questions.filter(question => (year === 'All years' || (year === 'Not provided' ? !question.year : question.year === Number(year)))
    && `${question.question} ${question.options.map(option => option.text).join(' ')}`.toLowerCase().includes(query.trim().toLowerCase()));
  return <div>
    <div className="explorer-heading"><div><h3>Ancient History · {topic}</h3><p>{questions.length} questions · Years as supplied in the reference text.</p></div></div>
    <div className="upsc-pyq-filters">
      <label>Topic <select value={topic} onChange={event => { setTopic(event.target.value); setYear('All years'); setQuery(''); }}><option>Vedic Period</option><option>Buddhism</option></select></label>
      <label>Year <select value={year} onChange={event => setYear(event.target.value)}><option>All years</option>{years.map(item => <option key={item}>{item}</option>)}{questions.some(question => !question.year) && <option>Not provided</option>}</select></label>
      <label>Search questions <input value={query} onChange={event => setQuery(event.target.value)} placeholder={`Search ${topic} PYQs`} /></label>
    </div>
    <p className="small mt-4">Questions from your supplied reference, with researched answers and explanations. These are not an official UPSC answer key. Year tags remain as supplied.</p>
    <p role="status" className="mt-4">{visible.length} questions · {questions.filter(question => responses[question.id]).length} selected</p>
    <div className="upsc-pyq-list">{visible.map(question => <article key={question.id} className="mock-catalog-card">
      <div className="mock-catalog-top"><strong>Question {questions.indexOf(question) + 1}</strong><span className="previous-paper-badge">{question.year ? `UPSC ${question.year}` : 'UPSC · Year not provided'}</span></div>
      <p className="upsc-pyq-stem">{question.question}</p>
      <fieldset className="upsc-pyq-options"><legend className="sr-only">Choose an answer for question {questions.indexOf(question) + 1}</legend>{question.options.map(option => <label key={option.value} className={responses[question.id] && question.answer ? (option.value === question.answer ? 'is-correct' : responses[question.id] === option.value ? 'is-incorrect' : '') : responses[question.id] === option.value ? 'is-selected' : ''}>
        <input type="radio" name={question.id} value={option.value} checked={responses[question.id] === option.value} onChange={() => setResponses(current => ({ ...current, [question.id]: option.value }))} />
        <span><strong>{option.value}.</strong> {option.text}</span>
      </label>)}</fieldset>
      {responses[question.id] && <div className="upsc-pyq-feedback" role="status">
        <strong>{responses[question.id] === question.answer ? 'Correct!' : 'Incorrect.'} Answer: {question.answer}. {question.options.find(option => option.value === question.answer)?.text}</strong>
        <p>{question.explanation}</p>
        {question.editorialNote && <p className="small">{question.editorialNote}</p>}
      </div>}
      {responses[question.id] && question.explanation && <AskAiButton questionId={question.id} examType="UPSC" questionText={question.question} staticExplanation={question.explanation} onOpen={ai.openDrawer} />}
      {responses[question.id] && <button className="btn" onClick={() => setResponses(current => { const next = { ...current }; delete next[question.id]; return next; })}>Clear selection</button>}
    </article>)}</div>
    {!visible.length && <p className="explorer-empty">No questions match your filters.</p>}
    <AiChatDrawer isOpen={ai.isOpen} onClose={ai.closeDrawer} messages={ai.messages} isLoading={ai.isLoading} context={ai.currentQuestionContext} onSend={ai.sendMessage} />
  </div>;
}
