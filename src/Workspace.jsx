import {examCatalog, examFamilies, mockExamId} from './mockExamCatalog.mjs';
import {revealMobileResults} from './catalogNavigation.mjs';
import {isSscCgl} from './sscSectionTiming.mjs';
import AdminMockStatistics from './AdminMockStatistics';
import MemberChat from './MemberChat';
import { PASSWORD_REQUIREMENTS, isValidNewPassword } from './passwordRules.mjs';
import { isExistingSignupAccount } from './signupResult.mjs';
import { StudyFocus, ExamAndProgress } from './DashboardSidebars';
import SocialWall from './SocialWall';
import { ALL_BRANCHES, DEFAULT_BRANCH, getBranchOptions, getMockBranch, matchesMockBranch } from './mockBranches.mjs';
import MockTestReview from './MockTestReview';
import MockAttemptHistory, { AttemptScorecard } from './MockAttemptHistory';
import React, { useEffect, useRef, useState } from 'react';
import { Activity, ArrowLeft, ArrowRight, Atom, Bell, BookOpen, Briefcase, Building2, CalendarDays, Calculator, Check, CheckCircle2, ChevronDown, ChevronRight, Clock3, Cpu, CircuitBoard, Droplets, ExternalLink, Factory, FileQuestion, Flame, FlaskConical, GraduationCap, Grid2X2, Layers, LayoutDashboard, List, LogOut, MapPin, MessageCircle, Play, Ruler, Search, Send, Settings, SlidersHorizontal, Sparkles, Target, Thermometer, ThumbsUp, TrendingUp, UserRound, Wrench, Zap } from 'lucide-react';
import { supabase } from './supabase';
import MockExam from './MockExam';
import PreviousYearPapers, { isLinkedPaperMock } from './PreviousYearPapers';

const pages = [['Dashboard', LayoutDashboard], ['Practice', Target], ['Tutorials', BookOpen], ['Mock Tests', GraduationCap], ['PYQs', FileQuestion], ['Community', MessageCircle], ['Notifications', Bell]];
const Card = ({ children, className = '' }) => <section className={`card ${className}`}>{children}</section>;

function AuthPanel({ user, onLogout, setPage }) {
  const [error, setError] = useState('');
  const [menuOpen, setMenuOpen] = useState(false);
  const [publicProfile, setPublicProfile] = useState(null);
  useEffect(() => {
    let active = true;
    const sync = () => {
      if (!supabase) return;
      supabase.rpc('social_profile', { p_id: user.id }).then(({ data, error }) => {
        if (active && !error) setPublicProfile(data);
      }).catch(() => {});
    };
    sync(); window.addEventListener('member-profile-updated', sync);
    return () => { active = false; window.removeEventListener('member-profile-updated', sync); };
  }, [user.id]);

  async function logout() {
    const { error: signOutError } = await supabase.auth.signOut();
    if (signOutError) setError(signOutError.message);
    else {
      setMenuOpen(false);
      onLogout();
    }
  }
  const displayName = publicProfile?.display_name || user.user_metadata?.full_name || user.user_metadata?.name || 'Student';
  const initials = displayName.slice(0, 1).toUpperCase();
  return <div className="relative flex items-center gap-2 text-xs">
    <MemberChat user={user} />
    <button
      className="account-trigger account-trigger-compact"
      type="button"
      aria-expanded={menuOpen}
      aria-haspopup="menu"
      aria-label={`Open account menu for ${displayName}`} title={displayName}
      onClick={() => setMenuOpen(open => !open)}
    >
      <span className="account-avatar account-avatar-fallback">{initials}</span>
      <ChevronDown size={12} className="account-avatar-chevron" />
    </button>
    {menuOpen && <div className="account-menu" role="menu">
      <div className="account-menu-heading">
        <span className="block truncate font-bold text-slate-800">{displayName}</span>
        <span className="mt-1 block truncate text-[10px] text-slate-500">{user.email}</span>
      </div>
      <button className="account-menu-item" type="button" role="menuitem" onClick={() => { setMenuOpen(false); setPage('Profile'); }}>
        <UserRound size={15} /> Profile &amp; preferences
      </button>
      <button className="account-menu-item account-menu-logout" type="button" role="menuitem" onClick={logout}>
        <LogOut size={15} /> Sign out
      </button>
    </div>}
    {error && <span className="text-rose-700" role="alert">{error}</span>}
  </div>;
}

const examOptions = ['GATE', 'ESE', 'ISRO', 'PSU', 'Other'];
const latestJobNotices = [
  {
    id: 'ccs-hau-graduate-trainee',
    title: 'CCS HAU Graduate Trainee',
    organization: 'Chaudhary Charan Singh Haryana Agricultural University',
    category: 'Graduate trainee',
    location: 'Hisar, Haryana',
    details: 'Agriculture graduates can apply by email with an updated resume. The notice lists a CTC of Rs. 4.5 lakh per year.',
    deadline: '19 Oct 2026',
    source: 'https://www.freejobalert.com/articles/ccs-hau-graduate-trainee-recruitment-2026-apply-online-3073960',
  },
  {
    id: 'csir-iiim-project-roles',
    title: 'CSIR-IIIM Project Associate, Scientist & Assistant',
    organization: 'CSIR - Indian Institute of Integrative Medicine',
    category: 'Walk-in interview',
    location: 'Jammu',
    details: 'Eight temporary project positions across associate, scientist and assistant roles. Candidates attend the walk-in with the required documents.',
    deadline: '28 Oct 2026',
    source: 'https://www.freejobalert.com/articles/csir-iiim-recruitment-2026-walkin-for-8-project-associate-project-assistant-and-more-posts-3073975',
  },
  {
    id: 'tmc-actrec-jrf',
    title: 'TMC-ACTREC Junior Research Fellow',
    organization: 'Tata Memorial Centre - ACTREC',
    category: 'Research fellowship',
    location: 'Navi Mumbai',
    details: 'One project fellowship for eligible science, pharmacy, medicine or engineering graduates with the required national test qualification.',
    deadline: '30 Oct 2026',
    source: 'https://www.freejobalert.com/articles/tmc-actrec-junior-research-fellow-recruitment-2026-apply-online-3073977',
  },
  {
    id: 'iiitdm-jabalpur-project-roles',
    title: 'IIITDM Jabalpur Project Research & Technical Support',
    organization: 'PDPM IIITDM Jabalpur',
    category: 'Project recruitment',
    location: 'Jabalpur, Madhya Pradesh',
    details: 'Five temporary research and technical-support roles. Eligibility differs by post; the listing mentions an online application and a later selection round.',
    deadline: '30 Oct 2026',
    source: 'https://www.freejobalert.com/articles/iiitdm-jabalpur-recruitment-2026-apply-online-for-5-project-research-scientist-and-project-technical-support-posts-3073955',
  },
];
const upcomingExamNotices = [
  {
    id: 'btc-forester-written-exam',
    title: 'BTC Forester-I & Forest Guard written examination',
    organization: 'Central Selection Board, Bodoland Territorial Council',
    examDate: '2026-11-01T00:00:00+05:30',
    lastExamDate: '2026-11-01T23:59:59+05:30',
    dateLabel: '1 Nov 2026',
    stage: 'Written examination',
    summary: 'Written examination for Forester-I and Forest Guard recruitment. Admit cards are scheduled to be available from 16 October.',
    source: 'https://www.freejobalert.com/articles/btc-forester-and-forest-guard-written-exam-date-2026-3073980',
  },
  {
    id: 'upsc-ies-iss-interviews',
    title: 'UPSC Indian Economic Service / Indian Statistical Service 2026',
    organization: 'Union Public Service Commission',
    examDate: '2026-11-02T00:00:00+05:30',
    lastExamDate: '2026-11-05T23:59:59+05:30',
    dateLabel: '2–5 Nov 2026',
    stage: 'Personality tests',
    summary: 'Personality tests are scheduled across four days for candidates who qualified in the written examination. Check the source schedule for your roll-number-specific slot.',
    source: 'https://www.freejobalert.com/articles/upsc-ies-iss-interview-schedule-2026-3073944',
  },
];

function CreateAccountScreen({ onSignIn, onGoogle, googleBusy, authError }) {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmation, setConfirmation] = useState('');
  const [interestBranch, setInterestBranch] = useState('');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState('');
  const [sent, setSent] = useState(false);
  const [accountExists, setAccountExists] = useState(false);
  const passwordsMismatch = confirmation.length > 0 && password !== confirmation;

  async function register(event) {
    event.preventDefault();
    if (busy || googleBusy || !supabase) return;
    if (password !== confirmation) { setError('Passwords do not match.'); return; }
    if (!isValidNewPassword(password)) { setError(PASSWORD_REQUIREMENTS); return; }
    setBusy(true); setError(''); setAccountExists(false);
    try {
      const { data, error: signupError } = await supabase.auth.signUp({
        email: email.trim(), password,
        options: { data: { full_name: name.trim(), jobforsure_preferences: { preferredBranch: interestBranch === 'others' ? '' : interestBranch, educationInterest: interestBranch } }, emailRedirectTo: window.location.origin },
      });
      if (isExistingSignupAccount(data, signupError)) {
        setAccountExists(true);
        return;
      }
      if (signupError) throw signupError;
      if (!data.session) setSent(true);
    } catch (e) {
      setError(e.message || 'Unable to create your account. Please try again.');
    } finally { setBusy(false); }
  }

  return <main className="auth-page auth-signup-page">
    <section className="auth-card auth-signup-card" aria-labelledby="signup-heading">
      <a href="#/sign-in" className="auth-brand"><span className="auth-brand-mark">J.</span><span>JobFor<span className="text-indigo-600">Sure</span></span></a>
      <div className="mt-7"><span className="auth-kicker">START YOUR PREPARATION</span>
        <h1 id="signup-heading" tabIndex={-1}>{sent ? 'Check your email' : 'Create your account'}</h1>
        <p className="small">{sent ? 'If registration is available for this email, you will receive a confirmation link. Follow it to finish signing up.' : 'Join JobForSure to practice mock tests and save your progress.'}</p>
      </div>
      {sent ? <div className="mt-6"><p className="profile-success" role="status">Check the inbox and spam folder for {email}.</p><button className="btn btn-primary auth-submit" onClick={onSignIn}>Back to sign in</button></div> : <>
        <form className="auth-form" onSubmit={register}>
          <label htmlFor="signup-name">Full name</label>
          <input className="field" id="signup-name" autoComplete="name" placeholder="Your full name" value={name} onChange={e => setName(e.target.value)} maxLength={100} required disabled={busy || googleBusy} pattern=".*\S.*" />
          <label htmlFor="signup-branch">Graduation / field of study (optional)</label><select id="signup-branch" className="field" value={interestBranch} onChange={e => setInterestBranch(e.target.value)} disabled={busy || googleBusy}><StudyInterestOptions /></select>
          <label htmlFor="signup-email">Email address</label>
          <input className="field" id="signup-email" type="email" autoComplete="email" placeholder="you@example.com" value={email} onChange={e => { setEmail(e.target.value); setAccountExists(false); setError(''); }} aria-invalid={accountExists} aria-describedby={accountExists ? 'signup-existing-account' : undefined} required disabled={busy || googleBusy} />
          {accountExists && <div id="signup-existing-account" className="auth-message" role="alert">An account with this email already exists. Please sign in instead. <button type="button" className="text-indigo-600 underline" onClick={onSignIn} disabled={busy || googleBusy}>Sign in</button></div>}
          <label htmlFor="signup-password">Password</label>
          <input className="field" id="signup-password" type="password" autoComplete="new-password" placeholder="At least 8 characters" value={password} onChange={e => { setPassword(e.target.value); setError(''); }} minLength={8} aria-describedby="signup-password-rules" required disabled={busy || googleBusy} />
          <p id="signup-password-rules" className="small">{PASSWORD_REQUIREMENTS}</p>
          <label htmlFor="signup-confirm">Confirm password</label>
          <input className="field" id="signup-confirm" type="password" autoComplete="new-password" placeholder="Enter your password again" value={confirmation} onChange={e => { setConfirmation(e.target.value); setError(''); }} aria-invalid={passwordsMismatch} aria-describedby={passwordsMismatch ? 'signup-password-mismatch' : undefined} required disabled={busy || googleBusy} />
          {passwordsMismatch && <p id="signup-password-mismatch" className="auth-message" role="alert">Passwords do not match.</p>}
          <button className="btn btn-primary auth-submit" disabled={busy || googleBusy || !supabase}>{busy ? 'Creating account...' : 'Create account'}</button>
        </form>
        {(error || authError) && <p className="auth-message" role="alert">{error || authError}</p>}
        {!supabase && <p className="auth-notice" role="status">Account creation is currently unavailable.</p>}
        <p className="auth-switch">Already have an account?<button type="button" disabled={busy || googleBusy} onClick={onSignIn}>Sign in</button></p>
      </>}
    </section>
  </main>;
}

