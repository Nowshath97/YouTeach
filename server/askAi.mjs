import { readFile } from 'node:fs/promises';

// ---------- config ----------
export const LIMITS = {
  bodyBytes: 32 * 1024,
  doubtChars: 1000,
  historyMessages: 10,
  historyChars: 2000,
  contextChars: 6000,
  maxOutputTokens: 1024,
  rateLimitPerMinute: 10,
  geminiTimeoutMs: 20000,
};
export const EXAM_TYPES = ['UPSC', 'GATE', 'SSC_CGL', 'TGPSC_AEE'];
const EXAM_LABEL = { UPSC: 'UPSC Civil Services', GATE: 'GATE', SSC_CGL: 'SSC CGL', TGPSC_AEE: 'TGPSC Assistant Executive Engineer (Civil)' };

export class ApiError extends Error {
  constructor(status, code, message) { super(message); this.status = status; this.code = code; }
}

const env = () => ({
  geminiKey: process.env.GEMINI_API_KEY,
  model: process.env.GEMINI_MODEL || 'gemini-3.5-flash',
  fallbackModel: process.env.GEMINI_FALLBACK_MODEL || 'gemini-3.5-flash-lite',
  supabaseUrl: (process.env.SUPABASE_URL || process.env.VITE_SUPABASE_URL || '').replace(/\/$/, ''),
  supabaseKey: process.env.SUPABASE_ANON_KEY || process.env.VITE_SUPABASE_ANON_KEY || '',
  requireAuth: process.env.ASK_AI_REQUIRE_AUTH !== 'false',
});

// ---------- request validation ----------
export function validateBody(body) {
  if (!body || typeof body !== 'object' || Array.isArray(body)) throw new ApiError(400, 'invalid_body', 'Request body must be a JSON object.');
  const { questionId, examType, userDoubt, chatHistory = [] } = body;
  if (typeof questionId !== 'string' || !/^[\w.:-]{1,100}$/.test(questionId)) throw new ApiError(400, 'invalid_question_id', 'questionId is missing or malformed.');
  if (!EXAM_TYPES.includes(examType)) throw new ApiError(400, 'invalid_exam_type', `examType must be one of ${EXAM_TYPES.join(', ')}.`);
  if (typeof userDoubt !== 'string' || !userDoubt.trim()) throw new ApiError(400, 'invalid_doubt', 'userDoubt must be a non-empty string.');
  if (userDoubt.length > LIMITS.doubtChars) throw new ApiError(400, 'doubt_too_long', `userDoubt must be at most ${LIMITS.doubtChars} characters.`);
  if (!Array.isArray(chatHistory)) throw new ApiError(400, 'invalid_history', 'chatHistory must be an array.');
  const history = chatHistory.slice(-LIMITS.historyMessages).map(entry => {
    if (!entry || !['user', 'assistant'].includes(entry.role) || typeof entry.content !== 'string') {
      throw new ApiError(400, 'invalid_history', 'Each chatHistory entry needs role ("user" | "assistant") and string content.');
    }
    return { role: entry.role, content: entry.content.slice(0, LIMITS.historyChars) };
  });
  return { questionId, examType, userDoubt: userDoubt.trim(), history };
}

// ---------- question lookup (server-side: the client is never trusted to supply question text) ----------
const jsonCache = new Map();
async function loadJson(name) {
  if (!jsonCache.has(name)) {
    jsonCache.set(name, JSON.parse(await readFile(new URL(`../src/data/${name}`, import.meta.url), 'utf8')));
  }
  return jsonCache.get(name);
}

const cleanText = text => String(text ?? '').replace(/\\r\\n|\\n|\\r/g, '\n').trim(); // table cells may hold a literal "\n"
const letter = index => String.fromCharCode(65 + index);

