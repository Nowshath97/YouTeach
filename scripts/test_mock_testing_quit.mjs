import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import { PGlite } from '../tmp/gate2025/runtime/node_modules/@electric-sql/pglite/dist/index.js';
const db=new PGlite();
const read=async p=>(await fs.readFile(p,'utf8')).replace(/^\uFEFF/,'');
try {
 await db.exec(`CREATE ROLE anon; CREATE ROLE authenticated; CREATE SCHEMA auth;
 CREATE TABLE auth.users(id uuid PRIMARY KEY,email text);
 CREATE FUNCTION auth.uid() RETURNS uuid LANGUAGE sql AS $$ SELECT nullif(current_setting('request.user_id',true),'')::uuid $$;`);
 await db.exec(await read('supabase/mock_test_setup.sql'));
 await db.exec(await read('supabase/mock_testing_quit.sql'));
 await db.exec(await read('supabase/mock_testing_quit.sql'));
 const tester='00000000-0000-0000-0000-000000000001',other='00000000-0000-0000-0000-000000000002';
 await db.query("INSERT INTO auth.users VALUES($1,'testnaushad@gmail.com'),($2,'student@example.com')",[tester,other]);
 const test=(await db.query("INSERT INTO mock_tests(title,duration_minutes,total_marks) VALUES('Test',150,150) RETURNING id")).rows[0].id;
 const question=(await db.query("INSERT INTO mock_questions(mock_test_id,question_text,correct_answer) VALUES($1,'Q','A') RETURNING id",[test])).rows[0].id;
 const a=(await db.query("INSERT INTO mock_attempts(mock_test_id,student_id,status) VALUES($1,$2,'in_progress'),($1,$2,'in_progress'),($1,$2,'submitted'),($1,$2,'expired'),($1,$3,'in_progress') RETURNING id",[test,tester,other])).rows;
 await db.query("INSERT INTO mock_attempt_answers(attempt_id,mock_test_id,question_id,selected_answer,is_correct,marks_awarded) VALUES($1,$2,$3,'A',true,1)",[a[0].id,test,question]);
 const as=async id=>{await db.exec('SET ROLE authenticated');await db.query("SELECT set_config('request.user_id',$1,false)",[id]);};
 const quit=()=>db.query('SELECT quit_testing_mock_attempts() AS result');
 await as(other);await assert.rejects(quit,/designated testing account/);
 await as('');await assert.rejects(quit,/Sign in/);
 await db.exec('RESET ROLE; SET ROLE anon');await assert.rejects(quit,/permission denied/);
 await db.exec('RESET ROLE');await as(tester);
 assert.equal((await quit()).rows[0].result.deleted_count,2);
 assert.equal((await quit()).rows[0].result.deleted_count,0);
 await db.exec('RESET ROLE');
 assert.equal((await db.query('SELECT count(*)::int n FROM mock_attempt_answers')).rows[0].n,0);
 assert.equal((await db.query('SELECT count(*)::int n FROM mock_attempts')).rows[0].n,3);
 assert.equal((await db.query("SELECT count(*)::int n FROM mock_attempts WHERE student_id=$1 AND status='in_progress'",[other])).rows[0].n,1);
 console.log('PASS: tester-only cleanup, all active rows removed, answer cascade, other account/history preserved, repeat call and migration, anonymous denial.');
} catch(e){console.error(e.message);process.exitCode=1;}
finally{await db.close();}