function AuthScreen({ authError }) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [mode, setMode] = useState(() => window.location.hash === '#/create-account' ? 'signup' : 'signin');
  const [message, setMessage] = useState('');
  const [busy, setBusy] = useState(false);
  const MAX_FAILS = 5, LOCK_MS = 30000, LOCK_KEY = 'jfs-signin-lock';
  const [lock, setLock] = useState(() => {
    try { return JSON.parse(localStorage.getItem(LOCK_KEY)) || { fails: 0, until: 0 }; } catch { return { fails: 0, until: 0 }; }
  });
  const [now, setNow] = useState(Date.now());
  const secondsLeft = Math.max(0, Math.ceil((lock.until - now) / 1000));
  useEffect(() => {
    try { localStorage.setItem(LOCK_KEY, JSON.stringify(lock)); } catch { /* storage unavailable */ }
  }, [lock]);
  useEffect(() => {
    if (lock.until <= Date.now()) return undefined;
    const timer = setInterval(() => {
      const t = Date.now();
      setNow(t);
      if (t >= lock.until) { setLock({ fails: 0, until: 0 }); setMessage(''); }
    }, 500);
    return () => clearInterval(timer);
  }, [lock.until]);
  useEffect(() => {
    const navigate = () => {
      setMode(window.location.hash === '#/create-account' ? 'signup' : 'signin');
      setMessage(''); setPassword('');
    };
    window.addEventListener('hashchange', navigate);
    return () => window.removeEventListener('hashchange', navigate);
  }, []);
  useEffect(() => {
    document.getElementById(mode === 'signup' ? 'signup-heading' : 'auth-heading')?.focus();
  }, [mode]);

  async function submit(event) {
    event.preventDefault();
    if (!supabase) {
      setMessage('Sign-in is unavailable until Supabase is configured.');
      return;
    }
    if (mode === 'signin' && lock.until > Date.now()) {
      setNow(Date.now());
      setMessage('Too many failed attempts. Please wait before trying again.');
      return;
    }
    setBusy(true);
    setMessage('');
    try {
      const result = mode === 'signin'
        ? await supabase.auth.signInWithPassword({ email, password })
        : await supabase.auth.signUp({ email, password });
      if (mode === 'signin') {
        if (result.error) {
          const fails = lock.fails + 1;
          if (fails >= MAX_FAILS) {
            const until = Date.now() + LOCK_MS;
            setNow(Date.now());
            setLock({ fails, until });
            setPassword('');
            setMessage('Too many failed attempts. Sign-in is locked for 30 seconds.');
            return;
          }
          setLock({ fails, until: 0 });
        } else setLock({ fails: 0, until: 0 });
      }
      if (result.error) setMessage(result.error.message);
      else if (mode === 'signup' && !result.data.session) setMessage('Account created. Check your email to confirm your account, then sign in.');
    } catch (error) {
      setMessage(error instanceof Error ? error.message : 'Unable to reach the sign-in service. Please try again.');
    } finally {
      setBusy(false);
    }
  }

  async function signInWithGoogle() {
    if (!supabase) {
      setMessage('Sign-in is unavailable until Supabase is configured.');
      return;
    }
    setBusy(true);
    setMessage('');
    try {
      const { error } = await supabase.auth.signInWithOAuth({
        provider: 'google',
        options: { redirectTo: window.location.origin },
      });
      if (error) {
        setMessage(error.message);
        setBusy(false);
      }
    } catch (error) {
      setMessage(error instanceof Error ? error.message : 'Unable to start Google sign-in. Please try again.');
      setBusy(false);
    }
  }

  if (mode === 'signup') return <CreateAccountScreen onSignIn={() => { window.location.hash = '/sign-in'; }} onGoogle={signInWithGoogle} googleBusy={busy} authError={message || authError} />;

  const highlights = [
    { icon: Sparkles, title: 'Ask AI, learn deeply', text: 'Get contextual explanations, hints and smarter ways to solve difficult questions.', status: 'Available now' },
    { icon: Target, title: 'Fix My Weakness', text: 'Turn incorrect answers into focused lessons, practice and mastery checks.', status: 'On our roadmap' },
    { icon: CalendarDays, title: 'Your daily study plan', text: 'An adaptive preparation path built around your goals, progress and available time.', status: 'On our roadmap' },
    { icon: Activity, title: 'Mock test insights', text: 'Review your performance today; get deeper AI-led diagnosis as the coach evolves.', status: 'Evolving' },
    { icon: BookOpen, title: 'Smart revision', text: 'Revisit difficult concepts at the right time and strengthen long-term recall.', status: 'On our roadmap' },
    { icon: GraduationCap, title: 'One AI exam coach', text: 'A connected learning experience that can guide your next best study action.', status: 'Our vision' },
  ];

  return <main className="jfs-landing">
    <style>{`
      .jfs-landing{--jfs-ink:#172044;--jfs-muted:#68738b;--jfs-primary:#5046db;--jfs-border:#e6e9f4;font-family:inherit;background:#f8faff;color:var(--jfs-ink);min-height:100vh;overflow-x:hidden}
      .jfs-landing *{box-sizing:border-box}
      .jfs-landing .jfs-shell{max-width:1440px;margin:auto;padding:0 clamp(24px,4vw,64px)}
      .jfs-landing .jfs-nav{height:76px;display:flex;align-items:center;justify-content:space-between;gap:20px}
      .jfs-landing .jfs-brand{display:flex;align-items:center;gap:10px;text-decoration:none;color:#1b2446;font-weight:850;font-size:21px;letter-spacing:-.7px}
      .jfs-landing .jfs-brand-mark{width:39px;height:39px;border-radius:12px;background:#5147dd;color:white;display:grid;place-items:center;font-weight:900}
      .jfs-landing .jfs-brand strong{color:#5147dd}
      .jfs-landing .jfs-navlinks{display:flex;align-items:center;gap:25px}
      .jfs-landing .jfs-navlinks a{font-size:13px;font-weight:700;color:#57637c;text-decoration:none}
      .jfs-landing .jfs-navlinks a:hover{color:#5147dd}
      .jfs-landing .jfs-navlinks a.jfs-button,.jfs-landing .jfs-navlinks a.jfs-button:hover{color:white}
      .jfs-landing .jfs-button{display:inline-flex;align-items:center;justify-content:center;gap:9px;border:0;border-radius:12px;padding:13px 20px;background:#5147dd;color:white;font-weight:750;font-size:14px;cursor:pointer;text-decoration:none;transition:transform .15s,background .15s}
      .jfs-landing .jfs-button:hover{background:#4036bf;transform:translateY(-1px)}
      .jfs-landing .jfs-button:disabled{opacity:.55;cursor:not-allowed;transform:none}
      .jfs-landing .jfs-button-light{background:white;color:#453cc4;border:1px solid #d9d9f8}
      .jfs-landing .jfs-button-light:hover{background:#f0efff}
      .jfs-landing .jfs-hero{display:grid;grid-template-columns:minmax(0,1.55fr) minmax(330px,.85fr);gap:clamp(30px,4vw,68px);align-items:center;padding:42px 0 62px;min-height:570px;background:none}
      .jfs-landing .jfs-eyebrow{display:inline-flex;align-items:center;gap:7px;color:#5147dd;font-size:11px;font-weight:850;letter-spacing:1.5px;text-transform:uppercase}
      .jfs-landing .jfs-hero h1{font-size:clamp(38px,3.7vw,54px);line-height:1.13;letter-spacing:-.045em;font-weight:850;margin:19px 0 18px;max-width:720px}
      .jfs-landing .jfs-hero h1 em{font-style:normal;color:#5147dd}
      .jfs-landing .jfs-lead{font-size:16px;line-height:1.7;color:#67728a;max-width:610px}
      .jfs-landing .jfs-hero-actions{display:flex;flex-wrap:wrap;gap:12px;margin-top:30px}
      .jfs-landing .jfs-trust{display:flex;flex-wrap:wrap;gap:16px;margin-top:27px;color:#67728a;font-size:12px;font-weight:650}
      .jfs-landing .jfs-trust span{display:inline-flex;gap:6px;align-items:center}
      .jfs-landing .jfs-auth-card{background:white;border:1px solid #e4e7f3;border-radius:22px;padding:30px;box-shadow:0 18px 55px rgba(45,47,116,.10);min-width:0;width:100%;max-width:420px;justify-self:end}
      .jfs-landing .jfs-auth-card h2{font-size:25px;line-height:1.3;letter-spacing:-.7px;font-weight:800;margin:11px 0 8px}
      .jfs-landing .jfs-auth-card .jfs-sub{font-size:13px;color:#7a849a;line-height:1.7;margin-bottom:24px}
      .jfs-landing .jfs-form{display:flex;flex-direction:column;gap:10px}
      .jfs-landing .jfs-form label{font-size:12px;font-weight:750;color:#36415c;margin-top:5px}
      .jfs-landing .jfs-form input{display:block;width:100%;height:46px;padding:0 14px;border:1px solid #dce1ef;border-radius:10px;background:white;color:#202945;font-size:14px;outline:none}
      .jfs-landing .jfs-form input:focus{border-color:#7167ee;box-shadow:0 0 0 3px #eeedff}
      .jfs-landing .jfs-form .jfs-button{width:100%;margin-top:11px}
      .jfs-landing .jfs-auth-switch{margin-top:20px;text-align:center;font-size:13px;color:#66718a}
      .jfs-landing .jfs-auth-switch button{border:0;background:none;color:#5147dd;font-weight:800;cursor:pointer;margin-left:5px}
      .jfs-landing .jfs-notice{margin-top:14px;border-radius:9px;background:#fff8e8;color:#865f14;padding:10px;font-size:12px;line-height:1.5;overflow-wrap:anywhere}
      .jfs-landing .jfs-error{margin-top:12px;color:#ae2543;font-size:12px;overflow-wrap:anywhere}
      .jfs-landing .jfs-terms{text-align:center;color:#9ba2b3;font-size:11px;line-height:1.6;margin-top:18px}
      .jfs-landing .jfs-section{padding:76px 0}
      .jfs-landing .jfs-section-soft{background:white;border-top:1px solid #eef0f7;border-bottom:1px solid #eef0f7}
      .jfs-landing .jfs-section-head{text-align:center;max-width:680px;margin:0 auto 42px}
      .jfs-landing .jfs-section-head h2{font-size:clamp(28px,3.2vw,39px);letter-spacing:-1.3px;line-height:1.2;font-weight:850;margin:12px 0}
      .jfs-landing .jfs-section-head p{color:#68738b;font-size:15px;line-height:1.75}
      .jfs-landing .jfs-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:18px}
      .jfs-landing .jfs-feature{padding:26px;border:1px solid #e7eaf5;border-radius:17px;background:#fff;min-width:0}
      .jfs-landing .jfs-icon{width:44px;height:44px;border-radius:12px;display:grid;place-items:center;background:#efedff;color:#5147dd;margin-bottom:20px}
      .jfs-landing .jfs-feature h3{font-size:16px;font-weight:800;margin:0 0 10px}
      .jfs-landing .jfs-feature p{font-size:13px;line-height:1.75;color:#737e95;margin:0 0 18px}
      .jfs-landing .jfs-status{display:inline-flex;border-radius:30px;background:#f2f4fa;color:#626e88;padding:6px 10px;font-size:10px;font-weight:800}
      .jfs-landing .jfs-status-live{background:#e9f8f1;color:#167751}
      .jfs-landing .jfs-journey{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:12px;margin-top:30px}
      .jfs-landing .jfs-step{border:1px solid #e4e7f3;background:#fff;border-radius:15px;padding:24px 20px}
      .jfs-landing .jfs-step b{display:block;font-size:12px;color:#5147dd;margin-bottom:10px}
      .jfs-landing .jfs-step strong{display:block;font-size:17px;margin-bottom:9px}
      .jfs-landing .jfs-step p{font-size:12px;line-height:1.7;color:#748097;margin:0}
      .jfs-landing .jfs-final{background:#29226f;border-radius:24px;padding:50px 28px;text-align:center;color:white}
      .jfs-landing .jfs-final h2{font-size:clamp(26px,3.5vw,40px);font-weight:850;letter-spacing:-1px;margin:0 0 13px}
      .jfs-landing .jfs-final p{color:#d9d6ff;max-width:540px;margin:0 auto 25px;line-height:1.7}
      .jfs-landing .jfs-footer{display:flex;justify-content:space-between;gap:15px;padding:30px 0;color:#8892a7;font-size:12px}
      @media(max-width:1050px){.jfs-landing .jfs-hero{gap:28px;grid-template-columns:minmax(0,1.2fr) minmax(300px,.8fr)}.jfs-landing .jfs-hero h1{font-size:clamp(36px,4vw,44px)}.jfs-landing .jfs-grid{grid-template-columns:repeat(2,minmax(0,1fr))}.jfs-landing .jfs-journey{grid-template-columns:repeat(2,minmax(0,1fr))}}
      @media(max-width:760px){.jfs-landing .jfs-shell{padding:0 18px}.jfs-landing .jfs-nav{height:66px}.jfs-landing .jfs-navlinks a{display:none}.jfs-landing .jfs-navlinks .jfs-button{padding:10px 13px;font-size:12px}.jfs-landing .jfs-hero{grid-template-columns:minmax(0,1fr);gap:30px;padding-top:30px;padding-bottom:54px;min-height:0}.jfs-landing .jfs-hero h1{font-size:clamp(35px,9vw,48px);letter-spacing:-1.5px}.jfs-landing .jfs-lead{font-size:15px}.jfs-landing .jfs-auth-card{padding:25px 21px;max-width:500px;justify-self:center}.jfs-landing .jfs-section{padding:58px 0}.jfs-landing .jfs-grid{grid-template-columns:minmax(0,1fr)}.jfs-landing .jfs-journey{grid-template-columns:minmax(0,1fr)}.jfs-landing .jfs-footer{flex-direction:column}.jfs-landing .jfs-final{padding:36px 22px}}
    `}</style>
    <div className="jfs-shell">
      <header className="jfs-nav">
        <a className="jfs-brand" href="#top" aria-label="JobForSure home"><span className="jfs-brand-mark">J.</span><span>JobFor<strong>Sure</strong></span></a>
        <nav className="jfs-navlinks" aria-label="Landing page navigation"><a href="#features">Features</a><a href="#how-it-works">How it works</a><a className="jfs-button" href="#join">Sign in <ArrowRight size={15}/></a></nav>
      </header>
      <div id="top" className="jfs-hero">
        <section>
          <span className="jfs-eyebrow"><Sparkles size={15}/> THE FUTURE OF ENGINEERING EXAM PREP</span>
          <h1>Prepare smarter.<br/><em>Improve with every question.</em></h1>
          <p className="jfs-lead">Meet JobForSure: your engineering exam preparation space, evolving into a personal AI coach that helps you understand mistakes, build confidence and make every study session count.</p>
          <div className="jfs-hero-actions"><a className="jfs-button" href="#join">Start preparing <ArrowRight size={17}/></a><a className="jfs-button jfs-button-light" href="#features">Explore our vision</a></div>
          <div className="jfs-trust"><span><CheckCircle2 size={15}/> Engineering-focused practice</span><span><CheckCircle2 size={15}/> Mock tests &amp; PYQs</span><span><CheckCircle2 size={15}/> AI-powered learning</span></div>
        </section>
        <section id="join" className="jfs-auth-card" aria-labelledby="auth-heading">
          <span className="jfs-eyebrow">WELCOME BACK</span>
          <h2 id="auth-heading" tabIndex={-1}>Continue your preparation</h2>
          <p className="jfs-sub">Sign in to pick up where you left off, review your progress and keep learning.</p>
          <form className="jfs-form" onSubmit={submit}>
            <label htmlFor="auth-email">Email address</label>
            <input id="auth-email" type="email" autoComplete="email" placeholder="you@example.com" value={email} onChange={event => setEmail(event.target.value)} required disabled={busy}/>
            <label htmlFor="auth-password">Password</label>
            <input id="auth-password" type="password" autoComplete="current-password" placeholder="Enter your password" value={password} onChange={event => setPassword(event.target.value)} minLength={6} required disabled={busy}/>
            <button className="jfs-button" type="submit" disabled={busy || !supabase || secondsLeft > 0}>{busy ? 'Please wait...' : secondsLeft > 0 ? `Try again in ${secondsLeft}s` : 'Sign in to JobForSure'} <ArrowRight size={16}/></button>
          </form>
          {!supabase && <p className="jfs-notice" role="status">Authentication is not configured. Add your Supabase URL and anon key to your .env file and restart the app.</p>}
          {authError && <p className="jfs-error" role="alert">{authError}</p>}
          {message && <p className="jfs-error" role="alert">{message}</p>}
          <p className="jfs-auth-switch">New to JobForSure?<button type="button" disabled={busy} onClick={() => { window.location.hash = '/create-account'; }}>Create an account</button></p>
          <p className="jfs-terms">By continuing, you agree to use JobForSure for your learning journey.</p>
        </section>
      </div>
    </div>
    <section id="features" className="jfs-section jfs-section-soft"><div className="jfs-shell">
      <div className="jfs-section-head"><span className="jfs-eyebrow">YOUR LEARNING COMPANION</span><h2>More than answers. A smarter way to prepare.</h2><p>Practice and mock tests are just the beginning. We're building a connected AI learning journey around each student's strengths, mistakes and goals.</p></div>
      <div className="jfs-grid">{highlights.map(({icon:Icon,title,text,status}) => <article className="jfs-feature" key={title}><span className="jfs-icon"><Icon size={22}/></span><h3>{title}</h3><p>{text}</p><span className={`jfs-status ${status === 'Available now' ? 'jfs-status-live' : ''}`}>{status}</span></article>)}</div>
    </div></section>
    <section id="how-it-works" className="jfs-section"><div className="jfs-shell">
      <div className="jfs-section-head"><span className="jfs-eyebrow">OUR PRODUCT VISION</span><h2>Every mistake can become progress.</h2><p>Our planned AI coaching experience follows a simple learning loop designed to turn practice into measurable improvement.</p></div>
      <div className="jfs-journey">{[
        ['01','Practice','Attempt exam-focused questions and mock tests.'],
        ['02','Understand','Get explanations and uncover the reason behind errors.'],
        ['03','Improve','Work through focused lessons and targeted practice.'],
        ['04','Remember','Review weaker concepts and track mastery over time.']
      ].map(([number,title,description]) => <article className="jfs-step" key={number}><b>{number}</b><strong>{title}</strong><p>{description}</p></article>)}</div>
    </div></section>
    <section className="jfs-section jfs-section-soft"><div className="jfs-shell"><div className="jfs-final"><h2>Your next breakthrough starts with one question.</h2><p>Prepare for GATE, ESE, ISRO, PSU and more with JobForSure. Start with today's tools and grow with our vision for personalized AI coaching.</p><a className="jfs-button jfs-button-light" href="#join">Get started <ArrowRight size={17}/></a></div></div></section>
    <footer className="jfs-shell jfs-footer"><span>© {new Date().getFullYear()} JobForSure</span><span>A little progress, every day. · Upcoming AI features are part of our roadmap.</span></footer>
  </main>;
}