// Each resolver returns { questionText, options: string[], correctAnswer, explanation } or null.
const RESOLVERS = [
  { // UPSC PYQs bundled with the app, ids like "upsc-vedic-1"
    test: id => id.startsWith('upsc-'),
    async resolve(id) {
      for (const file of ['upscVedicPyqs.json', 'upscBuddhismPyqs.json']) {
        const q = (await loadJson(file)).find(item => item.id === id);
        if (q) {
          const correct = q.options.find(option => option.value === q.answer);
          return { questionText: q.question, options: q.options.map(o => `${o.value}. ${o.text}`), correctAnswer: correct ? `${correct.value}. ${correct.text}` : '', explanation: q.explanation || '' };
        }
      }
      return null;
    },
  },
  { // TGPSC AEE PYQs in Supabase, ids like "aee-123"
    test: id => /^aee-\d+$/.test(id),
    async resolve(id) {
      const { supabaseUrl, supabaseKey } = env();
      if (!supabaseUrl || !supabaseKey) return null;
      const res = await fetch(`${supabaseUrl}/rest/v1/tgpsc_aee_pyqs?id=eq.${id.slice(4)}&select=*&limit=1`, { headers: { apikey: supabaseKey, Authorization: `Bearer ${supabaseKey}` } });
      if (!res.ok) return null;
      const [row] = await res.json();
      if (!row) return null;
      const options = (Array.isArray(row.options) ? row.options : Object.values(row.options || {})).map(o => cleanText(typeof o === 'string' ? o : o?.text ?? String(o)));
      const correct = Number.isInteger(row.correct_option) ? row.correct_option - 1 : -1;
      const imageKey = Object.keys(row).find(k => /image|img|diagram|figure/i.test(k) && /^https?:\/\//i.test(String(row[k] ?? '').trim()));
      const captionKey = Object.keys(row).find(k => /caption|image_text|image_note|image_desc/i.test(k) && typeof row[k] === 'string' && row[k].trim());
      return {
        questionText: [row.subject ? `[Subject: ${row.subject}]` : '', row.exam_year ? `[TGPSC AEE ${row.exam_year}]` : '', cleanText(row.question_text), captionKey ? `Figure note: ${cleanText(row[captionKey])}` : ''].filter(Boolean).join('\n'),
        options: options.map((o, i) => `${letter(i)}. ${o}`),
        correctAnswer: options[correct] ? `${letter(correct)}. ${options[correct]}` : '',
        explanation: '',
        imageUrl: imageKey ? String(row[imageKey]).trim() : '',
      };
    },
  },
];

// Question figures (e.g. a manometer diagram) are sent to Gemini as inline images. Only images hosted on our own
// Supabase project are fetched, so a row can't make the server request arbitrary URLs.
const MAX_IMAGE_BYTES = 4 * 1024 * 1024;
export async function fetchQuestionImage(url, fetchImpl = fetch) {
  const { supabaseUrl } = env();
  if (!url || !supabaseUrl) return null;
  try {
    if (new URL(url).origin !== new URL(supabaseUrl).origin) return null;
    const res = await fetchImpl(url, { signal: AbortSignal.timeout(8000) });
    const mimeType = (res.headers.get('content-type') || '').split(';')[0].trim();
    if (!res.ok || !/^image\/(png|jpe?g|webp|gif)$/.test(mimeType)) return null;
    const bytes = Buffer.from(await res.arrayBuffer());
    return bytes.length <= MAX_IMAGE_BYTES ? { mimeType, data: bytes.toString('base64') } : null;
  } catch { return null; }
}

export async function lookupQuestion(questionId) {
  const resolver = RESOLVERS.find(r => r.test(questionId));
  return resolver ? resolver.resolve(questionId) : null;
}

// ---------- prompt construction ----------
// ---------- prompt construction ----------
const clip = (text, max) => String(text ?? '').slice(0, max);
// Question data is wrapped in tags and the tags are stripped from the data, so it can't close the block early.
const neutralize = text => String(text ?? '').replace(/<\/?\s*(question_context|system|instructions?)\b[^>]*>/gi, '');

export function buildSystemInstruction(examType, question, { hasImage = false, missingImage = false } = {}) {
  const context = clip(neutralize([
    `Question: ${question.questionText}`,
    question.options.length ? `Options:\n${question.options.join('\n')}` : '',
    question.correctAnswer ? `Correct answer: ${question.correctAnswer}` : '',
    question.explanation ? `Official explanation: ${question.explanation}` : '',
  ].filter(Boolean).join('\n\n')), LIMITS.contextChars);
  
  return [
    `You are a patient study assistant for ${EXAM_LABEL[examType]} aspirants. A student is asking a follow-up doubt about one exam question.`,
    'Rules:',
    '- Answer only doubts about this question, its options, its explanation, or the underlying concept. If the student asks about anything else, politely steer them back to this question.',
    '- Be accurate and concise (under ~250 words unless the student asks for more). Use short paragraphs, "- " bullet lists and **bold** for key terms. Write formulas in plain text with Unicode symbols, NOT LaTeX: for example Fr = V / √(g·D), y₂/y₁ = ½(√(1 + 8Fr₁²) − 1), σ = P/A, 5 × 10⁻³ m². Never use $, \\(, \\[ or backslash commands. Put each important equation on its own line. Show working step by step for numerical questions.',
    '- If the official explanation and your own reasoning disagree, say so plainly and explain why instead of silently picking one. If you are not sure, say you are not sure.',
    ...(question.explanation ? [] : ['- No official explanation is available. Work the solution out yourself and check that it reaches the stated correct answer.']),
    
    // --- FORMATTING RULES TO FIX READABILITY ---
    '- CRITICAL FORMATTING RULE: Never use double dollar signs ($$) for standalone mathematical blocks or fractional layouts like \\frac{}{}. Renderers break them.',
    '- Render all math formulas and variables inline using parenthetical markdown notation like \\(F_r = V / \\sqrt{g \\cdot D}\\) or explicit plain text.',
    '- Bold the core equations and highlight components with punchy bullet points.',
    '- Example style: "**\\(F_r = V / \\sqrt{g \\cdot D}\\)** where **\\(V\\)** = flow velocity."',

    `\n<question_context>\n${context}\n</question_context>`
  ].join('\n');
}

// Gemini needs contents that start with a "user" turn and alternate roles.
export function buildContents(history, userDoubt) {
  const turns = [...history.map(h => ({ role: h.role === 'assistant' ? 'model' : 'user', text: h.content })), { role: 'user', text: userDoubt }];
  const merged = [];
  for (const turn of turns) {
    const last = merged[merged.length - 1];
    if (last && last.role === turn.role) last.text += `\n\n${turn.text}`;
    else merged.push({ ...turn });
  }
  while (merged.length && merged[0].role !== 'user') merged.shift();
  return merged.map(t => ({ role: t.role, parts: [{ text: t.text }] }));
}

// ---------- Gemini ----------
// Gemini models are sometimes overloaded (503) or slow; fall back once to a lighter model before giving up.
export async function callGemini(payload, fetchImpl = fetch) {
  const { model, fallbackModel } = env();
  try {
    return await callGeminiModel(model, payload, fetchImpl);
  } catch (error) {
    const retryable = error instanceof ApiError && [429, 502, 503, 504].includes(error.status) && error.code !== 'ai_not_configured';
    if (!retryable || !fallbackModel || fallbackModel === model) throw error;
    console.warn(`[ask-ai] ${model} failed (${error.code}); retrying with ${fallbackModel}`);
    return callGeminiModel(fallbackModel, payload, fetchImpl);
  }
}

async function callGeminiModel(model, { systemInstruction, contents: baseContents, image }, fetchImpl) {
  let contents = baseContents;
  if (image) { // attach the figure to the student's latest message
    contents = baseContents.map((turn, i) => i === baseContents.length - 1 ? { ...turn, parts: [...turn.parts, { inlineData: { mimeType: image.mimeType, data: image.data } }] } : turn);
  }
  const { geminiKey } = env();
  if (!geminiKey) throw new ApiError(503, 'ai_not_configured', 'The AI assistant is not configured on the server.');
  let res;
  try {
    res = await fetchImpl(`https://generativelanguage.googleapis.com/v1beta/models/${encodeURIComponent(model)}:generateContent`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'x-goog-api-key': geminiKey },
      body: JSON.stringify({
        systemInstruction: { parts: [{ text: systemInstruction }] },
        contents,
        generationConfig: { temperature: 0.3, maxOutputTokens: LIMITS.maxOutputTokens },
      }),
      signal: AbortSignal.timeout(LIMITS.geminiTimeoutMs),
    });
  } catch (error) {
    if (error?.name === 'TimeoutError' || error?.name === 'AbortError') throw new ApiError(504, 'ai_timeout', 'The AI took too long to respond. Please try again.');
    throw new ApiError(502, 'ai_unreachable', 'Could not reach the AI service. Please try again.');
  }
  if (res.status === 429) throw new ApiError(429, 'ai_rate_limited', 'The AI service is busy. Please try again in a moment.');
  if (!res.ok) {
    console.error('[ask-ai] Gemini error', res.status, (await res.text().catch(() => '')).slice(0, 300));
    throw new ApiError(502, 'ai_error', 'The AI service returned an error. Please try again.');
  }
  const data = await res.json();
  if (data.promptFeedback?.blockReason) throw new ApiError(422, 'ai_blocked', 'The AI could not answer that message. Try rephrasing your doubt.');
  const candidate = data.candidates?.[0];
  const text = (candidate?.content?.parts || []).map(part => part.text || '').join('').trim();
  if (!text) throw new ApiError(502, 'ai_empty', 'The AI returned an empty answer. Please try again.');
  return candidate.finishReason === 'MAX_TOKENS' ? `${text}\n\n(Answer shortened — ask me to continue if you need more.)` : text;
}

