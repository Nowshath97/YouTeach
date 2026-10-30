
import React, {
  useCallback,
  useEffect,
  useRef,
  useState,
} from 'react';

import {
  Send,
  Sparkles,
  X,
  CircleHelp,
  BookOpen,
  ListChecks,
  Zap,
  NotebookPen,
} from 'lucide-react';

import { supabase } from './supabase';
import FormattedMessage from './FormattedMessage';

// --------------------------------------------------
// CONFIGURATION
// --------------------------------------------------

const EXAM_LABELS = {
  UPSC: 'UPSC',
  GATE: 'GATE',
  SSC_CGL: 'SSC CGL',
  TGPSC_AEE: 'TGPSC AEE',
};

const ASK_AI_URL =
  import.meta.env.VITE_ASK_AI_URL ||
  (import.meta.env.DEV
    ? '/api/ask-ai'
    : 'https://hcdjbvgabqfqfmbisngv.supabase.co/functions/v1/ask-ai');

// --------------------------------------------------
// GUIDED AI ACTIONS
// --------------------------------------------------

const AI_ACTIONS = [
  {
    id: 'explain_mistake',
    label: 'Why am I wrong?',
    description: 'Understand your mistake',
    icon: CircleHelp,
    prompt:
      'Explain why my answer is incorrect. Identify the ' +
      'misconception and explain the correct reasoning. ' +
      'Keep your explanation concise and focused on this PYQ.',
  },
  {
    id: 'explain_simple',
    label: 'Explain simply',
    description: 'Understand the concept',
    icon: BookOpen,
    prompt:
      'Explain this question in very simple language. ' +
      'Assume I am a beginner. Explain the main concept ' +
      'step by step, using one easy example if helpful. ' +
      'Keep the response short.',
  },
  {
    id: 'explain_options',
    label: 'Explain all options',
    description: 'Understand each choice',
    icon: ListChecks,
    prompt:
      'Explain why each option in this MCQ is correct or ' +
      'incorrect. Use short bullet points. Clearly identify ' +
      'the correct answer and the reasoning behind it.',
  },
  {
    id: 'exam_shortcut',
    label: 'Exam shortcut',
    description: 'Learn a faster method',
    icon: Zap,
    prompt:
      'Show a faster way to solve this question during a ' +
      'competitive exam. Explain a reliable shortcut or ' +
      'option-elimination technique if one exists. ' +
      'If no reliable shortcut exists, explain the ' +
      'shortest correct method.',
  },
  {
    id: 'quick_revision',
    label: 'Quick revision',
    description: 'Remember key points',
    icon: NotebookPen,
    prompt:
      'Give exactly three important revision points ' +
      'related to this question. Keep them short, ' +
      'accurate, and useful for competitive exams.',
  },
];

// --------------------------------------------------
// HELPERS
// --------------------------------------------------

const makeId = () =>
  globalThis.crypto?.randomUUID?.() ??
  `${Date.now()}-${Math.random().toString(36).slice(2)}`;

const getQuestionKey = context =>
  context?.questionId == null
    ? null
    : `${context.examType ?? ''}:${context.questionId}`;

function getGuidedPrompt(action, context) {
  if (action.id !== 'explain_mistake') {
    return action.prompt;
  }

  const selected = context?.selectedOption;
  const correct = context?.correctAnswer;

  if (selected == null || selected === '') {
    return (
      'Explain the common mistakes students make when ' +
      'solving this question. Explain the correct reasoning ' +
      'in simple terms. Do not assume which option I selected.'
    );
  }

  // Only use a correctness claim when the parent provides it.
  if (context?.isCorrect === true) {
    return (
      `I selected option ${String(selected)} and my answer ` +
      'was marked correct. Explain why my approach is correct ' +
      'and what concept I should remember.'
    );
  }

  if (context?.isCorrect === false) {
    return (
      `I selected option ${String(selected)}, which was ` +
      'marked incorrect. Explain my likely misconception ' +
      'and show the correct reasoning.' +
      (correct != null && correct !== ''
        ? ` The correct answer is ${String(correct)}.`
        : '')
    );
  }

  return (
    `I selected option ${String(selected)}. ` +
    'Explain whether this choice is correct or incorrect ' +
    'and why. Do not assume it is wrong without checking.'
  );
}

// --------------------------------------------------
// API REQUEST
// --------------------------------------------------