function Onboarding({ user, setUser }) {
  const [exams, setExams] = useState([]);
  const [branch, setBranch] = useState(user.user_metadata?.jobforsure_preferences?.educationInterest || user.user_metadata?.jobforsure_preferences?.preferredBranch || '');
  const [subject, setSubject] = useState(() => practiceBranches.find(item => item.name === user.user_metadata?.jobforsure_preferences?.preferredBranch)?.subjects[0]?.name || '');
  const [message, setMessage] = useState('');
  const [busy, setBusy] = useState(false);
  const availableSubjects = practiceBranches.find(item => item.name === branch)?.subjects || [];

  function changeBranch(value) {
    const nextSubjects = practiceBranches.find(item => item.name === value)?.subjects || [];
    setBranch(value);
    setSubject(nextSubjects[0]?.name || '');
  }

  function toggleExam(exam) {
    setExams(current => current.includes(exam) ? current.filter(item => item !== exam) : [...current, exam]);
  }

  async function savePreferences(event) {
    event.preventDefault();
    if (!exams.length) {
      setMessage('Choose at least one exam you are preparing for.');
      return;
    }
    setBusy(true);
    setMessage('');
    const preferences = {
      exams,
      preferredBranch: branch === 'others' ? '' : branch,
      educationInterest: branch,
      preferredSubject: subject,
      completedAt: new Date().toISOString(),
    };
    try {
      const { data, error } = await supabase.auth.updateUser({
        data: { ...user.user_metadata, jobforsure_preferences: preferences },
      });
      if (error) setMessage(error.message);
      else setUser(data.user);
    } catch (error) {
      setMessage(error instanceof Error ? error.message : 'Unable to save your preferences. Please try again.');
    } finally {
      setBusy(false);
    }
  }

  return <main className="auth-page">
    <section className="onboarding-card">
      <a href="/" className="auth-brand" aria-label="JobForSure home">
        <span className="auth-brand-mark">J.</span>
        <span>JobFor<span className="text-indigo-600">Sure</span></span>
      </a>
      <span className="auth-kicker">LET'S PERSONALIZE YOUR SPACE</span>
      <h1>What are you preparing for?</h1>
      <p className="small">Tell us a little about your goals so your learning workspace feels more relevant to you.</p>
      <form className="onboarding-form" onSubmit={savePreferences}>
        <fieldset>
          <legend>Which exams are you preparing for?</legend>
          <div className="exam-options">
            {examOptions.map(exam => <label key={exam} className={`exam-option ${exams.includes(exam) ? 'exam-option-selected' : ''}`}>
              <input type="checkbox" checked={exams.includes(exam)} onChange={() => toggleExam(exam)} />
              <span>{exam}</span>
            </label>)}
          </div>
        </fieldset>
        <label htmlFor="preferred-branch">Graduation / field of study (optional)</label>
        <select id="preferred-branch" className="field" value={branch} onChange={event => changeBranch(event.target.value)}>
          <StudyInterestOptions />
        </select>
        <label htmlFor="preferred-subject">Your preferred subject</label>
        <select id="preferred-subject" className="field" value={subject} onChange={event => setSubject(event.target.value)} disabled={!availableSubjects.length} required={availableSubjects.length > 0}>{!availableSubjects.length && <option value="">Choose any subject later</option>}
          {availableSubjects.map(item => <option key={item.name} value={item.name}>{item.name}</option>)}
        </select>
        {message && <p className="auth-message" role="alert">{message}</p>}
        <button className="btn btn-primary auth-submit" type="submit" disabled={busy || (availableSubjects.length > 0 && !subject)}>
          {busy ? 'Saving your preferences...' : 'Continue to your workspace'}
        </button>
      </form>
    </section>
  </main>;
}

function ProfilePage({ user, setUser }) {
  const savedPreferences = user.user_metadata?.jobforsure_preferences || {};
  const [exams, setExams] = useState(savedPreferences.exams || []);
  const [branch, setBranch] = useState(savedPreferences.educationInterest || savedPreferences.preferredBranch || '');
  const [subject, setSubject] = useState(savedPreferences.preferredSubject || '');
  const [message, setMessage] = useState('');
  const [saved, setSaved] = useState(false);
  const [editing, setEditing] = useState(false);
  const [busy, setBusy] = useState(false);
  const availableSubjects = practiceBranches.find(item => item.name === branch)?.subjects || [];

  function changeBranch(value) {
    const nextSubjects = practiceBranches.find(item => item.name === value)?.subjects || [];
    setBranch(value);
    if (!nextSubjects.some(item => item.name === subject)) setSubject(nextSubjects[0]?.name || '');
    setSaved(false);
  }

  function toggleExam(exam) {
    setExams(current => current.includes(exam) ? current.filter(item => item !== exam) : [...current, exam]);
    setSaved(false);
  }

  async function saveProfile(event) {
    event.preventDefault();
    if (!editing || busy) return;
    if (!exams.length) {
      setMessage('Choose at least one exam you are preparing for.');
      setSaved(false);
      return;
    }
    setBusy(true);
    setMessage('');
    setSaved(false);
    const preferences = {
      ...savedPreferences,
      exams,
      preferredBranch: branch === 'others' ? '' : branch,
      educationInterest: branch,
      preferredSubject: subject,
      completedAt: savedPreferences.completedAt || new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };
    try {
      const { data, error } = await supabase.auth.updateUser({
        data: { ...user.user_metadata, jobforsure_preferences: preferences },
      });
      if (error) setMessage(error.message);
      else {
        setUser(data.user);
        localStorage.setItem('jobforsure.practice.branch', branch);
        localStorage.setItem('jobforsure.practice.exam', exams[0]);
        setSaved(true); setEditing(false);
      }
    } catch (error) {
      setMessage(error instanceof Error ? error.message : 'Unable to save your profile. Please try again.');
    } finally {
      setBusy(false);
    }
  }

  return <div className="mx-auto max-w-3xl space-y-4">
    <Card className="p-5 sm:p-7">
      <div className="eyebrow">YOUR STUDENT PROFILE</div>
      <h2 className="mt-2 text-xl font-extrabold">Preparation preferences</h2><p className="small mt-2">Choose a field of study as your default. You can always browse other branches in each section. Leave it blank or select Others for no preference.</p>{!editing && <button className="btn mt-3" onClick={() => { setEditing(true); setSaved(false); }}>Edit profile</button>}
      <p className="small mt-2">Update your exam goals and focus subject to personalize your dashboard and practice suggestions.</p>
      <div className="mt-5 rounded-lg bg-slate-50 p-3">
        <span className="eyebrow">ACCOUNT EMAIL</span>
        <p className="mt-1 text-sm font-semibold">{user.email}</p>
      </div>
      <form className="onboarding-form mt-6" onSubmit={saveProfile}><fieldset className="contents" disabled={!editing || busy}>
        <fieldset>
          <legend>Which exams are you preparing for?</legend>
          <div className="exam-options">
            {examOptions.map(exam => <label key={exam} className={`exam-option ${exams.includes(exam) ? 'exam-option-selected' : ''}`}>
              <input type="checkbox" checked={exams.includes(exam)} onChange={() => toggleExam(exam)} />
              <span>{exam}</span>
            </label>)}
          </div>
        </fieldset>
        <label htmlFor="profile-branch">Graduation / field of study (optional)</label>
        <select id="profile-branch" className="field" value={branch} onChange={event => changeBranch(event.target.value)}>
          <StudyInterestOptions />
        </select>
        <label htmlFor="profile-subject">Your preferred subject</label>
        <select id="profile-subject" className="field" value={subject} onChange={event => { setSubject(event.target.value); setSaved(false); }} disabled={!availableSubjects.length} required={availableSubjects.length > 0}>{!availableSubjects.length && <option value="">Choose any subject later</option>}
          {availableSubjects.map(item => <option key={item.name} value={item.name}>{item.name}</option>)}
        </select>
        {message && <p className="auth-message" role="alert">{message}</p>}
        </fieldset>{saved && <p className="profile-success" role="status">Your profile is saved. All study sections will use these preferences.</p>}
        <button className="btn btn-primary auth-submit" type="submit" disabled={!editing || busy || (availableSubjects.length > 0 && !subject)}>
          {busy ? 'Saving profile...' : 'Save profile'}
        </button>
      </form>
    </Card>
  </div>;
}