// ---------- auth + rate limit ----------
export async function authenticate(req, fetchImpl = fetch) {
  const { requireAuth, supabaseUrl, supabaseKey } = env();
  if (!requireAuth) return { id: 'anonymous' };
  const token = /^Bearer\s+(.+)$/i.exec(req.headers.authorization || '')?.[1];
  if (!token) throw new ApiError(401, 'unauthenticated', 'Please sign in to use the AI assistant.');
  if (!supabaseUrl || !supabaseKey) throw new ApiError(503, 'auth_not_configured', 'Authentication is not configured on the server.');
  const res = await fetchImpl(`${supabaseUrl}/auth/v1/user`, { headers: { apikey: supabaseKey, Authorization: `Bearer ${token}` } }).catch(() => null);
  if (!res || res.status >= 500) throw new ApiError(503, 'auth_unavailable', 'Could not verify your session. Please try again.');
  if (!res.ok) throw new ApiError(401, 'unauthenticated', 'Your session has expired. Please sign in again.');
  const user = await res.json();
  return { id: user.id };
}

const hits = new Map(); // single-process, in-memory; use a shared store (e.g. Redis) when running several instances
export function rateLimit(key, now = Date.now()) {
  const windowStart = now - 60_000;
  const recent = (hits.get(key) || []).filter(t => t > windowStart);
  if (recent.length >= LIMITS.rateLimitPerMinute) {
    hits.set(key, recent);
    throw new ApiError(429, 'rate_limited', 'Too many questions. Please wait a minute and try again.');
  }
  recent.push(now);
  hits.set(key, recent);
  if (hits.size > 5000) for (const [k, v] of hits) if (!v.some(t => t > windowStart)) hits.delete(k);
}

