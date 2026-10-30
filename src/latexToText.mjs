// Turns stray LaTeX in AI replies into readable Unicode text (no dependencies).
const SUP = { 0: '⁰', 1: '¹', 2: '²', 3: '³', 4: '⁴', 5: '⁵', 6: '⁶', 7: '⁷', 8: '⁸', 9: '⁹', '+': '⁺', '-': '⁻', '−': '⁻', n: 'ⁿ', i: 'ⁱ', '(': '⁽', ')': '⁾' };
const SUB = { 0: '₀', 1: '₁', 2: '₂', 3: '₃', 4: '₄', 5: '₅', 6: '₆', 7: '₇', 8: '₈', 9: '₉', '+': '₊', '-': '₋', '−': '₋', a: 'ₐ', e: 'ₑ', o: 'ₒ', x: 'ₓ', n: 'ₙ', i: 'ᵢ', j: 'ⱼ', m: 'ₘ', p: 'ₚ', s: 'ₛ', t: 'ₜ', '(': '₍', ')': '₎' };
const SYMBOLS = {
  times: '×', cdot: '·', div: '÷', pm: '±', mp: '∓', approx: '≈', neq: '≠', ne: '≠', leq: '≤', le: '≤', geq: '≥', ge: '≥', infty: '∞',
  rightarrow: '→', to: '→', leftarrow: '←', Rightarrow: '⇒', implies: '⇒', propto: '∝', degree: '°', circ: '°', sum: 'Σ', partial: '∂', nabla: '∇', int: '∫',
  alpha: 'α', beta: 'β', gamma: 'γ', delta: 'δ', epsilon: 'ε', varepsilon: 'ε', eta: 'η', theta: 'θ', lambda: 'λ', mu: 'μ', nu: 'ν', pi: 'π', rho: 'ρ', sigma: 'σ', tau: 'τ', phi: 'φ', varphi: 'φ', omega: 'ω',
  Delta: 'Δ', Gamma: 'Γ', Sigma: 'Σ', Omega: 'Ω', Phi: 'Φ', Theta: 'Θ', Lambda: 'Λ',
};
const script = (text, table) => [...text].every(ch => table[ch]) ? [...text].map(ch => table[ch]).join('') : null;
const isAtom = text => /^[^\s+\-−×·/()=<>,]+$/.test(text); // no spaces or operators: safe to leave without brackets
const group = text => (isAtom(text) ? text : `(${text})`);

const scripts = s => s
  .replace(/\^\{([^{}]*)\}|\^([\w+-])/g, (_, a, b) => { const t = (a ?? b).trim(); return script(t, SUP) ?? `^${group(t)}`; })
  .replace(/_\{([^{}]*)\}|_([\w])/g, (_, a, b) => { const t = (a ?? b).trim(); return script(t, SUB) ?? `_${t}`; });

export function latexToText(input) {
  let s = String(input);
  if (!/[\\$]/.test(s)) return s;
  s = s.replace(/\$\$/g, '').replace(/\\[()[\]]/g, '').replace(/(^|[^\\\w])\$([^$\n]*[\\^_=][^$\n]*)\$/g, '$1$2'); // single $...$ only when it looks like maths, so "$5 and $10" is kept
  s = s.replace(/\\(?:left|right|big|Big|displaystyle)\b\s*/g, '').replace(/\\[,;:! ]|\\quad|\\qquad/g, ' ');
  s = s.replace(/\\(?:text|mathrm|mathbf|mathit|textbf|operatorname|mathcal)\{([^{}]*)\}/g, '$1');
  s = scripts(s); // sub/superscripts first, so their braces don't block \frac and \sqrt below
  for (let i = 0; i < 6; i++) { // innermost-first so nested braces resolve
    s = s.replace(/\\[dt]?frac\{([^{}]*)\}\{([^{}]*)\}/g, (_, a, b) => `${group(a.trim())}/${group(b.trim())}`)
      .replace(/\\sqrt\[([^\]]+)\]\{([^{}]*)\}/g, (_, n, x) => `${script(n, SUP) ?? `${n}^`}√${group(x.trim())}`)
      .replace(/\\sqrt\{([^{}]*)\}/g, (_, x) => `√${group(x.trim())}`);
  }
  s = scripts(s);
  // In LaTeX the space after "\Delta" only ends the command, so "\Delta h" reads "Δh"; operators like \times keep their spaces.
  s = s.replace(/\\([A-Za-z]+)( (?=[A-Za-z]))?/g, (_, name, space) => (SYMBOLS[name] ?? name) + (/^[A-Za-zΑ-Ωα-ω]$/.test(SYMBOLS[name] ?? '') ? '' : space ?? '')).replace(/[{}]/g, '');
  return s;
}