const mechanicalSubjects = [
  { name: 'Engineering Mechanics', question: 'A 100 N force acts at 30° above the horizontal. What is its horizontal component?', options: ['50 N', '86.6 N', '100 N', '115.5 N'], answer: 1, explanation: 'The horizontal component is F cos(30°) = 100 × 0.866 = 86.6 N.' },
  { name: 'Strength of Materials', question: 'A 10 kN tensile load acts on a 100 mm² bar, 1 m long. If E = 200 GPa, what is the elongation?', options: ['0.25 mm', '0.5 mm', '1 mm', '2 mm'], answer: 1, explanation: 'Using δ = PL/AE gives 0.0005 m, or 0.5 mm.' },
  { name: 'Hydraulics and Fluid Mechanics', question: 'For steady incompressible flow, a pipe diameter is reduced to half. How does the mean velocity change?', options: ['It halves', 'It doubles', 'It becomes four times', 'It stays the same'], answer: 2, explanation: 'Continuity gives A₁V₁ = A₂V₂. Halving diameter makes area one quarter, so velocity becomes four times.' },
  { name: 'Hydraulic Machines', question: 'Which turbine is generally suited to high head and relatively low flow?', options: ['Pelton wheel', 'Kaplan turbine', 'Propeller pump', 'Francis pump'], answer: 0, explanation: 'The Pelton wheel is an impulse turbine commonly selected for high-head sites.' },
  { name: 'Thermodynamics', question: 'For an ideal gas, which property is a function of temperature only?', options: ['Internal energy', 'Specific volume only', 'Pressure only', 'Boundary work'], answer: 0, explanation: 'For an ideal gas, internal energy depends only on temperature.' },
  { name: 'Steam Boilers and Engines', question: 'What is the primary function of a steam boiler?', options: ['Convert heat into shaft work directly', 'Transfer heat to water to produce steam', 'Condense exhaust steam', 'Increase feedwater velocity'], answer: 1, explanation: 'A boiler adds heat to water to generate steam at the required pressure and state.' },
  { name: 'Steam Nozzles and Turbines', question: 'In a steam nozzle, which energy conversion is the main purpose?', options: ['Kinetic energy to pressure energy', 'Enthalpy to kinetic energy', 'Heat to chemical energy', 'Shaft work to potential energy'], answer: 1, explanation: 'A nozzle converts steam enthalpy into kinetic energy as the fluid accelerates.' },
  { name: 'Machine Design', question: 'A component has a yield strength of 300 MPa and a design factor of 3. What is the allowable stress by this criterion?', options: ['100 MPa', '150 MPa', '300 MPa', '900 MPa'], answer: 0, explanation: 'Allowable stress = yield strength / factor of safety = 300 / 3 = 100 MPa.' },
  { name: 'IC Engines and Nuclear Power Plants', question: 'In a four-stroke engine, how many crankshaft revolutions occur in one complete cycle?', options: ['One half', 'One', 'Two', 'Four'], answer: 2, explanation: 'A four-stroke cycle has four piston strokes and takes two crankshaft revolutions.' },
  { name: 'Engineering Materials', question: 'Which property describes a material’s ability to undergo plastic elongation before fracture?', options: ['Ductility', 'Hardness', 'Brittleness', 'Creep resistance'], answer: 0, explanation: 'Ductility measures plastic deformation, often tensile elongation, before fracture.' },
  { name: 'Compressors, Gas Dynamics and Gas Turbines', question: 'Why is intercooling used between stages of a multistage compressor?', options: ['To increase the inlet temperature', 'To reduce compression work', 'To eliminate pressure rise', 'To increase clearance volume'], answer: 1, explanation: 'Cooling the gas between stages reduces the work needed for the next compression stage.' },
  { name: 'Theory of machines', question: 'A 20-tooth gear rotating at 600 rpm drives an external 40-tooth gear. What is the driven gear speed?', options: ['150 rpm', '300 rpm', '600 rpm', '1,200 rpm'], answer: 1, explanation: 'For external gears, speed is inversely proportional to tooth count: 600 × 20/40 = 300 rpm.' },
  { name: 'Heat Transfer, Refrigeration and Air Conditioning', question: 'For one-dimensional steady conduction through a plane wall, what increases the heat-transfer rate?', options: ['Greater wall thickness', 'Lower thermal conductivity', 'Greater temperature difference', 'Smaller wall area'], answer: 2, explanation: 'Fourier’s law gives Q̇ = kAΔT/L, so a greater temperature difference increases the rate.' },
  { name: 'Workshop Technology', question: 'Which lathe operation primarily reduces the outside diameter of a rotating workpiece?', options: ['Turning', 'Drilling', 'Broaching', 'Shaping'], answer: 0, explanation: 'In turning, a single-point tool removes material from the rotating workpiece to reduce its diameter.' },
  { name: 'Production Engineering', question: 'What directly controls tool movement in a CNC machine?', options: ['A numerical part program', 'A fixed mechanical cam only', 'Manual feed alone', 'A hydraulic accumulator'], answer: 0, explanation: 'CNC machine motions are controlled by a programmed sequence of numerical commands.' },
  { name: 'Automobile Engineering', question: 'Why does a vehicle differential allow the left and right drive wheels to rotate at different speeds?', options: ['To support cornering without tire scrub', 'To increase engine compression', 'To lock the steering column', 'To reduce brake pressure'], answer: 0, explanation: 'During a turn, the outer wheel travels farther; the differential allows it to rotate faster than the inner wheel.' },
  { name: 'Industrial Engineering and Production Management', question: 'The basic EOQ model balances which two inventory costs?', options: ['Ordering and holding costs', 'Material and labor costs', 'Inspection and scrap costs', 'Setup and transport costs'], answer: 0, explanation: 'Economic order quantity balances ordering cost against inventory holding cost.' },
];

const practiceBranches = [
  { name: 'Mechanical Engineering', subjects: mechanicalSubjects },
  { name: 'Electrical Engineering', subjects: ['Circuit Theory', 'Network Theorems', 'Electrical Machines', 'Power Systems', 'Control Systems', 'Power Electronics', 'Measurements', 'Signals and Systems'].map(name => ({ name })) },
  { name: 'Civil Engineering', subjects: ['Structural Analysis', 'Strength of Materials', 'Geotechnical Engineering', 'Fluid Mechanics', 'Environmental Engineering', 'Transportation Engineering', 'Surveying', 'Concrete Technology'].map(name => ({ name })) },
  { name: 'Computer Science', subjects: ['Programming and Data Structures', 'Algorithms', 'Operating Systems', 'Database Management Systems', 'Computer Networks', 'Computer Organization', 'Theory of Computation', 'Compiler Design'].map(name => ({ name })) },
  { name: 'Electronics and Communication Engineering', subjects: ['Network Theory', 'Electronic Devices', 'Analog Circuits', 'Digital Circuits', 'Signals and Systems', 'Control Systems', 'Communications', 'Electromagnetics'].map(name => ({ name })) },
];

function StudyInterestOptions() {
  return <><option value="">Not specified - explore all branches</option>{practiceBranches.map(item => <option key={item.name} value={item.name}>B.Tech / B.E. - {item.name}</option>)}<option value="others">Others - explore all branches</option></>;
}

function fallbackBranch(name) {
  const normalized = name.toLowerCase();
  if (normalized.includes('mechanical')) return practiceBranches[0];
  if (normalized.includes('civil')) return practiceBranches[2];
  if (normalized.includes('computer') || normalized === 'cse') return practiceBranches[3];
  if (normalized.includes('electronic') || normalized === 'ece') return practiceBranches[4];
  if (normalized.includes('electrical') || normalized === 'eee') return practiceBranches[1];
  return null;
}

function BranchIcon({ name, size = 16 }) {
  if (name.includes('Electrical')) return <Zap size={size} />;
  if (name.includes('Civil')) return <Building2 size={size} />;
  if (name.includes('Computer')) return <Cpu size={size} />;
  if (name.includes('Electronics')) return <Cpu size={size} />;
  return <Settings size={size} />;
}

function SubjectIcon({ name, size = 16 }) {
  const subject = name.toLowerCase();
  if (subject.includes('strength of materials') || subject.includes('solid mechanics') || subject.includes('stress analysis')) return <Activity size={size} />;
  if (subject.includes('engineering materials') || subject.includes('materials science')) return <Atom size={size} />;
  if (subject.includes('engineering mechanics')) return <Wrench size={size} />;
  if (subject.includes('fluid') || subject.includes('hydraulic') || subject.includes('water resources')) return <Droplets size={size} />;
  if (subject.includes('thermodynamics') || subject.includes('heat transfer') || subject.includes('thermal')) return <Thermometer size={size} />;
  if (subject.includes('manufacturing') || subject.includes('production') || subject.includes('workshop')) return <Factory size={size} />;
  if (subject.includes('machine design') || subject.includes('theory of machines') || subject.includes('mechanical design')) return <Settings size={size} />;
  if (subject.includes('electrical') || subject.includes('circuit') || subject.includes('power systems')) return <CircuitBoard size={size} />;
  if (subject.includes('electronics') || subject.includes('computer') || subject.includes('programming')) return <Cpu size={size} />;
  if (subject.includes('chemistry') || subject.includes('chemical')) return <FlaskConical size={size} />;
  if (subject.includes('mathematics') || subject === 'math' || subject.includes('numerical methods')) return <Calculator size={size} />;
  if (subject.includes('survey') || subject.includes('measurement') || subject.includes('metrology')) return <Ruler size={size} />;
  if (subject.includes('civil') || subject.includes('construction') || subject.includes('structural')) return <Building2 size={size} />;
  if (subject.includes('combustion') || subject.includes('engine') || subject.includes('power plant')) return <Flame size={size} />;
  return <BookOpen size={size} />;
}

function practiceSubjectKey(branchName, subjectName) {
  return `${branchName}:${subjectName}`;
}

function subjectStatusLabel(subject, branchName, subjectProgress) {
  return subjectProgress[practiceSubjectKey(branchName, subject.name)]?.status || 'Not Started';
}

function PracticeSubjectBrowser({
  branches,
  selectedBranch,
  examGoal,
  onExamChange,
  onChooseBranch,
  subjectStatus,
  onStatusChange,
  subjectView,
  onViewChange,
  search,
  onSearchChange,
  subjects,
  branchSubjects,
  topicCounts,
  branchTopicCount,
  questionCount,
  questionCountLoading,
  subjectProgress,
  onChooseSubject,
  loading,
  error,
}) {
  const tabs = [
    ['All Subjects', branchSubjects.length],
    ['Not Started', branchSubjects.filter(subject => subjectStatusLabel(subject, selectedBranch?.name || '', subjectProgress) === 'Not Started').length],
    ['In Progress', branchSubjects.filter(subject => subjectStatusLabel(subject, selectedBranch?.name || '', subjectProgress) === 'In Progress').length],
    ['Completed', branchSubjects.filter(subject => subjectStatusLabel(subject, selectedBranch?.name || '', subjectProgress) === 'Completed').length],
  ];

  return <div className="practice-layout">
    <aside className="practice-branch-panel" aria-label="Engineering branch selection">
      <h2>Your branch</h2>
      <div className="practice-branch-list">
        {branches.map(branch => <button
          key={branch.id}
          type="button"
          className={`practice-branch-option ${selectedBranch?.name === branch.name ? 'practice-branch-active' : ''}`}
          onClick={() => onChooseBranch(branch)}
        >
          <BranchIcon name={branch.name} />
          <span>{branch.name}</span>
          {selectedBranch?.name === branch.name && <ChevronRight size={15} />}
        </button>)}
      </div>
    </aside>
    <section className="practice-content">
      <header className="practice-hero">
        <div className="practice-hero-copy">
          <span className="practice-hero-branch">{selectedBranch?.name || 'Engineering'}</span>
          <h1>Practice. Learn. Be Job Ready.</h1>
          <p>Master concepts with practice questions, tutorials and mock tests.</p>
          {examGoal && <span className="practice-exam-chip">{examGoal} preparation</span>}
        </div>
        <label className="practice-exam-select">Exam focus
          <select value={examGoal} onChange={event => onExamChange(event.target.value)}>
            <option value="">All exams</option>
            {examOptions.map(exam => <option key={exam} value={exam}>{exam}</option>)}
          </select>
        </label>
        <div className="practice-hero-stats">
          <div><BookOpen size={19} /><strong>{branchSubjects.length}</strong><span>Subjects</span></div>
          <div><Layers size={19} /><strong>{loading ? '…' : supabase ? branchTopicCount : '—'}</strong><span>Topics</span></div>
          <div><Target size={19} /><strong>{questionCountLoading ? '…' : questionCount === null ? '—' : questionCount.toLocaleString()}</strong><span>Practice Questions</span></div>
        </div>
        <div className="practice-hero-art" aria-hidden="true"><BookOpen size={84} /><span><Zap size={26} /></span></div>
      </header>
      <div className="practice-subject-toolbar">
        <div className="practice-status-tabs" role="tablist" aria-label="Filter subjects by progress">
          {tabs.map(([label, count]) => <button
            key={label}
            type="button"
            role="tab"
            aria-selected={subjectStatus === label}
            className={`practice-status-tab ${subjectStatus === label ? 'practice-status-tab-active' : ''}`}
            onClick={() => onStatusChange(label)}
          >{label} <span>{count}</span></button>)}
        </div>
        <div className="practice-toolbar-actions">
          <label className="practice-search">
            <Search size={15} />
            <input value={search} onChange={event => onSearchChange(event.target.value)} placeholder="Search subjects..." aria-label="Search subjects" />
          </label>
          <div className="practice-view-toggle" role="group" aria-label="Subject layout">
            <button type="button" className={subjectView === 'list' ? 'practice-view-active' : ''} aria-label="List view" aria-pressed={subjectView === 'list'} onClick={() => onViewChange('list')}><List size={15} /> <span>List</span></button>
            <button type="button" className={subjectView === 'grid' ? 'practice-view-active' : ''} aria-label="Grid view" aria-pressed={subjectView === 'grid'} onClick={() => onViewChange('grid')}><Grid2X2 size={15} /> <span>Grid</span></button>
          </div>
        </div>
      </div>
      {loading && <p className="small px-2 pb-3">Loading your subject catalog...</p>}
      {error && <p className="practice-error" role="alert">{error}</p>}
      {!loading && !subjects.length && <div className="practice-empty">No subjects match these filters. Try another search or progress tab.</div>}
      {subjects.length > 0 && (subjectView === 'list'
        ? <div className="practice-table-wrap">
          <table className="practice-table">
            <thead><tr><th>#</th><th>Subject</th><th>Progress</th><th>Last practiced</th><th>Action</th></tr></thead>
            <tbody>{subjects.map((subject, index) => {
              const status = subjectStatusLabel(subject, selectedBranch?.name || '', subjectProgress);
              const progress = subjectProgress[practiceSubjectKey(selectedBranch?.name || '', subject.name)];
              return <tr key={`${selectedBranch?.name}-${subject.name}`}>
                <td className="practice-number">{String(index + 1).padStart(2, '0')}</td>
                <td><div className="practice-subject-cell"><span className="practice-subject-icon"><SubjectIcon name={subject.name} size={15} /></span><strong>{subject.name}</strong></div></td>
                <td><span className={`practice-status-pill ${status.toLowerCase().replace(' ', '-')}`}><span />{status}</span></td>
                <td>{progress?.lastPracticed ? new Date(progress.lastPracticed).toLocaleDateString(undefined, { month: 'short', day: 'numeric' }) : '—'}</td>
                <td><button className="practice-row-action" type="button" onClick={() => onChooseSubject(subject)}>Practice <ArrowRight size={13} /></button></td>
              </tr>;
            })}</tbody>
          </table>
        </div>
        : <div className="practice-subject-grid">
          {subjects.map((subject, index) => {
            const status = subjectStatusLabel(subject, selectedBranch?.name || '', subjectProgress);
            const progress = subjectProgress[practiceSubjectKey(selectedBranch?.name || '', subject.name)];
            return <article className="practice-subject-card" key={`${selectedBranch?.name}-${subject.name}`}>
              <div className="practice-subject-card-top"><span className="practice-subject-icon"><SubjectIcon name={subject.name} size={17} /></span><span className="practice-number">{String(index + 1).padStart(2, '0')}</span></div>
              <h3>{subject.name}</h3>
              <p>{subject.id ? `${topicCounts[subject.id] || 0} topics` : 'Topics not available yet'}</p>
              <span className={`practice-status-pill ${status.toLowerCase().replace(' ', '-')}`}><span />{status}</span>
              <button className="practice-row-action" type="button" onClick={() => onChooseSubject(subject)}>Practice <ArrowRight size={13} /></button>
              {progress?.lastPracticed && <span className="practice-last-practiced">Last practiced {new Date(progress.lastPracticed).toLocaleDateString()}</span>}
            </article>;
          })}
        </div>)}
    </section>
  </div>;
}

