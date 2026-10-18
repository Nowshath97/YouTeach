import React from 'react';
import { parseMatchingQuestion } from './matchingQuestion.mjs';

function formatted(text) {
  return text.split(/(\*\*[^*]+\*\*)/g).map((part, index) => part.startsWith('**') && part.endsWith('**') ? <strong key={index}>{part.slice(2, -2)}</strong> : part);
}

export default function QuestionText({ text, className = '' }) {
  const matching = parseMatchingQuestion(text);
  if (!matching) return <p className={className}>{formatted(text)}</p>;
  return <div className={className}>
    <p>{formatted(matching.stem)}</p>
    <div className="matching-question-table-wrap">
      <table className="matching-question-table" aria-label="Lists to match">
        <thead><tr><th scope="col">{matching.leftTitle}</th><th scope="col">{matching.rightTitle}</th></tr></thead>
        <tbody>{matching.left.map((item, index) => <tr key={item.label}>
          <td><b>{item.label}.</b> {formatted(item.text)}</td>
          <td><b>{matching.right[index].label}.</b> {formatted(matching.right[index].text)}</td>
        </tr>)}</tbody>
      </table>
    </div>
    {matching.instruction && <p className="mt-4">{formatted(matching.instruction)}</p>}
  </div>;
}
