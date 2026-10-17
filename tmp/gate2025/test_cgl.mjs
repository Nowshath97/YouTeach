process.on('uncaughtException', e => { console.error(e.message, e.where || ''); process.exit(1); });
import fs from 'node:fs/promises';
import assert from 'node:assert/strict';
import { PGlite } from './runtime/node_modules/@electric-sql/pglite/dist/index.js';
const db=new PGlite();
await db.exec('CREATE ROLE anon; CREATE ROLE authenticated; CREATE SCHEMA auth; CREATE TABLE auth.users(id UUID PRIMARY KEY); CREATE FUNCTION auth.uid() RETURNS UUID LANGUAGE sql AS $$ SELECT NULL::UUID $$;');
await db.exec((await fs.readFile('supabase/mock_test_setup.sql','utf8')).replace(/^\uFEFF/, ''));
const seed=await fs.readFile('supabase/ssc_cgl_2025_09_12_shift_2_mock_seed.sql','utf8');
await db.exec(seed); await db.exec(seed);
const t=(await db.query('SELECT * FROM mock_tests')).rows;
assert.equal(t.length,1); assert.equal(t[0].is_published,true); assert.equal(t[0].duration_minutes,60);
const stats=(await db.query('SELECT count(*)::int n, count(distinct display_order)::int ordered, sum(marks)::int marks FROM mock_questions')).rows[0];
assert.deepEqual(stats,{n:100,ordered:100,marks:200});
await db.exec("UPDATE mock_questions SET correct_answer='Z' WHERE display_order=1");
await assert.rejects(()=>db.exec(seed),/refusing to overwrite/);
assert.equal((await db.query('SELECT correct_answer FROM mock_questions WHERE display_order=1')).rows[0].correct_answer,'Z');
console.log('PASS: draft import, 100 ordered questions, 200 marks, idempotency, conflict protection.');
await db.close();