function Dashboard({ user, setPage, onPracticePreferred, preferences }) {
  return <SocialWall user={user} onPreferences={() => setPage('Study Preferences')} leftSidebar={<StudyFocus user={user} preferences={preferences} onPractice={onPracticePreferred} setPage={setPage} />} rightSidebar={<ExamAndProgress user={user} setPage={setPage} />} />;
}

function PracticePage({ user, setPage, setPracticeFilters, focusPreferredSubject }) {
  const [databaseBranches, setDatabaseBranches] = useState([]);
  const [selectedBranchName, setSelectedBranchName] = useState(() => user?.user_metadata?.jobforsure_preferences?.preferredBranch || localStorage.getItem('jobforsure.practice.branch') || 'Mechanical Engineering');
  const [examGoal, setExamGoal] = useState(() => user?.user_metadata?.jobforsure_preferences?.exams?.[0] || localStorage.getItem('jobforsure.practice.exam') || '');
  const [subjectSearch, setSubjectSearch] = useState('');
  const [subjectStatus, setSubjectStatus] = useState('All Subjects');
  const [subjectView, setSubjectView] = useState('list');
  const [topicCounts, setTopicCounts] = useState({});
  const [questionCount, setQuestionCount] = useState(null);
  const [questionCountLoading, setQuestionCountLoading] = useState(false);
  const [subjectProgress, setSubjectProgress] = useState(() => {
    try {
      return JSON.parse(localStorage.getItem(`jobforsure.practice.progress.${user?.id}`) || '{}');
    } catch (error) {
      console.error('Unable to read saved practice progress.', error);
      return {};
    }
  });
  const [activeSubject, setActiveSubject] = useState(null);
  const [topics, setTopics] = useState([]);
  const [activeTopicId, setActiveTopicId] = useState('');
  const [questions, setQuestions] = useState([]);
  const [questionPage, setQuestionPage] = useState(1);
  const [questionTotal, setQuestionTotal] = useState(0);
  const [questionLoading, setQuestionLoading] = useState(false);
  const [questionError, setQuestionError] = useState('');
  const [chosenAnswer, setChosenAnswer] = useState(null);
  const [loading, setLoading] = useState(Boolean(supabase));
  const [error, setError] = useState('');

  useEffect(() => {
    let active = true;
    async function loadPreferences() {
      if (!supabase) { setLoading(false); return; }
      const branchResult = await supabase.from('engineering_branches')
        .select('id,name,code,subjects(id,name,code)')
        .order('name');
      if (!active) return;
      if (branchResult.error) setError(branchResult.error.message);
      else setDatabaseBranches(branchResult.data || []);
      if (user) {
        const { data, error: profileError } = await supabase.from('profiles').select('branch_id').eq('id', user.id).maybeSingle();
        if (!active) return;
        if (profileError) setError(profileError.message);
        else {
          const preferredBranch = branchResult.data?.find(branch => branch.id === data?.branch_id);
          if (preferredBranch && !user.user_metadata?.jobforsure_preferences?.preferredBranch) {
            setSelectedBranchName(preferredBranch.name);
            localStorage.setItem('jobforsure.practice.branch', preferredBranch.name);
          }
        }
      }
      setLoading(false);
    }
    loadPreferences();
    return () => { active = false; };
  }, [user]);

  useEffect(() => {
    if (!supabase || !databaseBranches.length) return undefined;
    let active = true;
    async function loadTopicCounts() {
      const subjectIds = databaseBranches.flatMap(branch => (branch.subjects || []).map(subject => subject.id));
      if (!subjectIds.length) return;
      const { data, error: queryError } = await supabase.from('topics').select('subject_id').in('subject_id', subjectIds);
      if (!active) return;
      if (queryError) {
        setError(queryError.message);
        return;
      }
      setTopicCounts((data || []).reduce((counts, topic) => {
        counts[topic.subject_id] = (counts[topic.subject_id] || 0) + 1;
        return counts;
      }, {}));
    }
    loadTopicCounts();
    return () => { active = false; };
  }, [databaseBranches]);

  useEffect(() => {
    let active = true;
    async function loadTopics() {
      if (!supabase || !activeSubject?.id) { setTopics([]); return; }
      const { data, error: queryError } = await supabase.from('topics').select('id,title,parent_topic_id,display_order').eq('subject_id', activeSubject.id).order('display_order').order('title');
      if (!active) return;
      if (queryError) setQuestionError(queryError.message); else setTopics(data || []);
    }
    loadTopics();
    return () => { active = false; };
  }, [activeSubject?.id]);

  useEffect(() => {
    let active = true;
    async function loadQuestions() {
      if (!supabase || !activeSubject?.id) { setQuestions([]); setQuestionTotal(0); setQuestionLoading(false); return; }
      setQuestionLoading(true);
      setQuestionError('');
      const { data, error: queryError } = await supabase.rpc('get_practice_questions', {
        p_subject_id: activeSubject.id,
        p_topic_id: activeTopicId || null,
        p_page: questionPage,
      });
      if (!active) return;
      if (queryError) setQuestionError(queryError.message);
      else { setQuestions(data?.items || []); setQuestionTotal(data?.total || 0); }
      setQuestionLoading(false);
    }
    loadQuestions();
    return () => { active = false; };
  }, [activeSubject?.id, activeTopicId, questionPage]);

  const branches = practiceBranches.map(fallback => {
    const databaseBranch = databaseBranches.find(branch => fallbackBranch(branch.name)?.name === fallback.name);
    const databaseSubjects = databaseBranch?.subjects || [];
    const subjects = fallback.subjects.map(subject => {
      const match = databaseSubjects.find(row => row.name.toLowerCase() === subject.name.toLowerCase());
      return { ...subject, id: match?.id || null };
    });
    const extraSubjects = databaseSubjects.filter(row => !subjects.some(subject => subject.name.toLowerCase() === row.name.toLowerCase()));
    return { id: databaseBranch?.id || `fallback:${fallback.name}`, name: databaseBranch?.name || fallback.name, subjects: [...subjects, ...extraSubjects] };
  }).concat(databaseBranches.filter(branch => !fallbackBranch(branch.name)).map(branch => ({ ...branch, subjects: branch.subjects || [] })));
  const selectedBranch = branches.find(branch => branch.name === selectedBranchName) || branches[0];
  const branchSubjects = selectedBranch?.subjects || [];
  const normalizedSearch = subjectSearch.trim().toLowerCase();
  const visibleSubjects = branchSubjects.filter(subject => {
    const matchesSearch = subject.name.toLowerCase().includes(normalizedSearch);
    const status = subjectStatusLabel(subject, selectedBranch?.name || '', subjectProgress);
    const matchesStatus = subjectStatus === 'All Subjects' || status === subjectStatus;
    return matchesSearch && matchesStatus;
  });
  const branchTopicCount = branchSubjects.reduce((count, subject) => count + (topicCounts[subject.id] || 0), 0);
  const branchSubjectIds = branchSubjects.map(subject => subject.id).filter(Boolean);
  const branchSubjectIdKey = branchSubjectIds.join(',');

  useEffect(() => {
    let active = true;
    async function loadBranchQuestionCount() {
      if (!supabase || !branchSubjectIds.length) {
        setQuestionCount(null);
        setQuestionCountLoading(false);
        return;
      }
      setQuestionCountLoading(true);
      const { count, error: countError } = await supabase
        .from('practice_questions')
        .select('id', { count: 'exact', head: true })
        .in('subject_id', branchSubjectIds)
        .eq('is_published', true);
      if (!active) return;
      if (countError) {
        setError(countError.message);
        setQuestionCount(null);
      } else {
        setQuestionCount(count);
      }
      setQuestionCountLoading(false);
    }
    loadBranchQuestionCount();
    return () => { active = false; };
  }, [branchSubjectIdKey]);
  const sample = activeSubject && mechanicalSubjects.find(subject => subject.name.toLowerCase() === activeSubject.name.toLowerCase());
  const preferences = user?.user_metadata?.jobforsure_preferences || {};

  useEffect(() => {
    if (loading) return;
    if (focusPreferredSubject) {
      const preferredBranch = branches.find(branch => branch.name === preferences.preferredBranch);
      const preferredSubject = preferredBranch?.subjects.find(subject => subject.name.toLowerCase() === preferences.preferredSubject?.toLowerCase());
      if (preferredBranch && preferredSubject) {
        setSelectedBranchName(preferredBranch.name);
        setActiveSubject(preferredSubject);
      }
    } else {
      setActiveSubject(null);
      setActiveTopicId('');
      setQuestionPage(1);
      setChosenAnswer(null);
    }
  }, [focusPreferredSubject, loading, preferences.preferredBranch, preferences.preferredSubject, databaseBranches]);

  async function chooseBranch(branch) {
    setSelectedBranchName(branch.name);
    setActiveSubject(null);
    setActiveTopicId('');
    setQuestionPage(1);
    setChosenAnswer(null);
    localStorage.setItem('jobforsure.practice.branch', branch.name);

  }

  function chooseExamGoal(value) {
    setExamGoal(value);
    localStorage.setItem('jobforsure.practice.exam', value);
  }

  function browseTests() {
    setPracticeFilters({ subjectId: activeSubject?.id || null, examType: examGoal });
    setPage('Mock Tests');
  }

  function chooseSubject(subject) {
    setActiveSubject(subject);
    setActiveTopicId('');
    setQuestionPage(1);
    setChosenAnswer(null);
    setQuestionError('');
  }

  function returnToSubjects() {
    setActiveSubject(null);
    setActiveTopicId('');
    setQuestionPage(1);
    setChosenAnswer(null);
    setQuestionError('');
  }

  function updateSubjectStatus(subject, status) {
    const key = practiceSubjectKey(selectedBranch?.name || '', subject.name);
    const next = {
      ...subjectProgress,
      [key]: { status, lastPracticed: new Date().toISOString() },
    };
    setSubjectProgress(next);
    try {
      localStorage.setItem(`jobforsure.practice.progress.${user?.id}`, JSON.stringify(next));
    } catch (error) {
      setError(error instanceof Error ? error.message : 'Unable to save subject progress on this device.');
    }
  }

  function markSubjectCompleted() {
    if (!activeSubject) return;
    updateSubjectStatus(activeSubject, 'Completed');
    returnToSubjects();
  }

  return activeSubject ? <div className="practice-focused mx-auto max-w-4xl space-y-4">
    <div className="flex flex-wrap items-center justify-between gap-3"><button className="btn" onClick={returnToSubjects}><ArrowLeft size={14} /> All subjects</button><div className="flex items-center gap-2"><span className="small">{selectedBranch?.name} · {examGoal || 'All exams'}</span><button className="btn" onClick={markSubjectCompleted}><Check size={14} /> Mark complete</button></div></div>
    <header className="flex flex-wrap items-end justify-between gap-3 border-b border-slate-200 pb-4"><div><div className="eyebrow">FOCUSED PRACTICE</div><h2 className="mt-1 text-xl font-extrabold">{activeSubject.name}</h2><p className="small mt-1">{supabase ? `${questionTotal} questions · 15 per page` : `${sample ? 1 : 0} demo questions`}</p></div>{supabase && activeSubject.id && <label className="text-xs font-semibold text-slate-600">Topic<select className="field mt-1 min-w-56" value={activeTopicId} onChange={event => { setActiveTopicId(event.target.value); setQuestionPage(1); }}><option value="">All topics</option>{topics.map(topic => <option key={topic.id} value={topic.id}>{topic.parent_topic_id ? '↳ ' : ''}{topic.title}</option>)}</select></label>}</header>
    {!supabase && sample && <Card className="p-4"><span className="pill pill-green">DEMO QUESTION</span><p className="mt-3 text-sm font-semibold leading-6">{sample.question}</p><div className="mt-4 grid gap-2 sm:grid-cols-2">{sample.options.map((option, index) => <button key={option} className={`rounded-md border p-3 text-left text-xs ${chosenAnswer === index ? index === sample.answer ? 'border-emerald-500 bg-emerald-50 text-emerald-800' : 'border-rose-300 bg-rose-50 text-rose-800' : 'border-slate-200 hover:bg-slate-50'}`} onClick={() => setChosenAnswer(index)}>{String.fromCharCode(65 + index)}. {option}</button>)}</div>{chosenAnswer !== null && <p className={`mt-4 text-xs leading-5 ${chosenAnswer === sample.answer ? 'text-emerald-800' : 'text-rose-800'}`} role="status"><b>{chosenAnswer === sample.answer ? 'Correct.' : 'Not quite.'}</b> {sample.explanation}</p>}<p className="small mt-4">Demo only. Connect the question database to practice saved questions.</p></Card>}
    {!supabase && !sample && <Card className="p-4"><p className="small">No demo questions are available for this subject yet.</p></Card>}
    {supabase && !activeSubject.id && <Card className="p-4"><p className="text-sm font-bold">This subject is not in the database catalog yet.</p><p className="small mt-2">Add it under this branch in Subjects to load topics and questions.</p></Card>}
    {supabase && activeSubject.id && questionLoading && <Card className="p-4"><p className="small">Loading questions...</p></Card>}
    {supabase && activeSubject.id && questionError && <Card className="p-4"><p className="text-xs text-rose-700" role="alert">{questionError}</p><p className="small mt-2">Apply the secure practice-question SQL functions to enable question loading and grading.</p></Card>}
    {supabase && activeSubject.id && !questionLoading && !questionError && questions.length === 0 && <Card className="p-4"><p className="text-sm font-bold">No questions available for this selection.</p><p className="small mt-2">Choose another topic or check back after questions are added.</p></Card>}
    {supabase && !questionError && questions.map((question, index) => <PracticeQuestionCard key={question.id} question={question} user={user} number={(questionPage - 1) * 15 + index + 1} />)}
    {supabase && !questionError && questionTotal > 0 && <div className="flex items-center justify-between gap-3"><button className="btn" disabled={questionPage <= 1 || questionLoading} onClick={() => setQuestionPage(page => page - 1)}>Previous</button><span className="small">Page {questionPage} of {Math.ceil(questionTotal / 15)}</span><button className="btn" disabled={questionPage >= Math.ceil(questionTotal / 15) || questionLoading} onClick={() => setQuestionPage(page => page + 1)}>Next</button></div>}
    {error && <p className="text-xs text-rose-700" role="alert">{error}</p>}
  </div> : <PracticeSubjectBrowser
    branches={branches}
    selectedBranch={selectedBranch}
    examGoal={examGoal}
    onExamChange={chooseExamGoal}
    onChooseBranch={chooseBranch}
    subjectStatus={subjectStatus}
    onStatusChange={setSubjectStatus}
    subjectView={subjectView}
    onViewChange={setSubjectView}
    search={subjectSearch}
    onSearchChange={setSubjectSearch}
    subjects={visibleSubjects}
    branchSubjects={branchSubjects}
    topicCounts={topicCounts}
    branchTopicCount={branchTopicCount}
    questionCount={questionCount}
    questionCountLoading={questionCountLoading}
    subjectProgress={subjectProgress}
    onChooseSubject={subject => {
      updateSubjectStatus(subject, 'In Progress');
      chooseSubject(subject);
    }}
    loading={loading}
    error={error}
  />;
}

