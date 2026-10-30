import { createServer } from 'node:http';
import { existsSync } from 'node:fs';
import { handleAskAi } from './askAi.mjs';

if (existsSync('.env')) process.loadEnvFile('.env');

const port = Number(process.env.API_PORT || 8787);
// Only needed if the frontend is served from a different origin than this API (the Vite dev proxy makes it same-origin).
const allowedOrigin = process.env.ALLOWED_ORIGIN;

const server = createServer((req, res) => {
  if (allowedOrigin) {
    res.setHeader('Access-Control-Allow-Origin', allowedOrigin);
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
    res.setHeader('Vary', 'Origin');
  }
  const path = (req.url || '').split('?')[0];
  if (req.method === 'OPTIONS') { res.writeHead(204); return res.end(); }
  if (path === '/api/health') { res.writeHead(200, { 'Content-Type': 'application/json' }); return res.end('{"ok":true}'); }
  if (path === '/api/ask-ai') {
    if (req.method !== 'POST') { res.writeHead(405, { Allow: 'POST', 'Content-Type': 'application/json' }); return res.end('{"error":{"code":"method_not_allowed","message":"Use POST."}}'); }
    return handleAskAi(req, res);
  }
  res.writeHead(404, { 'Content-Type': 'application/json' });
  res.end('{"error":{"code":"not_found","message":"Not found."}}');
});

server.listen(port, () => console.log(`API listening on http://localhost:${port}${process.env.GEMINI_API_KEY ? '' : '  (GEMINI_API_KEY is not set)'}`));
