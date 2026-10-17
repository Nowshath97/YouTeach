import fs from 'node:fs/promises';
import assert from 'node:assert/strict';
import { PGlite } from '../tmp/gate2025/runtime/node_modules/@electric-sql/pglite/dist/index.js';
const db = new PGlite();
const read = async name => (await fs.readFile(name,'utf8')).replace(/^\uFEFF/,'');
try {
 await db.exec(`CREATE ROLE anon; CREATE ROLE authenticated; CREATE SCHEMA auth;
 CREATE TABLE auth.users(id uuid PRIMARY KEY);
 CREATE FUNCTION auth.uid() RETURNS uuid LANGUAGE sql AS $$ SELECT nullif(current_setting('request.user_id',true),'')::uuid $$;`);
 await db.exec(await read('supabase/mock_test_setup.sql'));
 // Preserve both existing Civil banks, including every original row id and answer.
 await db.exec(await read('supabase/tgpsc_aee_civil_mock_seed.sql'));
 await db.exec(await read('supabase/aee_civil_mock_2_seed.sql'));
 const before = (await db.query('SELECT id,correct_answer FROM mock_questions ORDER BY id')).rows;
 const seeds = await Promise.all(['gs','civil'].map(k=>read(`supabase/seeds/tgpsc_aee_2026_${k}_mock_01.sql`)));
 for(const seed of seeds) { await db.exec(seed); await db.exec(seed); }
 await db.exec(await read('supabase/seeds/tgpsc_aee_civil_2026_full_mock_01.sql'));
 await db.exec(await read('supabase/seeds/tgpsc_aee_civil_2026_validation.sql'));
 const papers = (await db.query("SELECT * FROM mock_tests WHERE title LIKE 'TGPSC AEE 2026 - %' ORDER BY total_marks")).rows;
 assert.equal(papers.length,2);
 assert.deepEqual(papers.map(p=>[p.duration_minutes,Number(p.total_marks),p.is_published]),[[150,150,false],[150,300,false]]);
 assert.equal((await db.query('SELECT count(*)::int n FROM mock_questions')).rows[0].n,550);
 for(const old of before) assert.equal((await db.query('SELECT correct_answer FROM mock_questions WHERE id=$1',[old.id])).rows[0].correct_answer,old.correct_answer);
 const publish = await read('supabase/seeds/publish_tgpsc_aee_2026_mocks.sql');
 await db.exec(publish); await db.exec(publish);
 assert.equal((await db.query("SELECT count(*)::int n FROM mock_tests WHERE title LIKE 'TGPSC AEE 2026 - %' AND is_published")).rows[0].n,2);
 await db.exec(seeds[0]); await db.exec(seeds[1]);
 assert.equal((await db.query("SELECT count(*)::int n FROM mock_tests WHERE title LIKE 'TGPSC AEE 2026 - %' AND is_published")).rows[0].n,2);
 const user='00000000-0000-0000-0000-000000000001';
 await db.query('INSERT INTO auth.users VALUES($1)',[user]);
 const attempt=(await db.query("INSERT INTO mock_attempts(mock_test_id,student_id,status,score,total_questions) VALUES($1,$2,'submitted',125,150) RETURNING id",[papers[1].id,user])).rows[0].id;
 await db.exec(seeds[1]);
 assert.equal(Number((await db.query('SELECT score FROM mock_attempts WHERE id=$1',[attempt])).rows[0].score),125);
 await db.exec(await read('supabase/mock_test_review.sql'));
 await db.query("SELECT set_config('request.user_id',$1,false)",[user]);
 const review=(await db.query('SELECT get_mock_test_review($1) AS review',[attempt])).rows[0].review;
 assert.equal(review.questions.length,150);
 assert.ok(review.questions.every(q=>q.explanation?.length));
 const damaged=(await db.query('SELECT id FROM mock_questions WHERE mock_test_id=$1 LIMIT 1',[papers[1].id])).rows[0].id;
 await db.query("UPDATE mock_questions SET correct_answer='Z' WHERE id=$1",[damaged]);
 await assert.rejects(()=>db.exec(seeds[1]),/refusing to overwrite/);
 await db.exec('ROLLBACK');
 assert.equal((await db.query('SELECT correct_answer FROM mock_questions WHERE id=$1',[damaged])).rows[0].correct_answer,'Z');
 assert.equal(Number((await db.query('SELECT score FROM mock_attempts WHERE id=$1',[attempt])).rows[0].score),125);
 console.log('PASS: two separate unpublished papers, 300 new questions, 450 marks, independent timers, repeat imports, preserved 250 existing questions and submitted attempt, review explanations, conflict refusal.');
} catch(error) { console.error(error.message); process.exitCode=1; }
finally { await db.close(); }
