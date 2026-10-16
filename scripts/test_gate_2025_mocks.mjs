// Install the temporary engine: npm install --no-save --package-lock=false --prefix tmp/gate2025/runtime @electric-sql/pglite
// Run from repository root: node scripts/test_gate_2025_mocks.mjs
process.on('uncaughtException', e => { console.error(e.message, e.detail || '', e.where || ''); process.exit(1); });
import fs from 'node:fs/promises';
import assert from 'node:assert/strict';
import { PGlite } from '../tmp/gate2025/runtime/node_modules/@electric-sql/pglite/dist/index.js';
const db = new PGlite();
const read = async path => (await fs.readFile(path, 'utf8')).replace(/^\uFEFF/, '');
await db.exec(`CREATE ROLE anon; CREATE ROLE authenticated; CREATE SCHEMA auth;
CREATE TABLE auth.users(id UUID PRIMARY KEY);
CREATE FUNCTION auth.uid() RETURNS UUID LANGUAGE sql STABLE AS $$ SELECT nullif(current_setting('test.user_id',true),'')::UUID $$;`);
await db.exec(await read('supabase/mock_test_setup.sql'));
await db.exec(await read('supabase/mock_simulation_functions.sql'));
await db.exec(await read('supabase/gate_2025_grading.sql'));
const seed = await read('supabase/gate_2025_previous_year_mock_seed.sql');
await db.exec(seed);
await db.exec(seed);
assert.equal((await db.query('SELECT count(*)::int AS n FROM public.mock_tests')).rows[0].n, 3);
assert.equal((await db.query('SELECT count(*)::int AS n FROM public.mock_questions')).rows[0].n, 195);
const papers = JSON.parse(await read('supabase/data/gate_2025_official_papers.json'));
let assertions = 0;
const grade = async (key, value, type, marks=1, penalty=.25) => (await db.query('SELECT public.evaluate_mock_response($1,$2,$3,$4,$5) AS g',[key,value,type,marks,penalty])).rows[0].g;
for (const paper of papers) for (const q of paper.questions) {
  const key = 'GATE2025:'+JSON.stringify(q.key);
  const type = q.response_type === 'NAT' ? 'numerical':'mcq';
  if (q.response_type === 'NAT') {
    for (const [lo,hi] of q.key.ranges) for (const v of [lo,hi,(lo+hi)/2]) {
      const g = await grade(key,String(v),type,q.marks);
      assert.equal(g.is_correct,true,`${paper.code} Q${q.number} ${v}`); assert.equal(g.marks_awarded,q.marks); assertions++;
    }
    const low = Math.min(...q.key.ranges.map(r=>r[0]));
    for (const v of [String(low-1),'NaN','Infinity','not a number']) {
      const g=await grade(key,v,type,q.marks); assert.equal(g.is_correct,false); assert.equal(g.marks_awarded,0); assertions++;
    }
    if(q.key.ranges.length>1){ const g=await grade(key,String((q.key.ranges[0][1]+q.key.ranges[1][0])/2),type,q.marks); assert.equal(g.is_correct,false); assertions++; }
  } else {
    const g=await grade(key,[...q.key.answers].reverse().join(';'),type,q.marks);
    assert.equal(g.is_correct,true); assert.equal(g.marks_awarded,q.marks); assertions++;
    const bad = q.response_type==='MCQ' ? ['A','B','C','D'].find(x=>!q.key.answers.includes(x)) : q.key.answers.length>1 ? q.key.answers.slice(1).join(';') : q.key.answers.concat(['A','B','C','D'].find(x=>!q.key.answers.includes(x))).join(';');
    const wrong=await grade(key,bad,type,q.marks);
    assert.equal(wrong.is_correct,false); assert.ok(Math.abs(wrong.marks_awarded-(q.response_type==='MCQ' ? -q.marks/3:0))<1e-12); assertions++;
  }
}
assert.equal((await grade('B','B','mcq')).marks_awarded,1);
assert.equal((await grade('B','C','mcq')).marks_awarded,-.25);
assert.equal((await grade('1.0','1','numerical')).is_correct,true);
const user='11111111-1111-4111-8111-111111111111';
await db.query('INSERT INTO auth.users VALUES ($1)',[user]);
await db.exec(`SET test.user_id='${user}'`);
const tests=(await db.query('SELECT id,title FROM public.mock_tests ORDER BY title')).rows;
for(const test of tests){
 const questions=(await db.query('SELECT * FROM public.mock_questions WHERE mock_test_id=$1 ORDER BY display_order',[test.id])).rows;
 const start=(await db.query('SELECT public.start_mock_attempt($1) AS a',[test.id])).rows[0].a;
 assert.equal(start.questions.length,65); assert.equal(start.duration_minutes,180);
 assert.ok(start.questions.every(q=>!('correct_answer' in q)));
 const answers=questions.map(q=>{const k=JSON.parse(q.correct_answer.slice(9));return {question_id:q.id,selected_answer:k.kind==='NAT'?String(k.ranges[0][0]):k.answers.join(';')};});
 const result=(await db.query('SELECT public.submit_mock_attempt($1,$2) AS r',[start.attempt_id,JSON.stringify(answers)])).rows[0].r;
 assert.equal(result.score,100); assert.equal(result.correct_answers,65); assert.equal(result.incorrect_answers,0);
 await assert.rejects(()=>db.query('SELECT public.submit_mock_attempt($1,$2)',[start.attempt_id,'[]']),/not active/);
}
const started=(await db.query('SELECT public.start_mock_attempt($1) AS a',[tests[0].id])).rows[0].a;
const three=(await db.query(`SELECT id FROM public.mock_questions WHERE mock_test_id=$1 AND marks=1 AND correct_answer LIKE '%"kind":"MCQ"%' ORDER BY display_order LIMIT 3`,[tests[0].id])).rows;
const wrongAnswers=[];
for(const q of three){const row=(await db.query('SELECT correct_answer FROM public.mock_questions WHERE id=$1',[q.id])).rows[0]; const correct=JSON.parse(row.correct_answer.slice(9)).answers[0];wrongAnswers.push({question_id:q.id,selected_answer:correct==='A'?'B':'A'});}
assert.equal(wrongAnswers.length,3);
const penalty=(await db.query('SELECT public.submit_mock_attempt($1,$2) AS r',[started.attempt_id,JSON.stringify(wrongAnswers)])).rows[0].r;
assert.equal(penalty.score,-1);
const fresh=(await db.query('SELECT public.start_mock_attempt($1) AS a',[tests[0].id])).rows[0].a;
await assert.rejects(()=>db.query('SELECT public.submit_mock_attempt($1,$2)',[fresh.attempt_id,JSON.stringify([wrongAnswers[0],wrongAnswers[0]])]),/only once/);
await db.exec(seed);
assert.equal((await db.query('SELECT count(*)::int AS n FROM public.mock_attempt_answers')).rows[0].n,198);
await db.exec('SET ROLE authenticated');
await assert.rejects(()=>db.query('SELECT correct_answer FROM public.mock_questions LIMIT 1'),/permission denied/);
await assert.rejects(()=>grade('A','A','mcq'),/permission denied/);
await db.exec('RESET ROLE');
console.log(`Passed: ${assertions} key/range cases, 3 full-paper submissions, exact one-third penalties, duplicate protection, private-key access, and seed reruns preserving attempts.`);
await db.close();
