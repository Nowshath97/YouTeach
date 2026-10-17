import fs from 'node:fs/promises';
import assert from 'node:assert/strict';
import { PGlite } from '../tmp/gate2025/runtime/node_modules/@electric-sql/pglite/dist/index.js';
const db = new PGlite();
try {
  await db.exec(`CREATE ROLE anon; CREATE ROLE authenticated; CREATE SCHEMA auth;
    CREATE TABLE auth.users(id UUID PRIMARY KEY);
    CREATE FUNCTION auth.uid() RETURNS UUID LANGUAGE sql AS $$ SELECT nullif(current_setting('request.user_id',true),'')::uuid $$;
    INSERT INTO auth.users VALUES ('00000000-0000-0000-0000-000000000001');`);
  const sql = await fs.readFile('supabase/community_quizzes.sql', 'utf8');
  await db.exec(sql); await db.exec(sql);
  const question = { text: 'Which number is even?', options: ['1','2','3','5'], correct:'1' };
  await assert.rejects(() => db.query('SELECT publish_community_quiz($1,$2,$3)', ['Numbers','Arithmetic',JSON.stringify([question])]), /Sign in/);
  await db.exec(`SET request.user_id='00000000-0000-0000-0000-000000000001'; SET ROLE authenticated;`);
  await assert.rejects(() => db.query('SELECT * FROM community_quizzes'), /permission denied/);
  for (const bad of [[], Array(11).fill(question), [{...question, options:['a','A','c','d']}], [{...question, correct:'9'}]]) {
    await assert.rejects(() => db.query('SELECT publish_community_quiz($1,$2,$3)', ['Numbers','Arithmetic',JSON.stringify(bad)]));
  }
  const id = (await db.query('SELECT publish_community_quiz($1,$2,$3) AS id', ['Numbers','Arithmetic',JSON.stringify(Array(10).fill(question))])).rows[0].id;
  const catalog = (await db.query('SELECT list_community_quizzes() AS data')).rows[0].data;
  assert.equal(catalog[0].question_count, 10); assert.equal(catalog[0].questions, undefined);
  const quiz = (await db.query('SELECT open_community_quiz($1) AS data', [id])).rows[0].data;
  assert.equal(quiz.questions.length, 10); assert.equal(quiz.questions[0].correct, undefined);
  const result = (await db.query('SELECT grade_community_quiz($1,$2) AS data', [id, JSON.stringify({'0':'1','1':'0'})])).rows[0].data;
  assert.equal(result.score,1); assert.equal(result.total,10); assert.equal(result.review[0].correct,'1');
  console.log('PASS: idempotency, authentication, private keys, 10-question limit, duplicate-choice rejection, catalog and grading.');
} finally { await db.close(); }