function PracticeQuestionCard({ question, user, number }) {
  const [answer, setAnswer] = useState('');
  const [result, setResult] = useState(null);
  const [error, setError] = useState('');
  const [busy, setBusy] = useState(false);
  const choices = Array.isArray(question.options) ? question.options.map((option, index) => {
    if (typeof option === 'string') return { value: option, label: option };
    const value = String(option.value ?? option.key ?? option.id ?? option.label ?? index + 1);
    return { value, label: String(option.text ?? option.label ?? option.value ?? value) };
  }) : [];

  async function submitAnswer(event) {
    event.preventDefault();
    if (!user) { setError('Sign in to submit and save your answer.'); return; }
    if (!answer.trim()) { setError('Enter or select an answer first.'); return; }
    setBusy(true); setError('');
    const { data, error: submitError } = await supabase.rpc('submit_practice_answer', {
      p_question_id: question.id,
      p_submitted_answer: answer.trim(),
    });
    if (submitError) setError(submitError.message); else setResult(data);
    setBusy(false);
  }

  return <article className="rounded-lg border border-slate-200 bg-white p-4 sm:p-5"><div className="flex flex-wrap items-center gap-2"><span className="eyebrow">QUESTION {number}</span>{question.difficulty && <span className="pill">{question.difficulty}</span>}{question.question_date && <span className="small">{question.question_date}</span>}</div><h4 className="mt-3 text-sm font-semibold leading-6">{question.question_text}</h4><form className="mt-4" onSubmit={submitAnswer}>{question.question_type === 'mcq' && choices.length ? <fieldset className="grid gap-2 sm:grid-cols-2"><legend className="sr-only">Choose an answer</legend>{choices.map((choice, index) => <label key={`${question.id}-${index}`} className="flex cursor-pointer items-center gap-2 rounded-md border border-slate-200 p-3 text-xs hover:bg-slate-50"><input type="radio" name={`answer-${question.id}`} value={choice.value} checked={answer === choice.value} onChange={() => { setAnswer(choice.value); setResult(null); }} />{choice.label}</label>)}</fieldset> : <input className="field max-w-md" aria-label={`Answer to question ${number}`} type={question.question_type === 'numerical' ? 'number' : 'text'} step={question.question_type === 'numerical' ? 'any' : undefined} placeholder={question.question_type === 'numerical' ? 'Enter a numerical answer' : 'Enter your answer'} value={answer} onChange={event => { setAnswer(event.target.value); setResult(null); }} />}
      <div className="mt-3 flex flex-wrap items-center gap-3"><button className="btn btn-primary" disabled={busy}>{busy ? 'Checking...' : 'Submit answer'}</button>{!user && <span className="small">Sign in to save answers and earn points.</span>}</div></form>{error && <p className="mt-3 text-xs text-rose-700" role="alert">{error}</p>}{result && <div className={`mt-4 rounded-md p-3 text-xs leading-5 ${result.is_correct ? 'bg-emerald-50 text-emerald-800' : 'bg-amber-50 text-amber-900'}`} role="status"><b>{result.is_correct ? 'Correct' : 'Not quite'}</b>{result.is_correct && result.score > 0 ? ` · +${result.score} points` : ''}{result.explanation && <p className="mt-1">{result.explanation}</p>}</div>}</article>;
}

function NotificationsPage({ user, setPage }) {
  const [exams, setExams] = useState([]);
  const [reminders, setReminders] = useState(new Set());
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [busyId, setBusyId] = useState('');
  const upcomingNotices = upcomingExamNotices.filter(notice => new Date(notice.lastExamDate).getTime() >= Date.now());
  useEffect(() => {
    let active = true;
    async function load() {
      if (!supabase) { setLoading(false); return; }
      const [examResult, reminderResult] = await Promise.all([
        supabase.from('exams').select('id,name,exam_type,conducting_body,description,notification_date,application_start_date,application_end_date,exam_date,official_url,notification_url,status').order('exam_date', { ascending: true, nullsFirst: false }),
        user ? supabase.from('exam_reminders').select('exam_id').eq('student_id', user.id).eq('is_active', true) : Promise.resolve({ data: [], error: null }),
      ]);
      if (!active) return;
      if (examResult.error) setError(examResult.error.message); else setExams(examResult.data || []);
      if (reminderResult.error) setError(reminderResult.error.message); else setReminders(new Set((reminderResult.data || []).map(row => row.exam_id)));
      setLoading(false);
    }
    load();
    return () => { active = false; };
  }, [user]);
  async function toggleReminder(exam) {
    if (!user) { setError('Sign in to save exam reminders.'); return; }
    setBusyId(exam.id); setError('');
    const enabled = reminders.has(exam.id);
    const result = enabled
      ? await supabase.from('exam_reminders').delete().eq('student_id', user.id).eq('exam_id', exam.id)
      : await supabase.from('exam_reminders').upsert({ student_id: user.id, exam_id: exam.id, is_active: true }, { onConflict: 'student_id,exam_id' });
    if (result.error) setError(result.error.message);
    else setReminders(previous => { const next = new Set(previous); enabled ? next.delete(exam.id) : next.add(exam.id); return next; });
    setBusyId('');
  }
  return <div className="space-y-5">
    <section className="upcoming-exams-section">
      <header className="job-notices-header">
        <div>
          <span className="eyebrow">UPCOMING EXAM EVENTS</span>
          <h2 className="mt-1 text-lg font-extrabold">Upcoming exams &amp; selection dates</h2>
          <p className="small mt-1">Future-dated exam notices from FreeJobAlert. Past events are hidden.</p>
        </div>
        <a className="upcoming-exams-all-link" href="https://www.freejobalert.com/admit-card/" target="_blank" rel="noreferrer">
          Browse full listing <ExternalLink size={13} />
        </a>
      </header>
      {upcomingNotices.length ? <div className="upcoming-exams-list">
        {upcomingNotices.map(notice => <article className="upcoming-exam-card" key={notice.id}>
          <div className="upcoming-exam-date"><CalendarDays size={17} /><span><small>{notice.stage}</small><b>{notice.dateLabel}</b></span></div>
          <div className="upcoming-exam-description">
            <span className="pill">{notice.organization}</span>
            <h3>{notice.title}</h3>
            <p>{notice.summary}</p>
          </div>
          <a className="job-notice-link" href={notice.source} target="_blank" rel="noreferrer">
            View notice <ExternalLink size={13} />
          </a>
        </article>)}
      </div> : <p className="upcoming-exams-empty">There are no future-dated notices in this checked selection. Visit FreeJobAlert for newly published updates.</p>}
      <p className="job-notices-disclaimer">Checked 15 Oct 2026. This is a recent-feed selection, not a complete live sync; verify schedules and instructions with the conducting authority.</p>
    </section>
    <section className="job-notices-section">
      <header className="job-notices-header">
        <div>
          <span className="eyebrow">CAREER OPPORTUNITIES</span>
          <h2 className="mt-1 text-lg font-extrabold">Latest job notifications</h2>
          <p className="small mt-1">A selection of recent openings and fellowships · checked 15 Oct 2026</p>
        </div>
        <span className="job-notices-icon"><Briefcase size={19} /></span>
      </header>
      <div className="job-notices-list">
        {latestJobNotices.map(notice => <article className="job-notice-card" key={notice.id}>
          <div className="job-notice-main">
            <div className="job-notice-labels"><span className="pill pill-green">{notice.category}</span><span className="job-notice-location"><MapPin size={12} />{notice.location}</span></div>
            <h3>{notice.title}</h3>
            <p className="job-notice-org">{notice.organization}</p>
            <p className="job-notice-details">{notice.details}</p>
          </div>
          <div className="job-notice-actions">
            <span className="job-notice-deadline"><CalendarDays size={14} /><span><small>Deadline / event</small><b>{notice.deadline}</b></span></span>
            <a className="job-notice-link" href={notice.source} target="_blank" rel="noreferrer">
              View source <ExternalLink size={13} />
            </a>
          </div>
        </article>)}
      </div>
      <p className="job-notices-disclaimer">Summaries link to FreeJobAlert for details. Verify eligibility, dates, and application instructions in the official recruitment notice before applying.</p>
    </section>
    <Card>
    <div className="card-head"><div><b>Exam notifications</b><p className="small mt-1">Dates and reminders from the exams catalogue</p></div><Bell size={18} className="text-indigo-600" /></div>
    {loading && <p className="p-5 small">Loading exams...</p>}{!loading && !exams.length && <p className="p-5 small">No exams are published yet.</p>}
    <div className="divide-y divide-slate-100">{exams.map(exam => <article key={exam.id} className="p-4 sm:p-5"><div className="flex flex-wrap items-start justify-between gap-3"><div><div className="flex flex-wrap items-center gap-2"><h2 className="text-sm font-bold">{exam.name}</h2><span className="pill">{exam.exam_type}</span><span className="pill">{exam.status.replaceAll('_', ' ')}</span></div>{exam.conducting_body && <p className="small mt-1">{exam.conducting_body}</p>}{exam.description && <p className="mt-2 max-w-3xl text-sm leading-6 text-slate-600">{exam.description}</p>}</div><button className="btn" disabled={busyId === exam.id} onClick={() => toggleReminder(exam)}>{reminders.has(exam.id) ? <Check size={14} /> : <Bell size={14} />}{reminders.has(exam.id) ? 'Reminder on' : 'Remind me'}</button></div>
      <div className="mt-4 grid gap-3 text-xs sm:grid-cols-3">{[['Applications open', exam.application_start_date], ['Application deadline', exam.application_end_date], ['Exam date', exam.exam_date]].map(([label, value]) => <div key={label} className="flex items-center gap-2"><CalendarDays size={14} className="text-slate-400" /><span><span className="block text-slate-500">{label}</span><b className="mt-1 block">{value ? new Date(`${value}T00:00:00`).toLocaleDateString() : 'Not announced'}</b></span></div>)}</div>
      {(exam.official_url || exam.notification_url) && <div className="mt-4 flex gap-4 text-xs font-bold text-indigo-700">{exam.official_url && <a href={exam.official_url} target="_blank" rel="noreferrer">Official site</a>}{exam.notification_url && <a href={exam.notification_url} target="_blank" rel="noreferrer">Notification</a>}</div>}
    </article>)}</div>
    {error && <p className="px-5 pb-4 text-xs text-rose-700" role="alert">{error}</p>}{!user && supabase && <p className="px-5 pb-4 small">Sign in to keep reminders linked to your account.</p>}{!supabase && <p className="p-5 small">Connect Supabase to load exams and save reminders.</p>}
  </Card><button className="btn" onClick={() => setPage('Mock Tests')}><GraduationCap size={14} /> Browse mock tests</button></div>;
}

