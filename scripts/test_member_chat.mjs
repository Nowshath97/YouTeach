import fs from 'node:fs/promises';
import assert from 'node:assert/strict';
import { PGlite } from '../tmp/gate2025/runtime/node_modules/@electric-sql/pglite/dist/index.js';
const db = new PGlite();
const ids=[1,2,3].map(n=>`00000000-0000-0000-0000-00000000000${n}`);
async function as(id) {await db.query("SELECT set_config('request.user_id',$1,false)",[id]);}
async function rpc(sql,args=[]) {return (await db.query('SELECT '+sql+' AS data',args)).rows[0].data;}
try {
 await db.exec(`CREATE ROLE anon; CREATE ROLE authenticated; CREATE SCHEMA auth;
 CREATE TABLE auth.users(id UUID PRIMARY KEY,raw_user_meta_data JSONB DEFAULT '{}');
 CREATE FUNCTION auth.uid() RETURNS UUID LANGUAGE sql AS $$ SELECT nullif(current_setting('request.user_id',true),'')::uuid $$;`);
 for(const id of ids) await db.query('INSERT INTO auth.users(id) VALUES($1)',[id]);
 for(const name of ['community_quizzes','social_feed','member_chat','member_chat']) await db.exec(await fs.readFile(`supabase/${name}.sql`,'utf8'));
 await db.exec('SET ROLE authenticated');await as(ids[0]);
 await assert.rejects(()=>rpc('chat_send($1,$2)',[ids[1],'Hello']),/followers/);
 await rpc('social_follow($1,true)',[ids[1]]);
 assert.equal((await rpc('chat_contacts()')).length,1);
 await rpc('chat_send($1,$2)',[ids[1],'Private message']);
 await as(ids[1]);
 assert.equal((await rpc('chat_contacts()'))[0].can_message,true);
 assert.equal((await rpc('chat_messages($1)',[ids[0]]))[0].body,'Private message');
 await rpc('chat_send($1,$2)',[ids[0],'Reply']);
 await assert.rejects(()=>rpc('chat_send($1,$2)',[ids[0],'   ']));
 await assert.rejects(()=>rpc('chat_send($1,$2)',[ids[1],'Self']),/followers/);
 await as(ids[2]);
 assert.equal((await rpc('chat_contacts()')).length,0);
 assert.equal((await rpc('chat_messages($1)',[ids[0]])).length,0,'third party cannot read other conversations');
 await assert.rejects(()=>db.query('SELECT * FROM member_messages'),/permission denied/);
 await as(ids[0]);await rpc('social_follow($1,false)',[ids[1]]);
 assert.equal((await rpc('chat_messages($1)',[ids[1]])).length,2,'previous messages retained');
 assert.equal((await rpc('chat_contacts()'))[0].can_message,false);
 await assert.rejects(()=>rpc('chat_send($1,$2)',[ids[1],'No longer connected']),/followers/);
 await as('');await assert.rejects(()=>rpc('chat_contacts()'),/Sign in/);
 console.log('PASS: migration reruns, follower chat, replies, persistence, third-party privacy, empty/self-message rejection and authentication.');
} finally {await db.close();}