export async function fetchAskAiReply({
  context,
  history = [],
  userText,
}) {
  if (!ASK_AI_URL) {
    throw new Error('Ask AI endpoint is not configured.');
  }

  const headers = {
    'Content-Type': 'application/json',
  };

  const anonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

  if (anonKey) {
    headers.apikey = anonKey;
  }

  const session = supabase
    ? (await supabase.auth.getSession()).data.session
    : null;

  if (session?.access_token) {
    headers.Authorization = `Bearer ${session.access_token}`;
  }

  // Keep recent history only to control token usage.
  const recentHistory = history
    .filter(
      message =>
        !message.isError &&
        ['user', 'assistant'].includes(message.sender)
    )
    .slice(-6)
    .map(message => ({
      role: message.sender,
      content: String(message.text).slice(0, 1500),
    }));

  let res;

  try {
    res = await fetch(ASK_AI_URL, {
      method: 'POST',
      headers,
      body: JSON.stringify({
        questionId: context.questionId,
        examType: context.examType,
        userDoubt: userText,
        chatHistory: recentHistory,
      }),
    });
  } catch (error) {
    console.error('[ask-ai] network error', error);

    throw new Error(
      'Could not reach the AI service. ' +
      'Check your connection and try again.'
    );
  }

  const data = await res.json().catch(() => ({}));

  if (!res.ok) {
    console.error(
      '[ask-ai] request failed',
      res.status,
      ASK_AI_URL,
      data
    );

    const errorMessage =
      typeof data?.error === 'string'
        ? data.error
        : data?.error?.message ||
          data?.message ||
          data?.msg;

    throw new Error(
      errorMessage ||
      `The AI service is unavailable (error ${res.status}).`
    );
  }

  if (typeof data.reply !== 'string') {
    console.error(
      '[ask-ai] unexpected response',
      res.status,
      ASK_AI_URL,
      data
    );

    throw new Error(
      'The AI service returned an unexpected response.'
    );
  }

  return data.reply;
}

// --------------------------------------------------
// DRAWER STATE HOOK
// --------------------------------------------------

export function useAiDrawerState({
  fetchReply = fetchAskAiReply,
} = {}) {
  const [isOpen, setIsOpen] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  const [
    currentQuestionContext,
    setCurrentQuestionContext,
  ] = useState(null);

  const [
    historyByQuestion,
    setHistoryByQuestion,
  ] = useState({});

  const requestRef = useRef(0);
  const loadingRef = useRef(false);

  const questionKey = getQuestionKey(currentQuestionContext);

  const messages = questionKey
    ? historyByQuestion[questionKey] ?? []
    : [];

  const openDrawer = useCallback(context => {
    requestRef.current += 1;
    loadingRef.current = false;

    setIsLoading(false);
    setCurrentQuestionContext(context);
    setIsOpen(true);
  }, []);

  const closeDrawer = useCallback(() => {
    requestRef.current += 1;
    loadingRef.current = false;
    setIsLoading(false);
    setIsOpen(false);
  }, []);

  const sendMessage = useCallback(async text => {
    const userText =
      typeof text === 'string' ? text.trim() : '';

    const context = currentQuestionContext;
    const key = getQuestionKey(context);

    if (
      !userText ||
      !context ||
      !key ||
      loadingRef.current
    ) {
      return;
    }

    loadingRef.current = true;

    const history = historyByQuestion[key] ?? [];
    const request = ++requestRef.current;

    const append = message => {
      setHistoryByQuestion(current => ({
        ...current,
        [key]: [
          ...(current[key] ?? []),
          message,
        ],
      }));
    };

    append({
      id: makeId(),
      sender: 'user',
      text: userText,
      timestamp: new Date(),
    });

    setIsLoading(true);

    let reply;

    try {
      const replyText = await fetchReply({
        context,
        history,
        userText,
      });

      reply = {
        id: makeId(),
        sender: 'assistant',
        text: replyText,
        timestamp: new Date(),
      };
    } catch (error) {
      reply = {
        id: makeId(),
        sender: 'assistant',
        text:
          error?.message ||
          'Something went wrong. Please try again.',
        timestamp: new Date(),
        isError: true,
      };
    }

    // Ignore replies from invalidated requests.
    if (request === requestRef.current) {
      append(reply);
      loadingRef.current = false;
      setIsLoading(false);
    }
  }, [
    currentQuestionContext,
    fetchReply,
    historyByQuestion,
  ]);

  return {
    isOpen,
    messages,
    isLoading,
    currentQuestionContext,
    openDrawer,
    closeDrawer,
    sendMessage,
  };
}

// --------------------------------------------------
// ASK AI BUTTON
// --------------------------------------------------

export function AskAiButton({
  questionId,
  examType,
  questionText,
  staticExplanation,
  selectedOption,
  correctAnswer,
  isCorrect,
  onOpen,
}) {
  return (
    <button
      type="button"
      className="ask-ai-button"
      onClick={() =>
        onOpen({
          questionId,
          examType,
          questionText,
          staticExplanation,
          selectedOption,
          correctAnswer,
          isCorrect,
        })
      }
    >
      <Sparkles size={16} aria-hidden="true" />
      Still confused? Ask AI
    </button>
  );
}

// --------------------------------------------------
// AI CHAT DRAWER
// --------------------------------------------------

