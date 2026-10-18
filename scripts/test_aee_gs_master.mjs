import fs from 'node:fs/promises';
import assert from 'node:assert/strict';
import { PGlite } from '../tmp/gate2025/runtime/node_modules/@electric-sql/pglite/dist/index.js';
import { parseMatchingQuestion } from '../src/matchingQuestion.mjs';

const read = async path => (await fs.readFile(path,'utf8')).replace(/^\uFEFF/,'');
const rows = JSON.parse(await read('supabase/data/aee_gs_master_01_questions.json'));
assert.equal(rows.length,150);
assert.deepEqual(rows.map(r=>r.id),Array.from({length:150},(_,i)=>i+1));
assert.equal(new Set(rows.map(r=>r.question_text)).size,150);
assert.equal(new Set(rows.map(r=>r.topic)).size,150);
assert.deepEqual([...new Set(rows.flatMap(r=>r.syllabus_units))].sort((a,b)=>a-b),Array.from({length:15},(_,i)=>i+1));
const answer = topic => {const r=rows.find(r=>r.topic===topic);assert.ok(r,topic);return r.options.find(o=>o.value===r.correct_answer).text;};
for(const row of rows) {
  assert.deepEqual(row.options.map(o=>o.value),['1','2','3','4']);
  assert.equal(new Set(row.options.map(o=>o.text)).size,4);
  assert.ok(row.options.some(o=>o.value===row.correct_answer));
  assert.ok(row.explanation.length>65);
  assert.equal(row.negative_marks,0);
  assert.ok(!/\$|TODO|TBD|placeholder/i.test(row.question_text));
  if(row.item_format==='matching') assert.ok(parseMatchingQuestion(row.question_text),row.topic);
}
assert.equal(rows.filter(r=>r.item_format==='matching').length,14);
assert.ok(rows.reduce((n,r)=>n+r.time_budget_seconds,0)<=9000);

// Independent calculations for every numerical item (including the test-cross ratio).
const numerical = {
 'Mendel test cross inference':'The tall parent is likely Tt; a 1:1 phenotype ratio is expected',
 'Energy tariff calculation':`Rs ${.750*4*30*6}`,
 'Buffer dilution interpretation':String(-Math.log10(.01*100/1000)),
 'Real growth exact calculation':`${Math.round(((572/1.04)/500-1)*100)}%`,
 'Value added three stages':`Rs ${200+(320-200)+(500-320)}`,
 'Budget deficits combined':`${1200-800-100} and ${1200-800-100-150}`,
 'Revenue deficit component':`Rs ${720-650} crore`,
 'Progressivity average versus marginal':`Progressive: average rates rise from ${40000/400000*100}% to ${120000/800000*100}%`,
 'Real wage purchasing power':`${((1-1.08/1.12)*100).toFixed(2)}% decrease`,
 'Labour force unemployment denominator':`${(60/(600+60)*100).toFixed(2)}%`,
 'Sector productivity shares':String((60/30)/(20/40)),
 'GST credit calculation':`Rs ${18000-11000}`,
 'Population density inference':(1800000/3000>2400000/6000?'B is denser although A has more people':''),
 'Demographic dividend dependency':`${(18+12)/60*100} dependants per 100 working-age people`,
 'Longitude local time direction':'11:30 a.m.',
 'Urbanisation versus urban growth':`Urban population grows, but its population share falls from ${20/80*100}% to ${24/100*100}%`,
 'Cropping intensity calculation':`${120000/80000*100}%`,
 'Sex ratio subgroup aggregation':String(Math.round((900+2200)/(1000+2000)*1000)),
 'Anti-defection merger threshold':String(90*2/3),
 'Conditional probability selection':'1/2',
 'Weighted average change':String((40*67-30*64)/10),
 'Work leak combined rates':`${Math.round(1/(1/12+1/18-1/36))} hours`,
 'Ranking overlap':String(12+19-1),
 'Data table weighted success':`${(80*.75+120*.60)/(80+120)*100}%`,
 'Direction displacement distance':`${Math.hypot(9-4,12)} km`,
 'Percentage base reversal':`${(100-80)/80*100}%`,
 'Number series second differences':String(48+17+4),
};
for(const row of rows.filter(r=>r.item_format==='numerical')) {
  assert.equal(answer(row.topic),numerical[row.topic],row.topic);
}
// Explicit fact mappings, independent of the shuffled option positions.
const matches={
 'NISAR radar attribution':'P-4, Q-1, R-2, S-3',
 'UN observance year matching':'P-3, Q-1, R-2, S-4',
 'Paris 2024 Indian medal record':'P-3, Q-4, R-1, S-2',
 'Vaccine and passive immunity':'P-3, Q-1, R-4, S-2',
 'Disaster intervention phases':'P-3, Q-4, R-1, S-2',
 'River tributary classification':'P-1, Q-2, R-3, S-4',
 'Land settlement liability':'P-2, Q-3, R-1',
 'Writ remedy institutions':'P-3, Q-4, R-1, S-2',
 'Local self government schedules':'P-3, Q-4, R-1, S-2',
 'Craft technique discrimination':'P-3, Q-1, R-4, S-2',
 'Literary author attribution':'P-3, Q-4, R-1, S-2',
 '2011 mobilisation forms':'P-2, Q-3, R-1',
 'Mission programme distinctions':'P-3, Q-2, R-4, S-1',
 'Antonym matching contextual':'P-2, Q-1, R-4, S-3'
};
for(const row of rows.filter(r=>r.item_format==='matching')) assert.equal(answer(row.topic),matches[row.topic],row.topic);
for(const row of rows.filter(r=>r.item_format==='statements')) {
  const truth = row.topic==='WTO accession stages'||row.topic==='Women reservation enactment mechanism'||row.topic==='Doping charge neutrality'||row.topic==='Watershed and aquifer boundaries'||row.topic==='1935 Act implemented versus proposed'?[1,3]
    :row.topic==='Ozone chemistry causal distinction'?[1,2,3]
    :row.topic==='ECI appointment and removal safeguards'?[1,2,4]
    :row.topic==='1948 administration distinction'?[1]:[1,2];
  const expected=row.statement_original_order.map((old,i)=>truth.includes(old)?i+1:null).filter(Boolean);
  assert.deepEqual(answer(row.topic).match(/\d+/g).map(Number),expected,row.topic);
}
const permutations = items => items.length===0?[[]]:items.flatMap((x,i)=>permutations(items.filter((_,j)=>j!==i)).map(t=>[x,...t]));
const seats=permutations(['Q','R','S']).map(m=>['P',...m,'T']).filter(s=>s.indexOf('Q')<s.indexOf('R')&&s[1]!=='S');
assert.ok(seats.every(s=>s[1]==='Q'));
assert.equal(answer('Seating constrained order'),'Q');
assert.deepEqual(Array.from({length:19},(_,i)=>i+1).filter(n=>n%6===0&&n%5===2),[12]);

