export const isSscCgl = title => /\bssc\s+cgl\b/i.test(title || '') && !/tier[\s-]*(?:ii\b|2\b)/i.test(title || '');
export function sscSectionTiming(attempt, remaining) {
 if (!isSscCgl(attempt.test_title)) return null;
 const questions = attempt.questions || [];
 const total = Number(attempt.duration_minutes) * 60;
 if (questions.length !== 100 || !(total > 0)) return null;
 const elapsed = Math.max(0, total - Math.max(0, Number(remaining)));
 const section = Math.min(3, Math.floor(elapsed / (total / 4)));
 return {section, start: section * 25, end: section * 25 + 24,
  remaining: Math.max(0, Math.ceil((section + 1) * total / 4 - elapsed)), expired: elapsed >= total,
  labels: [0,25,50,75].map((i) => questions[i]?.section || questions[i]?.question_text?.match(/^\[([^\]]+)\]/)?.[1] || ['Reasoning','General Awareness','Quantitative Aptitude','English'][i/25])};
}