export function AiChatDrawer({
  isOpen,
  onClose,
  messages = [],
  isLoading,
  context,
  onSend,
  examLabel,
}) {
  const [draft, setDraft] = useState('');

  const bodyEndRef = useRef(null);
  const inputRef = useRef(null);
  const returnFocusRef = useRef(null);

  const tag =
    examLabel ??
    EXAM_LABELS[context?.examType] ??
    context?.examType;

  useEffect(() => {
    if (isOpen) {
      bodyEndRef.current?.scrollIntoView?.({
        behavior: 'smooth',
        block: 'end',
      });
    }
  }, [messages, isLoading, isOpen]);

  useEffect(() => {
    if (!isOpen) return undefined;

    returnFocusRef.current = document.activeElement;

    inputRef.current?.focus();

    const onKey = event => {
      if (event.key === 'Escape') {
        onClose();
      }
    };

    document.addEventListener('keydown', onKey);

    return () => {
      document.removeEventListener('keydown', onKey);
      returnFocusRef.current?.focus?.();
    };
  }, [isOpen, onClose]);

  useEffect(() => {
    setDraft('');
  }, [context?.questionId, context?.examType]);

  useEffect(() => {
    const el = inputRef.current;

    if (!el) return;

    el.style.height = 'auto';
    el.style.height =
      `${Math.min(el.scrollHeight, 120)}px`;
  }, [draft, isOpen]);

  const canSend =
    draft.trim().length > 0 && !isLoading;

  const submit = () => {
    if (!canSend) return;

    onSend(draft);
    setDraft('');
  };

  const onKeyDown = event => {
    if (
      event.key === 'Enter' &&
      !event.shiftKey &&
      !event.nativeEvent.isComposing
    ) {
      event.preventDefault();
      submit();
    }
  };

  const handleGuidedAction = action => {
    if (isLoading) return;

    const prompt = getGuidedPrompt(action, context);
    onSend(prompt);
  };

  return (
    <div
      className={`ai-drawer-root ${
        isOpen ? 'is-open' : ''
      }`}
      aria-hidden={!isOpen}
    >
      <div
        className="ai-drawer-overlay"
        onClick={onClose}
      />

      <aside
        className="ai-drawer"
        role="dialog"
        aria-modal="true"
        aria-labelledby="ai-drawer-title"
        inert={!isOpen ? '' : undefined}
      >
        {/* HEADER */}

        <header className="ai-drawer-header">
          <Sparkles
            size={18}
            aria-hidden="true"
          />

          <h2 id="ai-drawer-title">
            AI Study Assistant
          </h2>

          {tag && (
            <span className="ai-drawer-badge">
              {tag}
            </span>
          )}

          <button
            type="button"
            className="ai-drawer-close"
            onClick={onClose}
            aria-label="Close AI assistant"
          >
            <X size={18} />
          </button>
        </header>

        {/* GUIDED AI ACTIONS */}

        <div className="ai-guided-actions">
          <div className="ai-guided-heading">
            <Sparkles
              size={15}
              aria-hidden="true"
            />

            <span>
              How can I help you?
            </span>
          </div>

          <div className="ai-action-grid">
            {AI_ACTIONS.map(action => {
              const Icon = action.icon;

              const label =
                action.id === 'explain_mistake' &&
                context?.isCorrect === true
                  ? 'Why am I correct?'
                  : action.id === 'explain_mistake' &&
                    context?.selectedOption == null
                    ? 'Common mistakes'
                    : action.label;

              return (
                <button
                  key={action.id}
                  type="button"
                  className="ai-action-card"
                  disabled={isLoading || !isOpen}
                  onClick={() =>
                    handleGuidedAction(action)
                  }
                  title={action.description}
                >
                  <Icon
                    size={17}
                    aria-hidden="true"
                  />

                  <span>{label}</span>
                </button>
              );
            })}
          </div>
        </div>

        {/* CHAT MESSAGES */}

        <div
          className="ai-drawer-body"
          role="log"
          aria-live="polite"
          aria-label="Conversation"
        >
          {!messages.length && (
            <p className="ai-drawer-empty">
              Select an explanation above or ask
              a follow-up doubt about this question.
            </p>
          )}

          {messages.map(message => (
            <div
              key={message.id}
              className={
                `ai-message ai-message-${message.sender}` +
                (message.isError ? ' is-error' : '')
              }
            >
              {message.sender === 'assistant' &&
              !message.isError ? (
                <div className="ai-bubble ai-bubble-rich">
                  <FormattedMessage
                    text={message.text}
                  />
                </div>
              ) : (
                <div
                  className="ai-bubble"
                  role={
                    message.isError
                      ? 'alert'
                      : undefined
                  }
                >
                  {message.text}
                </div>
              )}
            </div>
          ))}

          {isLoading && (
            <div
              className="ai-message ai-message-assistant"
              role="status"
              aria-label="AI is typing"
            >
              <div className="ai-bubble ai-typing">
                <span />
                <span />
                <span />
              </div>
            </div>
          )}

          <div ref={bodyEndRef} />
        </div>

        {/* FOLLOW-UP INPUT */}

        <footer className="ai-drawer-footer">
          <textarea
            ref={inputRef}
            rows={1}
            maxLength={300}
            value={draft}
            onChange={event =>
              setDraft(event.target.value)
            }
            onKeyDown={onKeyDown}
            placeholder="Ask a doubt about this PYQ..."
            aria-label="Your doubt"
          />

          <button
            type="button"
            className="ai-send"
            onClick={submit}
            disabled={!canSend}
            aria-label="Send message"
          >
            <Send size={18} />
          </button>
        </footer>
      </aside>
    </div>
  );
}
