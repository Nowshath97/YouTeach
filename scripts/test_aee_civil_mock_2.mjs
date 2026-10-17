import fs from 'node:fs/promises';
import assert from 'node:assert/strict';
import { PGlite } from '../tmp/gate2025/runtime/node_modules/@electric-sql/pglite/dist/index.js';

const db = new PGlite();
try {
  await db.exec('CREATE ROLE anon; CREATE ROLE authenticated; CREATE SCHEMA auth; CREATE TABLE auth.users(id UUID PRIMARY KEY); CREATE FUNCTION auth.uid() RETURNS UUID LANGUAGE sql AS $$ SELECT NULL::UUID $$;');
  await db.exec((await fs.readFile('supabase/mock_test_setup.sql', 'utf8')).replace(/^\uFEFF/, ''));
  const seed = await fs.readFile('supabase/aee_civil_mock_2_seed.sql', 'utf8');
  await db.exec(seed);
  await db.exec(seed);
  const tests = (await db.query('SELECT * FROM mock_tests')).rows;
  assert.equal(tests.length, 1);
  assert.equal(tests[0].title, 'TGPSC AEE Civil Mock 2');
  assert.equal(tests[0].is_published, true);
  assert.equal(tests[0].duration_minutes, 100);
  assert.equal(Number(tests[0].total_marks), 200);
  const stats = (await db.query('SELECT count(*)::int n, count(distinct display_order)::int ordered, sum(marks)::int marks, sum(negative_marks)::int negative FROM mock_questions')).rows[0];
  assert.deepEqual(stats, { n: 100, ordered: 100, marks: 200, negative: 0 });
  await db.exec("UPDATE mock_questions SET correct_answer='Z' WHERE display_order=1");
  await assert.rejects(() => db.exec(seed), /refusing to overwrite/);
  assert.equal((await db.query('SELECT correct_answer FROM mock_questions WHERE display_order=1')).rows[0].correct_answer, 'Z');
  console.log('PASS: SQL import, repeat import, 100 unique ordered questions, 200 marks, 100 minutes, conflict protection.');
} finally {
  await db.close();
}
