import React from 'react';
import { latexToText } from './latexToText.mjs';

// Assistant replies are meant to be plain text with Unicode maths, but models sometimes still emit LaTeX
// (\( F_r = V / \sqrt{gD} \)) or Markdown. This turns that into readable text without any extra libraries.

// **bold** inline; "- " / "* " list items shown with a bullet.
function renderInline(line, key) {
  return line.split(/(\*\*[^*]+\*\*)/g).map((part, i) => /^\*\*[^*]+\*\*$/.test(part) ? <strong key={`${key}-${i}`}>{part.slice(2, -2)}</strong> : part);
}

export default function FormattedMessage({ text }) {
  const lines = latexToText(text).replace(/^\s{0,3}#{1,6}\s+/gm, '').split('\n');
  return <>{lines.map((raw, index) => {
    const bullet = /^(\s*)[-*•]\s+(.*)$/.exec(raw);
    const line = bullet ? `${bullet[1]}• ${bullet[2]}` : raw;
    return <div key={index} style={{ whiteSpace: 'pre-wrap', minHeight: line ? undefined : '0.6em' }}>{renderInline(line, index)}</div>;
  })}</>;
}
