import fs from 'node:fs/promises';
import assert from 'node:assert/strict';
import { PGlite } from '../tmp/gate2025/runtime/node_modules/@electric-sql/pglite/dist/index.js';
const db = new PGlite();
const ids = [1,2,3].map(n => `00000000-0000-0000-0000-00000000000${n}`);
async function as(id) { await db.query("SELECT set_config('request.user_id',$1,false)",[id]); }
async function rpc(sql,args=[]) { return (await db.query(`SELECT ${sql} AS data`,args)).rows[0].data; }
try {
 await db.exec(`CREATE ROLE anon; CREATE ROLE authenticated; CREATE SCHEMA auth;
 CREATE TABLE auth.users(id UUID PRIMARY KEY,raw_user_meta_data JSONB DEFAULT '{}');
 CREATE FUNCTION auth.uid() RETURNS UUID LANGUAGE sql AS $$ SELECT nullif(current_setting('request.user_id',true),'')::uuid $$;
 CREATE TABLE public.community_posts(id UUID PRIMARY KEY,student_id UUID,content TEXT,created_at TIMESTAMPTZ DEFAULT now());`);
 for(const id of ids) await db.query('INSERT INTO auth.users(id) VALUES($1)',[id]);
 await db.query("INSERT INTO community_posts VALUES(gen_random_uuid(),$1,'Existing post',now())",[ids[0]]);
 await db.exec(await fs.readFile('supabase/community_quizzes.sql','utf8'));
 await as(ids[0]);
 const question={text:'Test',options:['a','b','c','d'],correct:'0'};
 await rpc('publish_community_quiz($1,$2,$3)',['Existing quiz','Topic',JSON.stringify([question])]);
 const migration=await fs.readFile('supabase/social_feed.sql','utf8');
 await db.exec(migration);await db.exec(migration);
 await db.exec('SET ROLE authenticated');
 assert.equal((await rpc('social_feed()')).length,2,'imports legacy posts and existing quizzes once');
 for (const id of ids) { await as(id); await rpc('social_post($1)',[`Post by ${id}`]); }
 await as(ids[0]);
 assert.equal((await rpc('social_feed()')).length,3,'own content only before following');
 await rpc('social_follow($1,true)',[ids[1]]);
 await rpc('social_follow($1,true)',[ids[1]]);
 let feed=await rpc('social_feed()');
 assert.equal(feed.length,4);assert.ok(feed.every(row=>[ids[0],ids[1]].includes(row.author_id)));
 assert.equal(feed.find(row=>row.kind==='quiz').questions,undefined);
 assert.equal((await rpc('social_profile($1)',[ids[1]])).followers,1);
 assert.equal((await rpc('social_feed($1,0)',[ids[2]])).length,1,'public profile wall');
 await rpc('social_follow($1,false)',[ids[1]]);
 assert.equal((await rpc('social_feed()')).length,3);
 await assert.rejects(()=>rpc('social_follow($1,true)',[ids[0]]),/yourself/);
 await rpc('social_update_profile($1,$2,$3)',['Alice','Civil student','Learning daily']);
 assert.equal((await rpc('social_profile($1)',[ids[0]])).display_name,'Alice');
 assert.equal((await rpc('social_profile($1)',[ids[1]])).display_name,'Student','cannot edit other profiles');
 assert.equal((await rpc('social_feed(null,100)')).length,0);
 await assert.rejects(()=>db.query('SELECT * FROM member_posts'),/permission denied/);
 await as('');await assert.rejects(()=>rpc('social_feed()'),/Sign in/);
 console.log('PASS: migration reruns, existing posts/quizzes, own/following filtering, unfollow, self-follow prevention, profile editing, pagination and access checks.');
} finally {await db.close();}