// ---------- HTTP handler ----------
async function readJson(req) {
  const chunks = [];
  let size = 0;
  for await (const chunk of req) {
    size += chunk.length;
    if (size > LIMITS.bodyBytes) throw new ApiError(413, 'payload_too_large', 'Request is too large.');
    chunks.push(chunk);
  }
  try { return JSON.parse(Buffer.concat(chunks).toString('utf8')); }
  catch { throw new ApiError(400, 'invalid_json', 'Request body is not valid JSON.'); }
}

export async function handleAskAi(req, res) {
  try {
    if (!/^application\/json/i.test(req.headers['content-type'] || '')) throw new ApiError(415, 'unsupported_media_type', 'Content-Type must be application/json.');
    const user = await authenticate(req);
    rateLimit(user.id === 'anonymous' ? req.socket.remoteAddress || 'unknown' : user.id);
    const { questionId, examType, userDoubt, history } = validateBody(await readJson(req));
    const question = await lookupQuestion(questionId);
    if (!question) throw new ApiError(404, 'question_not_found', 'That question was not found.');
    const image = await fetchQuestionImage(question.imageUrl);
    const reply = await callGemini({ systemInstruction: buildSystemInstruction(examType, question, { hasImage: !!image, missingImage: !!question.imageUrl && !image }), contents: buildContents(history, userDoubt), image });
    send(res, 200, { reply });
  } catch (error) {
    if (!(error instanceof ApiError)) console.error('[ask-ai] unexpected', error);
    const apiError = error instanceof ApiError ? error : new ApiError(500, 'internal_error', 'Something went wrong. Please try again.');
    send(res, apiError.status, { error: { code: apiError.code, message: apiError.message } });
  }
}

function send(res, status, payload) {
  res.writeHead(status, { 'Content-Type': 'application/json; charset=utf-8', 'Cache-Control': 'no-store' });
  res.end(JSON.stringify(payload));
}
