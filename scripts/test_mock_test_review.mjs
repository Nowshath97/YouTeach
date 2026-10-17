import fs from 'node:fs/promises';
import assert from 'node:assert/strict';
import { PGlite } from '../tmp/gate2025/runtime/node_modules/@electric-sql/pglite/dist/index.js';
const db = new PGlite();
try {
 await db.exec(`CREATE ROLE anon; CREATE ROLE authenticated; CREATE SCHEMA auth;
 CREATE TABLE auth.users(id uuid PRIMARY KEY);
 CREATE FUNCTION auth.uid() RETURNS uuid LANGUAGE sql AS $$ SELECT nullif(current_setting('request.user_id',true),'')::uuid $$;`);
 for (const file of ['mock_test_setup','mock_test_review','mock_test_review']) await db.exec((await fs.readFile(`supabase/${file}.sql`,'utf8')).replace(/^\uFEFF/, ''));
 const owner='00000000-0000-0000-0000-000000000001', other='00000000-0000-0000-0000-000000000002';
 await db.query('INSERT INTO auth.users VALUES ($1),($2)',[owner,other]);
 const test=(await db.query("INSERT INTO mock_tests(title,exam_type,duration_minutes,total_marks) VALUES ('Review','OTHER',60,3) RETURNING id")).rows[0].id;
 const attempt=(await db.query("INSERT INTO mock_attempts(mock_test_id,student_id,status,score) VALUES($1,$2,'submitted',1) RETURNING id",[test,owner])).rows[0].id;
 const qs=(await db.query("INSERT INTO mock_questions(mock_test_id,question_text,correct_answer,display_order) VALUES($1,'Correct','A',1),($1,'Incorrect','B',2),($1,'Unanswered','C',3) RETURNING id",[test])).rows;
 for (let n=0;n<2;n++) await db.query('INSERT INTO mock_attempt_answers(attempt_id,mock_test_id,question_id,selected_answer,is_correct,marks_awarded) VALUES($1,$2,$3,$4,$5,$6)',[attempt,test,qs[n].id,'A',n===0,n===0?1:0]);
 await db.exec('SET ROLE authenticated');
 const as= id => db.query("SELECT set_config('request.user_id',$1,false)",[id]);
 const review= async()=> (await db.query('SELECT get_mock_test_review($1) AS data',[attempt])).rows[0].data;
 await as(owner); const data=await review();
 assert.equal(data.questions.length,3); assert.equal(data.questions[0].is_correct,true); assert.equal(data.questions[1].is_correct,false); assert.equal(data.questions[2].selected_answer,null); assert.equal(data.questions[1].correct_answer,'B');
 await as(other); await assert.rejects(review,/unavailable/);
 await as(''); await assert.rejects(review,/Sign in/);
 await db.exec('RESET ROLE');
 for(const status of ['in_progress','expired']) {
 await db.query('UPDATE mock_attempts SET status=$1 WHERE id=$2',[status,attempt]);
 await db.exec('SET ROLE authenticated'); await as(owner); await assert.rejects(review,/Only completed/); await db.exec('RESET ROLE');
 }
 assert.equal((await db.query('SELECT score FROM mock_attempts WHERE id=$1',[attempt])).rows[0].score,'1.00');
 await db.exec('SET ROLE anon'); await assert.rejects(review,/permission denied/);
 console.log('PASS: completed review, correct/incorrect/unanswered, ownership, authentication, in-progress/expired denial, anonymous denial, unchanged score, repeat migration.');
} catch (error) { console.error(error.message); process.exitCode=1; } finally { await db.close(); }
