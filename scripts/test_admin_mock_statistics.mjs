import fs from 'node:fs/promises';
import assert from 'node:assert/strict';
import {PGlite} from '../tmp/gate2025/runtime/node_modules/@electric-sql/pglite/dist/index.js';
const db=new PGlite();
const read=async p=>(await fs.readFile(p,'utf8')).replace(/^\uFEFF/,'');
try{
 await db.exec(`CREATE ROLE anon; CREATE ROLE authenticated; CREATE SCHEMA auth;
 CREATE TABLE auth.users(id uuid PRIMARY KEY,email text,raw_user_meta_data jsonb);
 CREATE FUNCTION auth.uid() RETURNS uuid LANGUAGE sql AS $$ SELECT nullif(current_setting('request.user_id',true),'')::uuid $$;`);
 await db.exec(await read('supabase/mock_test_setup.sql'));
 const migration=await read('supabase/admin_mock_statistics.sql');
 await db.exec(migration);await db.exec(migration);
 const ids=Array.from({length:4},(_,i)=>`00000000-0000-0000-0000-${String(i+1).padStart(12,'0')}`);
 for(let i=0;i<4;i++)await db.query('INSERT INTO auth.users VALUES($1,$2,$3)',[ids[i],['admin@example.com','student@example.com','other@example.com','testnaushad@gmail.com'][i],JSON.stringify({role:'admin'})]);
 await db.query("INSERT INTO app_user_roles VALUES($1,'admin')",[ids[0]]);
 const test=async(title,published)=>(await db.query("INSERT INTO mock_tests(title,exam_type,duration_minutes,total_marks,passing_marks,is_published) VALUES($1,'OTHER',60,100,0,$2) RETURNING id",[title,published])).rows[0].id;
 const a=await test('Published A',true), b=await test('Published B',true), hidden=await test('Hidden',false);
 for(const [user,t,status,score] of [[ids[1],a,'submitted',80],[ids[1],a,'submitted',60],[ids[1],a,'in_progress',0],[ids[2],b,'expired',40],[ids[0],a,'submitted',100],[ids[3],a,'submitted',100],[ids[2],hidden,'submitted',90]]){
  await db.query('INSERT INTO mock_attempts(student_id,mock_test_id,status,score) VALUES($1,$2,$3,$4)',[user,t,status,score]);
 }
 for(let i=0;i<55;i++)await db.query("INSERT INTO mock_attempts(student_id,mock_test_id,status,score) VALUES($1,$2,'submitted',50)",[ids[2],b]);
 const as=async(id)=>{await db.exec('RESET ROLE');await db.query("SELECT set_config('request.user_id',$1,false)",[id||'']);await db.exec('SET ROLE authenticated');};
 const rpc=async(sql,args=[])=>(await db.query(sql,args)).rows[0].value;
 await as(ids[1]);
 assert.equal(await rpc('SELECT get_my_app_role() AS value'),'student'); // forged metadata is ignored
 await assert.rejects(()=>db.exec("INSERT INTO app_user_roles VALUES('00000000-0000-0000-0000-000000000002','admin')"),/permission denied/);
 await assert.rejects(()=>db.exec('SELECT * FROM app_user_roles'),/permission denied/);
 for(const sql of ['SELECT admin_mock_summary()','SELECT admin_mock_attempts()'])await assert.rejects(()=>db.exec(sql),/Administrator access required/);
 const popularity=await rpc('SELECT mock_popularity() AS value');
 assert.equal(popularity.length,2);
 for(const r of popularity){assert.equal(Number(r.learners),1);assert.equal(Number(r.total_learners),2);assert.equal(Number(r.learner_percentage),50);assert.ok(!JSON.stringify(r).includes('@'));}
 await as(ids[0]);
 assert.equal(await rpc('SELECT get_my_app_role() AS value'),'admin');
 const summary=await rpc('SELECT admin_mock_summary() AS value');
 assert.equal(summary.length,3);
 const sa=summary.find(r=>r.id===a);assert.equal(Number(sa.attempts),4);assert.equal(Number(sa.learners),2);assert.equal(Number(sa.average_score),80);
 const attempts=await rpc("SELECT admin_mock_attempts($1,NULL,'student@',0) AS value",[a]);
 assert.equal(Number(attempts.total),3);assert.equal(attempts.rows.find(r=>r.status==='in_progress').score,null);
 for(const r of attempts.rows){assert.ok(!('answers' in r));assert.ok(!('draft_answers' in r));assert.ok(!('correct_answer' in r));}
 const secondPage=await rpc("SELECT admin_mock_attempts(NULL,NULL,'',1) AS value");
 assert.equal(Number(secondPage.total),61);assert.equal(secondPage.rows.length,11);
 const firstPage=await rpc("SELECT admin_mock_attempts(NULL,NULL,'',0) AS value");
 assert.equal(firstPage.rows.length,50);
 assert.ok([...firstPage.rows,...secondPage.rows].every(r=>r.email!=='testnaushad@gmail.com'));
 assert.equal(Number((await rpc("SELECT admin_mock_attempts(NULL,NULL,'testnaushad',0) AS value")).total),0);
 assert.equal(new Set([...firstPage.rows,...secondPage.rows].map(r=>r.id)).size,61);
 await assert.rejects(()=>db.exec("SELECT admin_mock_attempts(NULL,NULL,'',-1)"),/Invalid page/);
 await db.exec('RESET ROLE');
 await db.query("UPDATE app_user_roles SET role='student' WHERE user_id=$1",[ids[0]]);
 await as(ids[0]);await assert.rejects(()=>db.exec('SELECT admin_mock_summary()'),/Administrator access required/);
 await as(null);await assert.rejects(()=>db.exec('SELECT mock_popularity()'),/Sign in required/);
 await db.exec('RESET ROLE; SET ROLE anon');await assert.rejects(()=>db.exec('SELECT admin_mock_summary()'),/permission denied/);
 console.log('PASS: migration reruns; database-only roles; forged metadata rejected; admin/anonymous denial; revocation; score filters; pagination; private payloads; unique popularity denominator and testing exclusions.');
}catch(e){console.error(e.message);process.exitCode=1;}finally{await db.close();}
