import assert from 'node:assert/strict';
import fs from 'node:fs';
import { parseMatchingQuestion as parse } from '../src/matchingQuestion.mjs';

const question = `[General English - Vocabulary (Antonyms)]
Match the words in List-I with their most appropriate antonyms in List-II:

List-I (Word):
1. Pragmatic
2. Benevolence
3. Transient
4. Zeal

List-II (Antonym):
A. Malice
B. Quixotic
C. Indifference
D. Perpetual

Choose the correct option:`;
for (const text of [question, question.replaceAll('\n', '\r\n'), question.replaceAll('List-', 'List–')]) {
  const result = parse(text);
  assert.ok(result);
  assert.equal(result.left.length, 4);
  assert.equal(result.right.length, 4);
  assert.equal(result.left[0].text, 'Pragmatic');
  assert.equal(result.right[3].label, 'D');
  assert.equal(result.instruction, 'Choose the correct option:');
  assert.ok(result.leftTitle.includes('(Word)'));
}
let count = 0;
for (const kind of ['gs', 'civil']) {
  const rows = JSON.parse(fs.readFileSync(`supabase/data/aee_2026_${kind}_matching_questions.json`, 'utf8'));
  for (const row of rows) {
    const result = parse(row.question_text);
    if (row.style === 'matching') { assert.ok(result); assert.equal(result.left.length, 4); count++; }
    else assert.equal(result, null);
  }
}
assert.equal(count, 6);
assert.equal(parse('Normal question'), null);
assert.equal(parse('Match:\nList I:\nP. One\nQ. Two\nList II:\n1. One'), null);
console.log('PASS: Q124 format, subtitles, instructions, numbered/lettered entries, CRLF, hyphens, six existing matching items and plain-text fallback.');
