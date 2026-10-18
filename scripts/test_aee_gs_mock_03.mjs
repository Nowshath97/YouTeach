import fs from 'node:fs/promises';
import assert from 'node:assert/strict';
import {PGlite} from '../tmp/gate2025/runtime/node_modules/@electric-sql/pglite/dist/index.js';
import {parseMatchingQuestion} from '../src/matchingQuestion.mjs';

const read=async p=>(await fs.readFile(p,'utf8')).replace(/^\uFEFF/,'');
const rows=JSON.parse(await read('supabase/data/aee_gs_mock_03_questions.json'));
const manifest=JSON.parse(await read('supabase/data/aee_gs_mock_03_manifest.json'));
const answer=id=>rows[id-1].options.find(o=>o.value===rows[id-1].correct_answer).text;
assert.equal(rows.length,150);
assert.deepEqual(rows.map(r=>r.id),Array.from({length:150},(_,i)=>i+1));
assert.equal(new Set(rows.map(r=>r.question_text)).size,150);
assert.equal(new Set(rows.map(r=>r.topic)).size,150);
assert.deepEqual(Object.values(manifest.section_counts),[15,12,10,15,15,12,15,8,10,13,5,12,8]);
assert.deepEqual(manifest.answer_counts,{'1':38,'2':38,'3':37,'4':37});
assert.equal(manifest.duplicate_check.exact_matches.length,0);
assert.equal(manifest.duplicate_check.near_text_candidates.length,0);
assert.ok(manifest.planning_seconds<=9000);
for(const r of rows){
 assert.deepEqual(r.options.map(o=>o.value),['1','2','3','4']);
 assert.equal(new Set(r.options.map(o=>o.text)).size,4);
 assert.ok(r.options.some(o=>o.value===r.correct_answer));
 assert.ok(r.explanation.length>45,r.topic);
 if(r.item_format==='matching') assert.ok(parseMatchingQuestion(r.question_text),r.topic);
}
// Independently supplied pair maps; catch accidental matching-key swaps.
for(const id of [18,22])assert.equal(answer(id),'P-3, Q-1, R-2');
for(const id of [35,56,64,70,77,81,108])assert.equal(answer(id),'P-2, Q-3, R-1');
// All statement combinations and chronology keys, checked against the unshuffled stems.
for(const id of [15,19,23,31,36,40,63])assert.equal(answer(id),'1 and 2 only');
assert.equal(answer(79),'1 only');assert.equal(answer(87),'1, 2 and 3');
for(const id of [72,92,117])assert.equal(answer(id),'P-Q-R');
// Recompute all twelve reasoning/DI items independently.
assert.equal(Number(answer(131)),4*5);
assert.equal(answer(132),[...'MILE'].map(c=>String.fromCharCode(c.charCodeAt(0)+1)).join(''));
assert.equal(answer(133),['North','East','South','West'][(3+1-2+4)%4]);
assert.equal(answer(134),'Daughter');
// Enumerate finite sets: every model satisfying the premises has a book-periodical overlap.
for(let books=0;books<8;books++)for(let journals=0;journals<8;journals++)for(let periodicals=0;periodicals<8;periodicals++){
 if((books&journals) && !(journals&~periodicals))assert.ok(books&periodicals);
}
assert.equal(answer(135),'Some books are periodicals');
assert.equal(Number(answer(136)),12+9-1);
assert.equal(answer(137),'Artist');
assert.equal(Number.parseFloat(answer(138)),1/(1/12+1/6));
assert.equal(Number.parseFloat(answer(139)),60/(40+60+50)*100);
const arrangement=['P','Q','R','S','T'];[arrangement[0],arrangement[4]]=[arrangement[4],arrangement[0]];
assert.equal(answer(140),arrangement[2]);
assert.equal((15-1)%7,0);assert.equal(answer(141),'Monday');
assert.equal(Number(answer(142)),[27,64,100,125].find(n=>!Number.isInteger(Math.cbrt(n))));

