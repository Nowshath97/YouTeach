import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import {PGlite} from '../tmp/gate2025/runtime/node_modules/@electric-sql/pglite/dist/index.js';
import {sscSectionTiming} from '../src/sscSectionTiming.mjs';
const read=async p=>(await fs.readFile(p,'utf8')).replace(/^\uFEFF/,'');
const attempt={test_title:'SSC CGL Tier-I Mock',duration_minutes:60,questions:Array.from({length:100},(_,i)=>({id:String(i)}))};
for(const [remaining,section,seconds] of [[3600,0,900],[2701,0,1],[2700,1,900],[1800,2,900],[900,3,900],[0,3,0]]){
 const t=sscSectionTiming(attempt,remaining);assert.equal(t.section,section);assert.equal(t.remaining,seconds);assert.equal(t.start,section*25);
}
assert.equal(sscSectionTiming({...attempt,test_title:'TGPSC AEE'},3000),null);
assert.equal(sscSectionTiming({...attempt,test_title:'SSC CGL Tier-II'},3000),null);
assert.equal(sscSectionTiming({...attempt,duration_minutes:80},3600).remaining,1200);
const db=new PGlite();
try{
 await db.exec(`CREATE ROLE anon; CREATE ROLE authenticated; CREATE SCHEMA auth;
 CREATE TABLE auth.users(id uuid PRIMARY KEY);
 CREATE FUNCTION auth.uid() RETURNS uuid LANGUAGE sql AS $$SELECT nullif(current_setting('request.user_id',true),'')::uuid$$;`);
 await db.exec(await read('supabase/mock_test_setup.sql'));
 await db.exec(await read('supabase/mock_simulation_functions.sql'));
 await db.exec(await read('supabase/mock_pause_resume.sql'));
 const migration=await read('supabase/ssc_cgl_section_timing.sql');
 await db.exec(migration);await db.exec(migration);
 const user='00000000-0000-0000-0000-000000000001';
 await db.query('INSERT INTO auth.users VALUES($1)',[user]);
 await db.query("SELECT set_config('request.user_id',$1,false)",[user]);
 const test=(await db.query("INSERT INTO mock_tests(title,exam_type,duration_minutes,total_marks,passing_marks,is_published) VALUES('SSC CGL Tier-I Test','OTHER',60,200,0,true) RETURNING id")).rows[0].id;
 await db.query("INSERT INTO mock_questions(mock_test_id,question_text,options,correct_answer,marks,negative_marks,display_order) SELECT $1,'Q'||i,'[]'::jsonb,'A',2,0.5,i FROM generate_series(1,100)i",[test]);
 const opened=(await db.query('SELECT open_mock_attempt($1) AS v',[test])).rows[0].v;
 const q=opened.questions;
 const save=async answers=>(await db.query("SELECT save_mock_attempt($1,$2,$3,'{}',false) AS v",[opened.attempt_id,opened.session_token,JSON.stringify(answers)])).rows[0].v;
 await save({[q[0].id]:'A',[q[25].id]:'A'});
 let draft=async()=>(await db.query('SELECT draft_answers FROM mock_attempts WHERE id=$1',[opened.attempt_id])).rows[0].draft_answers;
 assert.deepEqual(await draft(),{[q[0].id]:'A'});
 await db.query("UPDATE mock_attempts SET started_at=now()-interval '901 seconds' WHERE id=$1",[opened.attempt_id]);
 await save({[q[0].id]:'B',[q[25].id]:'A',[q[50].id]:'A'});
 assert.deepEqual(await draft(),{[q[0].id]:'A',[q[25].id]:'A'});
 await db.query("UPDATE mock_attempts SET paused_at=started_at+interval '901 seconds' WHERE id=$1",[opened.attempt_id]);
 const resumed=(await db.query('SELECT open_mock_attempt($1,$2,false) AS v',[test,opened.attempt_id])).rows[0].v;
 assert.ok(resumed.remaining_seconds<=2699&&resumed.remaining_seconds>=2697);
 await db.query("UPDATE mock_attempts SET started_at=now()-interval '2701 seconds',paused_duration=interval '0' WHERE id=$1",[opened.attempt_id]);
 const graded=(await db.query('SELECT submit_saved_mock_attempt($1,$2,$3) AS v',[opened.attempt_id,resumed.session_token,JSON.stringify([{question_id:q[0].id,selected_answer:'B'},{question_id:q[75].id,selected_answer:'A'},{question_id:q[50].id,selected_answer:'A'}])])).rows[0].v;
 assert.equal(Number(graded.score),6); // two frozen answers plus the final-section answer
 // Non-SSC sessions retain the original unrestricted answer behaviour.
 await db.query("UPDATE mock_tests SET title='TGPSC AEE Mock' WHERE id=$1",[test]);
 const other=(await db.query('SELECT open_mock_attempt($1) AS v',[test])).rows[0].v;
 await db.query("SELECT save_mock_attempt($1,$2,$3,'{}',false)",[other.attempt_id,other.session_token,JSON.stringify({[q[99].id]:'A'})]);
 assert.deepEqual((await db.query('SELECT draft_answers FROM mock_attempts WHERE id=$1',[other.attempt_id])).rows[0].draft_answers,{[q[99].id]:'A'});
 console.log('PASS: timer boundaries, other-exam isolation, migration reruns, future-answer rejection, past-answer freezing, pause/resume and final grading.');
}catch(e){console.error(e.message);process.exitCode=1;}finally{await db.close();}