const db = new PGlite();
try {
  await db.exec(`CREATE ROLE anon; CREATE ROLE authenticated; CREATE SCHEMA auth;
    CREATE TABLE auth.users(id uuid PRIMARY KEY);
    CREATE FUNCTION auth.uid() RETURNS uuid LANGUAGE sql AS $$ SELECT nullif(current_setting('request.user_id',true),'')::uuid $$;`);
  await db.exec(await read('supabase/mock_test_setup.sql'));
  await db.exec(await read('supabase/seeds/tgpsc_aee_2026_gs_mock_01.sql'));
  const existing=(await db.query('SELECT id,question_text,options,correct_answer FROM mock_questions ORDER BY id')).rows;
  const seed=await read('supabase/seeds/tgpsc_aee_gs_master_mock_01.sql');
  await db.exec(seed);await db.exec(seed);
  const test=(await db.query("SELECT * FROM mock_tests WHERE title='TGPSC AEE 2026 - General Studies Full Length Mock 02'")).rows[0];
  assert.equal(test.is_published,false);assert.equal(test.duration_minutes,150);assert.equal(Number(test.total_marks),150);
  assert.equal((await db.query('SELECT count(*)::int n FROM mock_questions WHERE mock_test_id=$1',[test.id])).rows[0].n,150);
  assert.equal((await db.query('SELECT count(*)::int n FROM aee_master_question_metadata')).rows[0].n,150);
  assert.deepEqual((await db.query('SELECT id,question_text,options,correct_answer FROM mock_questions WHERE mock_test_id<>$1 ORDER BY id',[test.id])).rows,existing);
  const user='00000000-0000-0000-0000-000000000001';
  await db.query('INSERT INTO auth.users VALUES($1)',[user]);
  await db.query("INSERT INTO mock_attempts(mock_test_id,student_id,status,score) VALUES($1,$2,'submitted',105)",[test.id,user]);
  await db.query('UPDATE mock_tests SET is_published=true WHERE id=$1',[test.id]);
  await db.query("UPDATE mock_tests SET title='TGPSC AEE - General Studies Master Mock 01' WHERE id=$1",[test.id]);
  await db.exec(seed);
  assert.equal((await db.query('SELECT title FROM mock_tests WHERE id=$1',[test.id])).rows[0].title,'TGPSC AEE 2026 - General Studies Full Length Mock 02');
  assert.equal((await db.query('SELECT is_published FROM mock_tests WHERE id=$1',[test.id])).rows[0].is_published,true);
  assert.equal(Number((await db.query('SELECT score FROM mock_attempts')).rows[0].score),105);
  await db.exec('SET ROLE authenticated');
  await assert.rejects(()=>db.query('SELECT * FROM aee_master_question_metadata'),/permission denied/);
  await assert.rejects(()=>db.query('SELECT correct_answer FROM mock_questions'),/permission denied/);
  await db.exec('RESET ROLE');
  await db.query("UPDATE mock_questions SET explanation='Manually edited' WHERE mock_test_id=$1 AND display_order=1",[test.id]);
  await assert.rejects(()=>db.exec(seed),/refusing to overwrite/);
  await db.exec('ROLLBACK');
  assert.equal((await db.query('SELECT explanation FROM mock_questions WHERE mock_test_id=$1 AND display_order=1',[test.id])).rows[0].explanation,'Manually edited');
  console.log('PASS: 150 items, 15 syllabus units, 26 numerical keys, 14 matching keys/rendering, 27 statement permutations, logic, fresh import, repeat import, existing bank preservation, metadata privacy, publication/attempt preservation, conflict rollback.');
} catch(error) {console.error(error.message);process.exitCode=1;}
finally {await db.close();}
