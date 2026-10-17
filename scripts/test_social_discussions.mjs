import fs from 'node:fs/promises';
import assert from 'node:assert/strict';
import { PGlite } from '../tmp/gate2025/runtime/node_modules/@electric-sql/pglite/dist/index.js';
const db = new PGlite();
const a='00000000-0000-0000-0000-000000000001', b='00000000-0000-0000-0000-000000000002';
async function rpc(sql,args=[]) {return (await db.query('SELECT '+sql+' AS data',args)).rows[0].data;}
async function user(id) {await db.query("SELECT set_config('request.user_id',$1,false)",[id]);}
try {
 await db.exec(`CREATE ROLE anon; CREATE ROLE authenticated; CREATE SCHEMA auth; CREATE SCHEMA storage;
 CREATE TABLE auth.users(id UUID PRIMARY KEY,raw_user_meta_data JSONB DEFAULT '{}');
 CREATE FUNCTION auth.uid() RETURNS UUID LANGUAGE sql AS $$ SELECT nullif(current_setting('request.user_id',true),'')::uuid $$;
 CREATE TABLE storage.buckets(id TEXT PRIMARY KEY,name TEXT,public BOOLEAN,file_size_limit BIGINT,allowed_mime_types TEXT[]);
 CREATE TABLE storage.objects(id UUID DEFAULT gen_random_uuid(),bucket_id TEXT,name TEXT);
 ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;
 CREATE FUNCTION storage.foldername(TEXT) RETURNS TEXT[] LANGUAGE sql AS $$ SELECT string_to_array($1,'/') $$;`);
 for (const id of [a,b]) await db.query('INSERT INTO auth.users(id) VALUES($1)',[id]);
 for (const name of ['community_quizzes','social_feed','social_discussions','social_discussions']) await db.exec(await fs.readFile(`supabase/${name}.sql`,'utf8'));
 await user(a);
 const post=await rpc('social_post($1)',['Discuss']);
 const other=await rpc('social_post($1)',['Another post']);
 await db.query("INSERT INTO storage.objects(bucket_id,name) VALUES('solution-images',$1)",[a+'/solution.png']);
 await db.exec('SET ROLE authenticated');
 await rpc('social_like($1,$2,true)',['post',post]);await rpc('social_like($1,$2,true)',['post',post]);
 assert.equal((await rpc('social_interactions($1,$2)',['post',post])).likes,1);
 const root=await rpc('social_comment($1,$2,$3,null,$4)',['post',post,'My solution',a+'/solution.png']);
 const reply=await rpc('social_comment($1,$2,$3,$4,null)',['post',post,'Thanks',root.id]);
 assert.equal(reply.parent_id,root.id);
 await assert.rejects(()=>rpc('social_comment($1,$2,$3,$4,null)',['post',other,'Wrong thread',root.id]),/Reply must belong/);
 await assert.rejects(()=>rpc('social_comment($1,$2,$3,$4,null)',['post',post,'Nested reply',reply.id]),/Reply must belong/);
 await assert.rejects(()=>rpc('social_comment($1,$2,$3,null,null)',['post',post,'']),/Add a comment/);
 await assert.rejects(()=>db.query('SELECT * FROM member_comments'),/permission denied/);
 await user(b);
 await assert.rejects(()=>rpc('social_comment($1,$2,$3,null,$4)',['post',post,'Stolen image',a+'/solution.png']),/Upload your solution/);
 await rpc('social_like($1,$2,true)',['post',post]);
 assert.equal((await rpc('social_interactions($1,$2)',['post',post])).likes,2);
 assert.equal((await rpc('social_comments($1,$2,0)',['post',post])).length,2);
 await rpc('social_like($1,$2,false)',['post',post]);
 assert.equal((await rpc('social_interactions($1,$2)',['post',post])).likes,1);
 await user('');await assert.rejects(()=>rpc('social_interactions($1,$2)',['post',post]),/Sign in/);
 console.log('PASS: migration reruns, unique likes, unlike, threads, image ownership, validation, private tables and authentication. Storage policies compiled against a local Storage schema stub.');
} finally {await db.close();}
