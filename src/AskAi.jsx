import React, { useCallback, useEffect, useRef, useState } from 'react';
import { Send, Sparkles, X } from 'lucide-react';

import { supabase } from './supabase';
import FormattedMessage from './FormattedMessage';


const EXAM_LABELS = { UPSC: 'UPSC', GATE: 'GATE', SSC_CGL: 'SSC CGL', TGPSC_AEE: 'TGPSC AEE' };

// Local dev: the Vite proxy sends /api/ask-ai to server/askAi.mjs (npm run api).
// Deployed site: the Supabase Edge Function "ask-ai". Set VITE_ASK_AI_URL to override either.
const ASK_AI_URL =
  import.meta.env.VITE_ASK_AI_URL ||
  (import.meta.env.DEV
    ? '/api/ask-ai'
    : 'https://hcdjbvgabqfqfmbisngv.supabase.co/functions/v1/ask-ai');
    
// Only the question id is sent; the server looks up the question itself.
export async function fetchAskAiReply({ context, history, userText }) {
  const headers = { 'Content-Type': 'application/json' };
  if (import.meta.env.VITE_SUPABASE_ANON_KEY) headers.apikey = import.meta.env.VITE_SUPABASE_ANON_KEY;
  const session = supabase ? (await supabase.auth.getSession()).data.session : null;
  if (session?.access_token) headers.Authorization = `Bearer ${session.access_token}`;
  let res;
  try {
    res = await fetch(ASK_AI_URL, {
      method: 'POST',
      headers,
      body: JSON.stringify({
        questionId: context.questionId,
        examType: context.examType,
        userDoubt: userText,
        chatHistory: history.filter(m => !m.isError).map(m => ({ role: m.sender, content: m.text })),
      }),
    });
  } catch {
    throw new Error('Could not reach the AI service. Check your connection and try again.');
  }
  const data = await res.json().catch(() => ({}));
  if (!res.ok) {
    console.error('[ask-ai] request failed', res.status, ASK_AI_URL, data);
    // Our server sends { error: { message } }; the Supabase gateway sends { message } or { msg }.
    throw new Error(data?.error?.message || data?.message || data?.msg || `The AI service is unavailable (error ${res.status}). Please try again.`);
  }
  if (typeof data.reply !== 'string') {
    console.error('[ask-ai] unexpected response', res.status, ASK_AI_URL);
    throw new Error('The AI service is not set up correctly on this site. Please contact support.');
  }
  return data.reply;
}
const makeId = () => (globalThis.crypto?.randomUUID?.() ?? `${Date.now()}-${Math.random().toString(36).slice(2)}`);

/**
 * messages: ChatMessage[] = { id, sender: 'user' | 'assistant', text, timestamp: Date, isError? }
 * context:  ActiveQuestionContext = { questionId, examType: 'UPSC' | 'GATE' | 'SSC_CGL', questionText, staticExplanation }
 * Chat history is kept per question, so reopening a question restores its conversation.
 */
export function useAiDrawerState({ fetchReply = fetchAskAiReply } = {}) {
  const [isOpen, setIsOpen] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [currentQuestionContext, setCurrentQuestionContext] = useState(null);
  const [historyByQuestion, setHistoryByQuestion] = useState({});
  const requestRef = useRef(0);

  const messages = historyByQuestion[currentQuestionContext?.questionId] ?? [];

  const openDrawer = useCallback(context => {
    requestRef.current += 1; // ignore a reply still in flight for a previous question
    setIsLoading(false);
    setCurrentQuestionContext(context);
    setIsOpen(true);
  }, []);
  const closeDrawer = useCallback(() => setIsOpen(false), []);

  const sendMessage = useCallback(async text => {
    const userText = text.trim();
    const context = currentQuestionContext;
    if (!userText || !context || isLoading) return;
    const key = context.questionId;
    const append = message => setHistoryByQuestion(current => ({ ...current, [key]: [...(current[key] ?? []), message] }));
    const history = historyByQuestion[key] ?? [];
    const request = ++requestRef.current;
    append({ id: makeId(), sender: 'user', text: userText, timestamp: new Date() });
    setIsLoading(true);
    let reply;
    try {
      reply = { id: makeId(), sender: 'assistant', text: await fetchReply({ context, history, userText }), timestamp: new Date() };
    } catch (error) {
      reply = { id: makeId(), sender: 'assistant', text: error?.message || 'Something went wrong. Please try again.', timestamp: new Date(), isError: true };
    }
    append(reply);
    if (request === requestRef.current) setIsLoading(false);
  }, [currentQuestionContext, fetchReply, historyByQuestion, isLoading]);

  return { isOpen, messages, isLoading, currentQuestionContext, openDrawer, closeDrawer, sendMessage };
}