function TutorialsPage({ user }) {
  const [tutorialBranch, setTutorialBranch] = useState(user?.user_metadata?.jobforsure_preferences?.preferredBranch || 'All branches');
  const [tutorials, setTutorials] = useState([]);
  const [progress, setProgress] = useState({});
  const [selectedId, setSelectedId] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  useEffect(() => {
    let active = true;
    async function load() {
      if (!supabase) { setLoading(false); return; }
      const { data, error: queryError } = await supabase.from('tutorials').select('id,title,content,code_example,equation_latex,video_url,difficulty,estimated_minutes,topic_id,topics(title,subjects(name,engineering_branches(name)))').eq('is_published', true).order('created_at', { ascending: false });
      if (!active) return;
      if (queryError) setError(queryError.message); else { const relevant = data || []; setTutorials(relevant); setSelectedId(current => relevant.some(item => item.id === current) ? current : relevant[0]?.id || ''); }
      if (user) {
        const { data: rows, error: progressError } = await supabase.from('student_progress').select('tutorial_id,status,progress_percent').eq('student_id', user.id);
        if (!active) return;
        if (progressError) setError(progressError.message); else setProgress(Object.fromEntries((rows || []).map(row => [row.tutorial_id, row])));
      }
      setLoading(false);
    }
    load(); return () => { active = false; };
  }, [user]);
  const visibleTutorials = tutorials.filter(item => tutorialBranch === 'All branches' || item.topics?.subjects?.engineering_branches?.name === tutorialBranch);
  const selected = visibleTutorials.find(item => item.id === selectedId) || visibleTutorials[0];
  async function updateProgress(status, percent) {
    if (!user || !selected) { setError('Sign in to save tutorial progress.'); return; }
    const row = { student_id: user.id, tutorial_id: selected.id, status, progress_percent: percent, last_accessed_at: new Date().toISOString() };
    const { error: saveError } = await supabase.from('student_progress').upsert(row, { onConflict: 'student_id,tutorial_id' });
    if (saveError) setError(saveError.message); else setProgress(previous => ({ ...previous, [selected.id]: row }));
  }
  return <div className="grid items-start gap-4 lg:grid-cols-[minmax(220px,0.8fr)_minmax(0,2fr)]"><Card>
    <div className="card-head"><div><b>Published tutorials</b><p className="small mt-1">Browse by topic</p><label className="sr-only" htmlFor="tutorial-branch">Tutorial branch</label><select id="tutorial-branch" className="field mt-2" value={tutorialBranch} onChange={event => { setTutorialBranch(event.target.value); setSelectedId(''); }}>{[...new Set(['All branches', ...practiceBranches.map(item => item.name), ...tutorials.map(item => item.topics?.subjects?.engineering_branches?.name).filter(Boolean)])].map(branch => <option key={branch}>{branch}</option>)}</select></div><BookOpen size={17} className="text-indigo-600" /></div>
    {loading && <p className="p-4 small">Loading tutorials...</p>}{!loading && !visibleTutorials.length && <p className="p-4 small">No published tutorials yet.</p>}
    <div className="divide-y divide-slate-100">{visibleTutorials.map(item => <button key={item.id} className={`block w-full p-4 text-left hover:bg-slate-50 ${item.id === selectedId ? 'bg-indigo-50/70' : ''}`} onClick={() => setSelectedId(item.id)}><span className="block text-xs font-bold">{item.title}</span><span className="small mt-1 block">{item.topics?.subjects?.name || 'Engineering'} · {item.topics?.title || 'Topic'}</span>{progress[item.id] && <span className="mt-2 block text-[10px] font-bold text-emerald-700">{progress[item.id].progress_percent}% complete</span>}</button>)}</div>
  </Card><Card>{!selected ? <div className="p-6"><h2 className="text-sm font-bold">Tutorial reader</h2><p className="small mt-2">{supabase ? 'Choose a published tutorial to begin.' : 'Connect Supabase to load published tutorials.'}</p></div> : <article className="p-5 sm:p-7"><div className="eyebrow">{selected.topics?.subjects?.name || 'ENGINEERING'} · {selected.topics?.title || 'TUTORIAL'}</div><h2 className="mt-2 text-xl font-extrabold">{selected.title}</h2><div className="mt-3 flex gap-2"><span className="pill">{selected.difficulty}</span>{selected.estimated_minutes && <span className="pill">{selected.estimated_minutes} min</span>}</div><div className="mt-6 whitespace-pre-wrap text-sm leading-7 text-slate-700">{selected.content}</div>{selected.equation_latex && <pre className="terminal mt-5">{selected.equation_latex}</pre>}{selected.code_example && <pre className="terminal mt-4">{selected.code_example}</pre>}{selected.video_url && <a className="mt-4 inline-block text-xs font-bold text-indigo-700" href={selected.video_url} target="_blank" rel="noreferrer">Open video lesson</a>}<div className="mt-7 flex flex-wrap gap-2 border-t border-slate-100 pt-4"><button className="btn" onClick={() => updateProgress('in_progress', Math.max(progress[selected.id]?.progress_percent || 0, 50))}>Mark in progress</button><button className="btn btn-primary" onClick={() => updateProgress('completed', 100)}><Check size={14} /> Mark complete</button></div></article>}{error && <p className="px-5 pb-4 text-xs text-rose-700" role="alert">{error}</p>}</Card></div>;
}

function SimulationsPage({ user, filters }) {
  const [tests, setTests] = useState([]);
  const [popularity, setPopularity] = useState({});

  const [mockSubjects, setMockSubjects] = useState([]);
  const [mockBranches, setMockBranches] = useState([]);
  const [selectedBranch, setSelectedBranch] = useState(() => {
    try { return user?.user_metadata?.jobforsure_preferences?.preferredBranch || DEFAULT_BRANCH; }
    catch { return DEFAULT_BRANCH; }
  });
  const [testSearch, setTestSearch] = useState('');
  const [selectedExam, setSelectedExam] = useState(null);
  const mockResultsRef = useRef(null);
  const [examFamily, setExamFamily] = useState('All Exams');
  const [attempt, setAttempt] = useState(null);
  const [answers, setAnswers] = useState({});
  const [examState, setExamState] = useState({});
  const [savedAttempts, setSavedAttempts] = useState([]);
  const [saveStatus, setSaveStatus] = useState('');
  const [restartTest, setRestartTest] = useState(null);
  const deadline = useRef(0);
  const attemptRef = useRef(null);
  const saveQueue = useRef(Promise.resolve());
  const canQuitTestingMocks = user?.email?.toLowerCase() === 'testnaushad@gmail.com';
  const closeTestingAttempts = React.useCallback(() => {
    attemptRef.current = null;
    setAttempt(null); setAnswers({}); setExamState({}); setSaveStatus('');
    setSavedAttempts([]); setResult(null); setReviewAttempt(null);
    setHistoryOpen(false); setRestartTest(null); setError('');
    setHistoryRefresh(value => value + 1);
    window.scrollTo(0, 0);
  }, []);
  const [result, setResult] = useState(null);
  const [historyRefresh, setHistoryRefresh] = useState(0);
  useEffect(() => {
    let active = true;
    if (supabase) supabase.rpc('mock_popularity').then(({data, error}) => {
      if (active && !error) setPopularity(Object.fromEntries((data || []).map(row => [row.mock_test_id, row])));
    }).catch(() => {});
    return () => { active = false; };
  }, [historyRefresh]);
  const [historyOpen, setHistoryOpen] = useState(false);
  const [reviewAttempt, setReviewAttempt] = useState(null);
  function openReview(row) { setHistoryOpen(false); setReviewAttempt(row); window.scrollTo(0, 0); }
  const closeAttemptHistory = React.useCallback(() => setHistoryOpen(false), []);
  const [remaining, setRemaining] = useState(0);
  const [loading, setLoading] = useState(true);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState('');
  useEffect(() => {
    let active = true;
    async function loadTests() {
      setLoading(true);
      if (!supabase) { setLoading(false); return; }
      let query = supabase.from('mock_tests').select('id,title,description,exam_type,subject_id,duration_minutes,total_marks,passing_marks').eq('is_published', true);
      const [testResult, subjectResult, branchResult] = await Promise.all([
        query.order('created_at', { ascending: false }),
        supabase.from('subjects').select('id,name,branch_id'),
        supabase.from('engineering_branches').select('id,name').order('name'),
      ]);
      if (!active) return;
      const queryError = testResult.error || subjectResult.error || branchResult.error;
      if (queryError) { setTests([]); setError(queryError.message); }
      else {
        setError('');
        setTests((testResult.data || []).filter(test => !isLinkedPaperMock(test)));
        setMockSubjects(subjectResult.data || []);
        setMockBranches(branchResult.data || []);
      }
      setLoading(false);
    }
    loadTests();
    return () => { active = false; };
  }, [filters.subjectId, filters.examType]);
  useEffect(() => {
    let active = true;
    setSavedAttempts([]);
    if (!supabase || !user) return () => { active = false; };
    supabase.rpc('get_saved_mock_attempts').then(({ data, error: savedError }) => {
      if (!active) return;
      if (savedError) setError('Saved tests are unavailable. ' + savedError.message);
      else setSavedAttempts(data || []);
    });
    return () => { active = false; };
  }, [user?.id, historyRefresh]);
  useEffect(() => {
    if (!attempt) return undefined;
    const timer = setInterval(() => setRemaining(Math.max(0, Math.ceil((deadline.current - Date.now()) / 1000))), 1000);
    const warn = event => { event.preventDefault(); event.returnValue = ''; };
    window.addEventListener('beforeunload', warn);
    return () => { clearInterval(timer); window.removeEventListener('beforeunload', warn); };
  }, [attempt]);
  useEffect(() => { if (attempt && remaining === 0 && !busy) submitAttempt(); }, [attempt, remaining, busy]);
  // Serialize saves so that a delayed autosave cannot overwrite the pause snapshot.
  function queueSave(pause = false) {
    const captured = attempt;
    const payload = { p_attempt_id: captured.attempt_id, p_session_token: captured.session_token,
      p_answers: Object.fromEntries(Object.entries(answers).filter(([,v]) => String(v).trim() !== '')),
      p_state: examState, p_pause: pause };
    const request = saveQueue.current.catch(() => {}).then(async () => {
      if (attemptRef.current?.session_token !== captured.session_token) return null;
      const { data, error: saveError } = await supabase.rpc('save_mock_attempt', payload);
      if (saveError) throw new Error(saveError.message);
      return data;
    });
    saveQueue.current = request;
    return request;
  }
  useEffect(() => {
    if (!attempt || busy) return undefined;
    setSaveStatus('Saving answers...');
    const timer = setTimeout(() => {
      queueSave().then(data => { if (data) setSaveStatus('Answers saved'); }).catch(e => {
        setSaveStatus('Not saved - check your connection'); setError(e.message);
      });
    }, isSscCgl(attempt.test_title) ? 0 : 700);
    return () => clearTimeout(timer);
  }, [attempt, answers, examState, busy]);
  useEffect(() => () => { attemptRef.current = null; }, []);
  useEffect(() => {
    if (!canQuitTestingMocks || !supabase) return;
    let active = true, running = false;
    const key = `jobforsure:testing-mocks-quit:${user.id}`;
    const sync = event => { if (event.key === key) closeTestingAttempts(); };
    // Also detect cleanup from another browser/device, where storage events do not reach.
    const check = async () => {
      const captured = attemptRef.current;
      if (!captured || running) return;
      running = true;
      try {
        const { data, error: checkError } = await supabase.rpc('get_saved_mock_attempts');
        if (active && !checkError && attemptRef.current?.attempt_id === captured.attempt_id
          && !(data || []).some(item => item.attempt_id === captured.attempt_id)) closeTestingAttempts();
      } catch { /* Keep the current exam on transient connection errors. */ }
      finally { running = false; }
    };
    window.addEventListener('storage', sync);
    const interval = setInterval(check, 5000);
    return () => { active = false; clearInterval(interval); window.removeEventListener('storage', sync); };
  }, [canQuitTestingMocks, user?.id, closeTestingAttempts]);
  async function quitTestingAttempts() {
    if (!canQuitTestingMocks || busy) return;
    setBusy(true); setError('');
    const captured = attemptRef.current;
    // Invalidate queued autosaves before deleting their attempt rows.
    attemptRef.current = null;
    try {
      await saveQueue.current.catch(() => {});
      const { error: quitError } = await supabase.rpc('quit_testing_mock_attempts');
      if (quitError) throw new Error(quitError.message);
      closeTestingAttempts();
      try { localStorage.setItem(`jobforsure:testing-mocks-quit:${user.id}`, `${Date.now()}-${Math.random()}`); }
      catch { /* Other instances still detect the deletion through polling. */ }
    } catch (e) {
      attemptRef.current = captured;
      setError('Could not quit testing attempts. ' + e.message);
    } finally { setBusy(false); }
  }
  async function start(test, savedId = null, restart = false) {
    if (!user) { setError('Sign in before starting a simulation.'); return; }
    setBusy(true); setError(''); setResult(null);
    const { data, error: startError } = await supabase.rpc('open_mock_attempt', {
      p_mock_test_id: test.id, p_attempt_id: savedId, p_restart: restart,
    });
    if (startError) setError(startError.message);
    else if (data.status === 'expired') { setError('This saved attempt has run out of time. Start the test again.'); setHistoryRefresh(value => value + 1); }
    else {
      attemptRef.current = data;
      deadline.current = Date.now() + data.remaining_seconds * 1000;
      setAnswers(data.answers || {}); setExamState(data.exam_state || {});
      setSaveStatus('Answers saved'); setRemaining(data.remaining_seconds); setAttempt(data);
      setRestartTest(null);
    }
    setBusy(false);
  }
  async function pauseAttempt() {
    if (!attempt || busy || remaining <= 0) return;
    setBusy(true); setError('');
    try {
      const data = await queueSave(true);
      if (!data) throw new Error('The exam session changed. Please try again.');
      attemptRef.current = null; setAttempt(null); setSaveStatus('');
      setHistoryRefresh(value => value + 1);
    } catch (e) { setError('Could not pause. Your exam is still running. ' + e.message); }
    setBusy(false);
  }
  async function submitAttempt() {
    if (!attempt || busy) return;
    setBusy(true); setError('');
    const payload = Object.entries(answers).filter(([, value]) => String(value).trim() !== '').map(([question_id, selected_answer]) => ({ question_id, selected_answer }));
    await saveQueue.current.catch(() => {});
    const { data, error: submitError } = await supabase.rpc('submit_saved_mock_attempt', { p_attempt_id: attempt.attempt_id, p_session_token: attempt.session_token, p_answers: payload });
    if (submitError) setError(submitError.message); else {
      const completed = attempt;
      setResult({ ...data, attempt_id: completed.attempt_id, title: completed.test_title, total_marks: completed.total_marks });
      attemptRef.current = null; setAttempt(null); setHistoryRefresh(value => value + 1);
      const { data: history } = await supabase.rpc('get_mock_attempt_history', { p_attempt_id: completed.attempt_id, p_limit: 1, p_offset: 0 });
      if (history?.[0]) setResult(history[0]);
    }
    setBusy(false);
  }
  const clock = `${String(Math.floor(remaining / 60)).padStart(2, '0')}:${String(remaining % 60).padStart(2, '0')}`;
  const getCategory = test => examCatalog.find(e=>e.id===mockExamId(test))?.name || 'Other Exams';
  const activeExam = examCatalog.find(e=>e.id===selectedExam);
  const examTests = tests.filter(t=>mockExamId(t)===selectedExam);
  const branchOptions = getBranchOptions(examTests, mockSubjects, mockBranches);
  const activeBranch = selectedBranch;
  const visibleTests = examTests.filter(test => {
    const branchMatch = !activeExam?.branches || matchesMockBranch(test, activeBranch, mockSubjects, mockBranches);
    const query = testSearch.trim().toLowerCase();
    return branchMatch && (!query || `${test.title} ${test.description || ''} ${getMockBranch(test,mockSubjects,mockBranches)}`.toLowerCase().includes(query));
  });
  const explorerCards = examCatalog.map(exam=>({...exam, tests:tests.filter(t=>mockExamId(t)===exam.id)})).filter(exam=>{
    if(examFamily!=='All Exams' && exam.family!==examFamily)return false;
    const query=testSearch.trim().toLowerCase();
    return !query || `${exam.name} ${exam.family} ${exam.description}`.toLowerCase().includes(query) || exam.tests.some(t=>`${t.title} ${t.description||''}`.toLowerCase().includes(query));
  });
  function openExam(id) {setSelectedExam(id);setSelectedBranch(ALL_BRANCHES);setTestSearch('');}
  if (reviewAttempt) return <div className="space-y-4"><h2 className="text-xl font-bold">{reviewAttempt.title}</h2><MockTestReview supabase={supabase} attemptId={reviewAttempt.attempt_id} onClose={() => { setReviewAttempt(null); setResult(null); setHistoryOpen(false); window.scrollTo(0, 0); }} onBack={() => { setResult(reviewAttempt); setReviewAttempt(null); window.scrollTo(0, 0); }} /></div>;
  return <div className="space-y-4">{attempt ? <MockExam key={attempt.session_token} attempt={attempt} onPause={pauseAttempt} onQuit={canQuitTestingMocks ? quitTestingAttempts : undefined} onStateChange={setExamState} saveStatus={saveStatus} answers={answers} setAnswers={setAnswers} clock={clock} remainingSeconds={remaining} busy={busy} onSubmit={submitAttempt} error={error} /> : <>
    {result && <AttemptScorecard result={result} supabase={supabase} onReview={openReview} onClose={() => setResult(null)} />}

    <section className="exam-explorer">
      <div className="explorer-heading"><div>{activeExam&&<button className="explorer-back" onClick={()=>{setSelectedExam(null);setTestSearch('');}}><ArrowLeft size={15}/> All exams</button>}<h2>{activeExam?activeExam.name:'Mock Tests'}</h2><p>{activeExam?'Choose a mock and start your next practice session.':'Discover full-length mocks, sectional tests and exam practice.'}</p></div><button className="btn" aria-expanded={historyOpen} aria-controls="mock-attempt-history" onClick={()=>setHistoryOpen(v=>!v)}><Clock3 size={15}/> My attempts</button></div>
      <MockAttemptHistory onReview={openReview} open={historyOpen} supabase={supabase} user={user} refresh={historyRefresh} onClose={closeAttemptHistory}/>
      <label className="explorer-search"><Search size={18}/><input value={testSearch} onChange={e=>setTestSearch(e.target.value)} placeholder={activeExam?'Search mock tests in this exam':'Search exams, subjects or mock tests (e.g. TGPSC AEE, SSC CGL, GATE)'} aria-label="Search exams or mock tests"/></label>
      {!activeExam ? <>
        <div className="explorer-filters" role="group" aria-label="Exam categories">{examFamilies.map(family=><button key={family} aria-pressed={examFamily===family} onClick={()=>setExamFamily(family)} className={examFamily===family?'active':''}>{family}</button>)}</div>
        {loading?<p className="explorer-empty" role="status">Loading exams...</p>:<div className="exam-explorer-grid">{explorerCards.map(exam=><button key={exam.id} disabled={!exam.tests.length} className={`exam-explorer-card exam-tone-${exam.tone}`} onClick={()=>openExam(exam.id)}><span className="exam-card-top"><span className="exam-card-icon">{exam.family==='Engineering'?<GraduationCap size={26}/>:exam.family==='State PSC'?<Building2 size={25}/>:exam.family==='Banking'?<Briefcase size={25}/>:<FileQuestion size={25}/>}</span><span><strong>{exam.name}</strong><span className="exam-family-tag">{exam.family}</span></span></span><span className="exam-card-count">{exam.tests.length?`${exam.tests.length} mock ${exam.tests.length===1?'test':'tests'}`:'Coming soon'}</span><span className="exam-card-bottom"><span>{exam.description}</span><span className="exam-card-arrow"><ArrowRight size={17}/></span></span></button>)}</div>}
        {!loading&&!explorerCards.length&&<p className="explorer-empty">No exams match your search.</p>}
      </> : <div className={activeExam.branches ? `mock-explorer-layout${activeExam.id === 'aee' ? ' mock-explorer-aee' : ''}` : ''}>
        {activeExam.branches && <>
          <aside className="mock-category-sidebar" aria-label="Choose a branch">
            <h3>Choose your branch</h3>
            <div className="mock-category-nav" role="group" aria-label="Filter mocks by branch">{branchOptions.map(branch => <button key={branch} type="button" aria-pressed={selectedBranch === branch} onClick={() => setSelectedBranch(branch)} className={selectedBranch === branch ? 'active' : ''}>{branch}<ArrowRight size={15}/></button>)}</div>
          </aside>
          <label className="mock-category-mobile">Choose your branch<select value={selectedBranch} onChange={event => {setSelectedBranch(event.target.value);revealMobileResults(mockResultsRef);}}>{branchOptions.map(branch => <option key={branch}>{branch}</option>)}</select></label>
        </>}
        <div className="mock-explorer-results">
        <div ref={mockResultsRef} tabIndex={-1} className="exam-list-toolbar catalog-results" aria-label="Filtered mock tests"><p role="status"><strong>{visibleTests.length}</strong> available {visibleTests.length===1?'mock':'mocks'}{activeExam.branches && <span className="ml-2">in {selectedBranch}</span>}</p></div>
        {loading&&<p className="explorer-empty" role="status">Loading mock tests...</p>}
        {!loading&&!visibleTests.length&&<p className="explorer-empty">No mocks match your search or branch. Try another filter.</p>}
        <div className="mock-catalog-grid">
          {visibleTests.map(test => <article key={test.id} className="mock-catalog-card">
            <div className="mock-catalog-top">
              <div className="mock-catalog-icon"><GraduationCap size={21} /></div>
              <span className="mock-catalog-available">Available</span>
            </div>
            <div className="mock-catalog-category">{getCategory(test)}</div><p className="mock-catalog-branch">{getMockBranch(test, mockSubjects, mockBranches)}</p>
            <h4 title={test.title}>{test.title}</h4>
            {Number(popularity[test.id]?.learners) > 0 && <p className="mt-2 text-xs font-semibold text-indigo-700" title="Share of unique learners who have started any published mock. Repeat attempts, administrators and the testing account are excluded. Percentages across mocks can exceed 100% because learners may attempt several mocks.">
              {Number(popularity[test.id].learners) >= 10 && Number(popularity[test.id].learner_percentage) >= 20 ? 'Popular - ' : ''}
              {Number(popularity[test.id].learners).toLocaleString()} learners - {popularity[test.id].learner_percentage}% of mock learners
            </p>}
            <p className="mock-catalog-description">{test.description || 'Timed exam practice with instant scoring after submission.'}</p>
            <div className="mock-catalog-details">
              <span><Clock3 size={14} /><b>{test.duration_minutes}</b> min</span>
              <span><FileQuestion size={14} /><b>{test.total_marks}</b> marks</span>
            </div>
            <p className="mock-catalog-pass">{/^GATE 2025/i.test(test.title) ? '2025 General cutoff' : /unofficial/i.test(test.description || '') ? 'Practice benchmark' : 'Pass marks'}: <b>{test.passing_marks}</b></p>
            {savedAttempts.find(saved => saved.mock_test_id === test.id) ? <div className="mt-3 space-y-2">
              <button className="btn btn-primary w-full justify-center" disabled={busy} onClick={() => start(test, savedAttempts.find(saved => saved.mock_test_id === test.id).attempt_id)}><Play size={14} /> Resume test</button>
              <button className="btn w-full justify-center" disabled={busy} onClick={() => setRestartTest(test)}>Start test again</button>
            </div> : <button className="btn btn-primary mock-catalog-start" disabled={busy} onClick={() => start(test)}><Play size={14} /> Start mock test <ArrowRight size={14} /></button>}
          </article>)}
        </div>
        {!supabase && <p className="mt-4 rounded-lg border border-amber-200 bg-amber-50 p-3 text-xs text-amber-800">Connect Supabase to load tests and save attempts.</p>}
        </div>
      </div>}
    </section>
    {restartTest && <div className="mock-modal-backdrop"><section className="mock-modal" role="dialog" aria-modal="true" aria-labelledby="restart-test-title"><h3 id="restart-test-title">Start this test again?</h3><p>Your saved attempt will be closed. A new attempt starts with no answers and the full time allowance.</p><div><button autoFocus className="btn" disabled={busy} onClick={() => setRestartTest(null)}>Keep saved attempt</button><button className="btn btn-primary" disabled={busy} onClick={() => start(restartTest, null, true)}>Start again</button></div></section></div>}
  </>}{error && <p className="text-xs text-rose-700" role="alert">{error}</p>}</div>;
}

