import fs from 'node:fs/promises';
import assert from 'node:assert/strict';
import { PGlite } from '../tmp/gate2025/runtime/node_modules/@electric-sql/pglite/dist/index.js';
const db = new PGlite();
try {
  await db.exec(`CREATE ROLE anon; CREATE ROLE authenticated; CREATE SCHEMA auth;
    CREATE FUNCTION auth.uid() RETURNS uuid LANGUAGE sql AS $$ SELECT nullif(current_setting('request.user_id',true),'')::uuid $$;
    CREATE TABLE member_profiles(id uuid PRIMARY KEY, display_name text, headline text);
    CREATE TABLE member_follows(follower_id uuid,following_id uuid);`);
  for (const name of ['member_chat', 'member_chat_notifications', 'member_chat_notifications'])
    await db.exec(await fs.readFile(`supabase/${name}.sql`, 'utf8'));
  const a = '00000000-0000-0000-0000-000000000001';
  const b = '00000000-0000-0000-0000-000000000002';
  await db.query("INSERT INTO member_profiles VALUES($1,'Alice',''),($2,'Bob','')", [a,b]);
  await db.query('INSERT INTO member_follows VALUES($1,$2)', [a,b]);
  const as = async id => { await db.exec('SET ROLE authenticated'); await db.query("SELECT set_config('request.user_id',$1,false)", [id]); };
  const inbox = async () => (await db.query('SELECT chat_inbox() AS data')).rows[0].data;
  await as(a);
  const message = (await db.query("SELECT chat_send($1,'Hello Bob') AS data", [b])).rows[0].data;
  assert.deepEqual(await inbox(), []);
  await as(b);
  assert.equal((await inbox())[0].unread_count, 1);
  assert.equal((await inbox())[0].body, 'Hello Bob');
  // Sender cannot clear the recipient's unread status.
  await as(a); await db.query('SELECT chat_mark_read($1::uuid[])', [[message.id]]);
  await as(b); assert.equal((await inbox())[0].unread_count, 1);
  // Loading messages alone must not acknowledge them in a hidden tab.
  await db.query('SELECT chat_messages($1)', [a]);
  assert.equal((await inbox())[0].unread_count, 1);
  const newer = await (async () => { await as(a); return (await db.query("SELECT chat_send($1,'Another message') AS data", [b])).rows[0].data; })();
  await as(b); await db.query('SELECT chat_mark_read($1::uuid[])', [[message.id]]);
  assert.equal((await inbox())[0].unread_count, 1);
  await db.query('SELECT chat_mark_read($1::uuid[])', [[newer.id]]);
  assert.deepEqual(await inbox(), []);
  await as(''); await assert.rejects(inbox, /Sign in/);
  await db.exec('RESET ROLE; SET ROLE anon');
  await assert.rejects(inbox, /permission denied/);
  console.log('PASS: unread counts, previews, recipient-only acknowledgment, concurrent arrivals, migration rerun, authentication.');
} finally { await db.close(); }