export function AskAiButton({ questionId, examType, questionText, staticExplanation, onOpen }) {
  return <button type="button" className="ask-ai-button" onClick={() => onOpen({ questionId, examType, questionText, staticExplanation })}>
    <Sparkles size={16} aria-hidden="true" /> Still confused? Ask AI
  </button>;
}

export function AiChatDrawer({ isOpen, onClose, messages, isLoading, context, onSend, examLabel }) {
  const [draft, setDraft] = useState('');
  const bodyEndRef = useRef(null);
  const inputRef = useRef(null);
  const returnFocusRef = useRef(null);
  const tag = examLabel ?? EXAM_LABELS[context?.examType] ?? context?.examType;

  useEffect(() => { // auto-scroll to the newest message
    bodyEndRef.current?.scrollIntoView?.({ behavior: 'smooth', block: 'end' });
  }, [messages, isLoading, isOpen]);

  useEffect(() => { // focus management + Escape to close
    if (!isOpen) return undefined;
    returnFocusRef.current = document.activeElement;
    inputRef.current?.focus();
    const onKey = event => { if (event.key === 'Escape') onClose(); };
    document.addEventListener('keydown', onKey);
    return () => { document.removeEventListener('keydown', onKey); returnFocusRef.current?.focus?.(); };
  }, [isOpen, onClose]);

  useEffect(() => { setDraft(''); }, [context?.questionId]);

  useEffect(() => { // auto-expanding textarea
    const el = inputRef.current;
    if (!el) return;
    el.style.height = 'auto';
    el.style.height = `${Math.min(el.scrollHeight, 120)}px`;
  }, [draft, isOpen]);

  const canSend = draft.trim().length > 0 && !isLoading;
  const submit = () => { if (!canSend) return; onSend(draft); setDraft(''); };
  const onKeyDown = event => {
    if (event.key === 'Enter' && !event.shiftKey && !event.nativeEvent.isComposing) { event.preventDefault(); submit(); }
  };

  return <div className={`ai-drawer-root ${isOpen ? 'is-open' : ''}`} aria-hidden={!isOpen}>
    <div className="ai-drawer-overlay" onClick={onClose} />
    <aside className="ai-drawer" role="dialog" aria-modal="true" aria-labelledby="ai-drawer-title" inert={!isOpen ? '' : undefined}>
      <header className="ai-drawer-header">
        <Sparkles size={18} aria-hidden="true" />
        <h2 id="ai-drawer-title">AI Study Assistant</h2>
        {tag && <span className="ai-drawer-badge">{tag}</span>}
        <button type="button" className="ai-drawer-close" onClick={onClose} aria-label="Close AI assistant"><X size={18} /></button>
      </header>
      <div className="ai-drawer-body" role="log" aria-live="polite" aria-label="Conversation">
        {!messages.length && <p className="ai-drawer-empty">Ask anything about this question or its solution. Your doubt stays linked to this question.</p>}
        {messages.map(message => <div key={message.id} className={`ai-message ai-message-${message.sender}${message.isError ? ' is-error' : ''}`}>
          {message.sender === 'assistant' && !message.isError
            ? <div className="ai-bubble ai-bubble-rich"><FormattedMessage text={message.text} /></div>
            : <div className="ai-bubble" role={message.isError ? 'alert' : undefined}>{message.text}</div>}
        </div>)}
        {isLoading && <div className="ai-message ai-message-assistant" role="status" aria-label="AI is typing">
          <div className="ai-bubble ai-typing"><span /><span /><span /></div>
        </div>}
        <div ref={bodyEndRef} />
      </div>
      <footer className="ai-drawer-footer">
        <textarea ref={inputRef} rows={1} value={draft} onChange={event => setDraft(event.target.value)} onKeyDown={onKeyDown} placeholder="Ask a follow-up doubt about this solution..." aria-label="Your doubt" />
        <button type="button" className="ai-send" onClick={submit} disabled={!canSend} aria-label="Send message"><Send size={18} /></button>
      </footer>
    </aside>
  </div>;
}
