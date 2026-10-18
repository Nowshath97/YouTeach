export function parseMatchingQuestion(text) {
  if (typeof text !== 'string') return null;
  const match = text.match(/^([\s\S]*?)\n[ \t]*(List[ \t]*(?:[-–—][ \t]*)?(?:I|1)(?:[ \t]*\([^\r\n)]*\))?)[ \t]*:[ \t]*\r?\n([\s\S]*?)\n[ \t]*(List[ \t]*(?:[-–—][ \t]*)?(?:II|2)(?:[ \t]*\([^\r\n)]*\))?)[ \t]*:[ \t]*\r?\n([\s\S]*)$/i);
  if (!match) return null;
  const parse = value => value.trim().split(/\r?\n/).map(line => {
    const item = line.trim().match(/^([A-Z]|\d+)\s*[.)]\s+(.+)$/);
    return item ? { label: item[1], text: item[2] } : null;
  });
  // The instruction after the second list is not another list entry.
  const rightBlock = match[5].trim().split(/\r?\n/);
  const end = rightBlock.findIndex(line => line.trim() && !/^([A-Z]|\d+)\s*[.)]\s+.+$/.test(line.trim()));
  const rightText = (end < 0 ? rightBlock : rightBlock.slice(0, end)).join('\n');
  const instruction = end < 0 ? '' : rightBlock.slice(end).join('\n').trim();
  const left = parse(match[3]), right = parse(rightText);
  if (!left.length || left.length !== right.length || [...left, ...right].some(item => !item)) return null;
  return { stem: match[1], leftTitle: match[2], rightTitle: match[4], left, right, instruction };
}
