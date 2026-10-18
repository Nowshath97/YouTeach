import fs from 'node:fs/promises';
import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { PGlite } from '../tmp/gate2025/runtime/node_modules/@electric-sql/pglite/dist/index.js';
const db = new PGlite();
const read = async path => (await fs.readFile(path, 'utf8')).replace(/^\uFEFF/, '');
try {
  await db.exec(`CREATE ROLE anon; CREATE ROLE authenticated; CREATE SCHEMA auth;
    CREATE TABLE auth.users(id uuid PRIMARY KEY);
    CREATE FUNCTION auth.uid() RETURNS uuid LANGUAGE sql AS $$ SELECT nullif(current_setting('request.user_id',true),'')::uuid $$;`);
  await db.exec(await read('supabase/mock_test_setup.sql'));
  // Test upgrading the previous committed GS bank, not just the already-revised seed.
  const oldSeed = execFileSync('git', ['show', 'HEAD:supabase/seeds/tgpsc_aee_2026_gs_mock_01.sql'], { encoding: 'utf8', maxBuffer: 4e6 });
  const oldBank = JSON.parse(execFileSync('git', ['show', 'HEAD:supabase/data/aee_2026_gs_questions.json'], { encoding: 'utf8', maxBuffer: 4e6 }));
  const revised = JSON.parse(await read('supabase/data/aee_2026_gs_questions.json'));
  assert.equal(revised.length, 150);
  for (const row of revised) {
    const old = oldBank.find(item => item.number === row.number);
    assert.equal(row.question_text, old.question_text);
    assert.equal(row.correct_answer, old.correct_answer);
    assert.equal(row.options.find(o => o.value === row.correct_answer).text, old.options.find(o => o.value === old.correct_answer).text);
    assert.equal(new Set(row.options.map(o => o.text)).size, 4);
  }
  await db.exec(oldSeed);
  const test = (await db.query("SELECT id FROM mock_tests WHERE title='TGPSC AEE 2026 - General Studies Full Length Mock 01'")).rows[0].id;
  const before = (await db.query('SELECT id,correct_answer FROM mock_questions WHERE mock_test_id=$1 ORDER BY display_order', [test])).rows;
  const user = '00000000-0000-0000-0000-000000000001';
  await db.query('INSERT INTO auth.users VALUES($1)', [user]);
  await db.query("INSERT INTO mock_attempts(mock_test_id,student_id,status,score) VALUES($1,$2,'submitted',100)", [test,user]);
  const migration = await read('supabase/seeds/tgpsc_aee_2026_gs_distractor_revision.sql');
  await assert.rejects(() => db.exec(migration), /preserve history/);
  await db.exec('ROLLBACK');
  assert.equal((await db.query('SELECT score FROM mock_attempts')).rows[0].score, '100.00');
  // Only remove synthetic test data in this isolated in-memory database.
  await db.exec('DELETE FROM mock_attempts');
  await db.exec(migration); await db.exec(migration);
  const after = (await db.query('SELECT id,correct_answer FROM mock_questions WHERE mock_test_id=$1 ORDER BY display_order', [test])).rows;
  assert.deepEqual(after, before);
  const q = (await db.query('SELECT options FROM mock_questions WHERE mock_test_id=$1 AND display_order=1', [test])).rows[0];
  assert.ok(!JSON.stringify(q).includes('Portuguese'));
  await db.exec(await read('supabase/seeds/tgpsc_aee_2026_matching_revision.sql'));
  await db.exec(migration);
  assert.equal((await db.query("SELECT count(*)::int n FROM mock_questions WHERE mock_test_id=$1 AND question_text LIKE '%Match List I%'", [test])).rows[0].n, 3);
  console.log('PASS: 150 items, original keys/correct text/IDs, plausible-option uniqueness, upgrade, rerun, matching compatibility, attempted-test refusal and preserved score.');
} catch (error) { console.error(error.message); process.exitCode = 1; }
finally { await db.close(); }