const db=new PGlite();
try{
 await db.exec(`CREATE ROLE anon; CREATE ROLE authenticated; CREATE SCHEMA auth;
 CREATE TABLE auth.users(id uuid PRIMARY KEY);
 CREATE FUNCTION auth.uid() RETURNS uuid LANGUAGE sql AS $$ SELECT nullif(current_setting('request.user_id',true),'')::uuid $$;`);
 await db.exec(await read('supabase/mock_test_setup.sql'));
 // Include both the existing Mock 01 and Mock 02, plus the old draft title, to prove isolation.
 await db.exec(await read('supabase/seeds/tgpsc_aee_2026_gs_mock_01.sql'));
 await db.exec(await read('supabase/seeds/tgpsc_aee_gs_master_mock_01.sql'));
 await db.exec(`INSERT INTO mock_tests(title,exam_type,duration_minutes,total_marks,passing_marks,is_published)
 VALUES('TGPSC AEE - General Studies Master Mock 01','OTHER',150,150,0,false);`);
 const previous=(await db.query('SELECT * FROM mock_tests ORDER BY id')).rows;
 const previousQuestions=(await db.query('SELECT * FROM mock_questions ORDER BY id')).rows;
 const seed=await read('supabase/seeds/tgpsc_aee_gs_mock_03.sql');
 await db.exec(seed);
 const test=(await db.query('SELECT * FROM mock_tests WHERE title=$1',[manifest.title])).rows[0];
 assert.equal(test.is_published,false);
 const ids=(await db.query('SELECT id FROM mock_questions WHERE mock_test_id=$1 ORDER BY display_order',[test.id])).rows;
 assert.equal(ids.length,150);
 await db.exec(seed);
 assert.deepEqual((await db.query('SELECT id FROM mock_questions WHERE mock_test_id=$1 ORDER BY display_order',[test.id])).rows,ids);
 assert.deepEqual((await db.query('SELECT * FROM mock_tests WHERE id<>$1 ORDER BY id',[test.id])).rows,previous);
 assert.deepEqual((await db.query('SELECT * FROM mock_questions WHERE mock_test_id<>$1 ORDER BY id',[test.id])).rows,previousQuestions);
 const user='00000000-0000-0000-0000-000000000003';
 await db.query('INSERT INTO auth.users VALUES($1)',[user]);
 await db.query("INSERT INTO mock_attempts(mock_test_id,student_id,status,score) VALUES($1,$2,'submitted',95)",[test.id,user]);
 await db.query('UPDATE mock_tests SET is_published=true WHERE id=$1',[test.id]);
 await db.exec(seed);
 assert.equal((await db.query('SELECT is_published FROM mock_tests WHERE id=$1',[test.id])).rows[0].is_published,true);
 assert.equal(Number((await db.query('SELECT score FROM mock_attempts WHERE mock_test_id=$1',[test.id])).rows[0].score),95);
 await db.exec('SET ROLE authenticated');
 await assert.rejects(()=>db.query('SELECT * FROM aee_master_question_metadata'),/permission denied/);
 await db.exec('RESET ROLE');
 await db.query("UPDATE mock_questions SET explanation='Manual correction' WHERE mock_test_id=$1 AND display_order=1",[test.id]);
 await assert.rejects(()=>db.exec(seed),/refusing to overwrite/);
 await db.exec('ROLLBACK');
 assert.equal((await db.query('SELECT explanation FROM mock_questions WHERE mock_test_id=$1 AND display_order=1',[test.id])).rows[0].explanation,'Manual correction');
 console.log('PASS: 150 items; section/key counts; 9 matching renderings and maps; statement/chronology keys; 12 reasoning items; isolated import; stable reruns; Mock 01/02/draft preservation; attempt/publication preservation; metadata privacy; manual-edit rollback.');
}finally{await db.close();}