function CommunityPage({ user }) {
  return <SocialWall user={user} />;
}

export default function App() {
  const [page, setPageState] = useState('Dashboard');
  const [user, setUser] = useState(null);
  const [authLoading, setAuthLoading] = useState(Boolean(supabase));
  const [authError, setAuthError] = useState('');
  const [roleState, setRoleState] = useState({userId: null, role: 'student'});
  const isAdmin = roleState.userId === user?.id && roleState.role === 'admin';
  useEffect(() => {
    let active = true;
    setRoleState({userId: null, role: 'student'});
    const loadRole = async () => {
      if (!supabase || !user?.id) return;
      try {
        const {data, error} = await supabase.rpc('get_my_app_role');
        if (active) setRoleState({userId: user.id, role: error ? 'student' : data});
      } catch { if (active) setRoleState({userId: user.id, role: 'student'}); }
    };
    loadRole();
    window.addEventListener('focus', loadRole);
    return () => { active = false; window.removeEventListener('focus', loadRole); };
  }, [user?.id]);

  const [focusPreferredSubject, setFocusPreferredSubject] = useState(false);
  const [practiceFilters, setPracticeFilters] = useState({ subjectId: null, examType: '' });
  useEffect(() => {
    setPracticeFilters({ subjectId: null, examType: '' });
    setFocusPreferredSubject(false);
  }, [user?.id, user?.user_metadata?.jobforsure_preferences?.preferredBranch]);
  const setPage = nextPage => {
    setFocusPreferredSubject(false);
    setPageState(nextPage === 'Exam Simulations' ? 'Mock Tests' : nextPage);
  };
  const openPreferredPractice = () => {
    setFocusPreferredSubject(true);
    setPageState('Practice');
  };
  useEffect(() => {
    if (!supabase) {
      setAuthLoading(false);
      return undefined;
    }
    let active = true;
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      if (!active) return;
      setUser(session?.user || null);
      setAuthLoading(false);
      setAuthError('');
    });
    async function loadSession() {
      try {
        const { data, error } = await supabase.auth.getSession();
        if (!active) return;
        if (error) setAuthError(error.message);
        setUser(data.session?.user || null);
      } catch (error) {
        if (active) setAuthError(error instanceof Error ? error.message : 'Unable to restore your sign-in session.');
      } finally {
        if (active) setAuthLoading(false);
      }
    }
    loadSession();
    return () => {
      active = false;
      subscription.unsubscribe();
    };
  }, []);

  if (authLoading) return <main className="auth-page"><div className="auth-loading" role="status">Loading your student workspace...</div></main>;
  if (!user) return <AuthScreen authError={authError} />;
  const preferences = user.user_metadata?.jobforsure_preferences;
  const needsOnboarding = !Array.isArray(preferences?.exams) || preferences.exams.length === 0 || (Boolean(preferences.preferredBranch) && !preferences.preferredSubject);
  if (needsOnboarding) return <Onboarding user={user} setUser={setUser} />;

  const content = page === 'Admin Statistics' ? (isAdmin ? <AdminMockStatistics key={user.id} /> : <p role="alert">Administrator access required.</p>)
    : page === 'Practice' ? <PracticePage user={user} setPage={setPage} setPracticeFilters={setPracticeFilters} focusPreferredSubject={focusPreferredSubject} />
    : page === 'Notifications' ? <NotificationsPage user={user} setPage={setPage} />
    : page === 'Tutorials' ? <TutorialsPage user={user} />
      : page === 'Mock Tests' ? <SimulationsPage user={user} filters={practiceFilters} />
        : page === 'PYQs' ? <PreviousYearPapers key={preferences.preferredBranch} preferredBranch={preferences.preferredBranch} />
        : page === 'Community' ? <CommunityPage user={user} />
          : page === 'Profile' ? <SocialWall user={user} ownProfile onPreferences={() => setPage('Study Preferences')} />
          : page === 'Study Preferences' ? <ProfilePage user={user} setUser={setUser} />
            : <Dashboard user={user} setPage={setPage} onPracticePreferred={openPreferredPractice} preferences={preferences} />;
  return <div className="min-h-screen bg-[#F8FAFC] text-slate-900"><header className="sticky top-0 z-20 border-b border-slate-200 bg-white"><div className="mx-auto flex max-w-7xl flex-wrap items-center justify-between gap-3 px-4 py-3"><button className="flex items-center gap-2 text-left" onClick={() => setPage('Dashboard')}><span className="grid h-9 w-9 place-items-center rounded-lg bg-indigo-600 font-black text-white">J.</span><span className="text-lg font-extrabold">JobFor<span className="text-indigo-600">Sure</span></span></button><AuthPanel user={user} onLogout={() => setUser(null)} setPage={setPage} /></div><nav className="mx-auto flex max-w-7xl gap-1 overflow-x-auto px-3 pb-2">{[...pages, ...(isAdmin ? [['Admin Statistics', Activity]] : [])].map(([name, Icon]) => <button key={name} onClick={() => setPage(name)} className={`nav-item ${page === name ? 'nav-active' : ''}`}><Icon size={15} />{name}</button>)}</nav></header><main className="mx-auto max-w-7xl px-4 py-6 sm:px-5">{content}</main></div>;
}
