import fs from 'node:fs/promises';
import assert from 'node:assert/strict';
import { PGlite } from '../tmp/gate2025/runtime/node_modules/@electric-sql/pglite/dist/index.js';
const db=new PGlite();
const ids=[1,2,3].map(n=>`00000000-0000-0000-0000-00000000000${n}`);
async function as(id){await db.query("SELECT set_config('request.user_id',$1,false)",[id]);}
async function rpc(sql,args=[]){return (await db.query('SELECT '+sql+' AS data',args)).rows[0].data;}
try {
 await db.exec(`CREATE ROLE anon; CREATE ROLE authenticated; CREATE SCHEMA auth;
 CREATE TABLE auth.users(id UUID PRIMARY KEY,raw_user_meta_data JSONB DEFAULT '{}');
 CREATE FUNCTION auth.uid() RETURNS UUID LANGUAGE sql AS $$ SELECT nullif(current_setting('request.user_id',true),'')::uuid $$;`);
 for(const id of ids)await db.query('INSERT INTO auth.users(id) VALUES($1)',[id]);
 for(const name of ['community_quizzes','social_feed','social_learning_tools','social_learning_tools'])await db.exec(await fs.readFile(`supabase/${name}.sql`,'utf8'));
 await db.exec('SET ROLE authenticated');
 await as(ids[0]);const own=await rpc('social_post($1)',['Fluid mechanics notes']);
 const quiz=await rpc('publish_community_quiz($1,$2,$3)',['Hydraulics quiz','Fluid mechanics',JSON.stringify([{text:'Which?',options:['A','B','C','D'],correct:'0'}])]);
 await as(ids[1]);const peer=await rpc('social_post($1)',['Structural engineering solution']);
 await as(ids[2]);const stranger=await rpc('social_post($1)',['Unfollowed member']);
 await as(ids[0]);await rpc('social_follow($1,true)',[ids[1]]);
 const feed=(filter='following',search='')=>rpc('social_learning_feed(null,$1,$2,0)',[filter,search]);
 assert.equal((await feed()).length,3,'own and followed content only');
 assert.equal((await feed('quiz')).length,1);assert.equal((await feed('post')).length,2);
 assert.equal((await feed('following','FLUID')).length,2,'case-insensitive topic/content search');
 await rpc('social_set_feed_preference($1,$2,$3,true)',['post',peer,'save']);
 await rpc('social_set_feed_preference($1,$2,$3,true)',['post',peer,'save']);
 assert.equal((await feed('saved')).length,1,'duplicate saves are idempotent');
 await rpc('social_set_feed_preference($1,$2,$3,true)',['post',peer,'hide']);
 assert.equal((await feed()).length,2);assert.equal((await feed('hidden')).length,1);
 assert.equal((await feed('saved')).length,1,'saved copy stays accessible while hidden');
 await rpc('social_set_feed_preference($1,$2,$3,false)',['post',peer,'hide']);
 assert.equal((await feed()).length,3);assert.equal((await feed('saved'))[0].saved,true);
 await rpc('social_follow($1,false)',[ids[1]]);
 assert.equal((await feed()).length,2);assert.equal((await feed('saved')).length,1,'saved material survives unfollow');
 await as(ids[1]);assert.equal((await feed('saved')).length,0,'saves are private');
 assert.equal((await feed('hidden')).length,0,'hides are private');
 await assert.rejects(()=>db.query('SELECT * FROM member_feed_preferences'),/permission denied/);
 await as('');await assert.rejects(()=>feed(),/Sign in/);
 console.log('PASS: repeat migration, bookmarks, hide/restore, private preferences, filtering, search, follow boundaries and authentication.');
} finally {await db.close();}
