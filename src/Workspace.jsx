import MockAttemptHistory, { AttemptScorecard } from './MockAttemptHistory';
import React, { useEffect, useState } from 'react';
import { Activity, ArrowLeft, ArrowRight, Atom, Bell, BookOpen, Briefcase, Building2, CalendarDays, Calculator, Check, CheckCircle2, ChevronDown, ChevronRight, Clock3, Cpu, CircuitBoard, Droplets, ExternalLink, Factory, FileQuestion, Flame, FlaskConical, GraduationCap, Grid2X2, Layers, LayoutDashboard, List, LogOut, MapPin, MessageCircle, Play, Ruler, Search, Send, Settings, SlidersHorizontal, Sparkles, Target, Thermometer, ThumbsUp, TrendingUp, UserRound, Wrench, Zap } from 'lucide-react';
import { supabase } from './supabase';
import MockExam from './MockExam';
import PreviousYearPapers, { isLinkedPaperMock } from './PreviousYearPapers';

const pages = [['Dashboard', LayoutDashboard], ['Practice', Target], ['Tutorials', BookOpen], ['Mock Tests', GraduationCap], ['Previous Papers', FileQuestion], ['Community', MessageCircle], ['Notifications', Bell]];
const Card = ({ children, className = '' }) => <section className={`card ${className}`}>{children}</section>;

function AuthPanel({ user, onLogout, setPage }) {
  const [error, setError] = useState('');
  const [menuOpen, setMenuOpen] = useState(false);
  async function logout() {
    const { error: signOutError } = await supabase.auth.signOut();
    if (signOutError) setError(signOutError.message);
    else {
      setMenuOpen(false);
      onLogout();
    }
  }
  const displayName = user.user_metadata?.full_name || user.user_metadata?.name || user.email;
  const initials = displayName?.split(/[\s@]/).filter(Boolean).slice(0, 2).map(part => part[0]).join('').toUpperCase() || 'U';
  return <div className="relative flex items-center gap-3 text-xs">
    <button
      className="account-trigger"
      type="button"
      aria-expanded={menuOpen}
      aria-haspopup="menu"
      aria-label="Open account menu"
      onClick={() => setMenuOpen(open => !open)}
    >
      {user.user_metadata?.avatar_url
        ? <img className="account-avatar" src={user.user_metadata.avatar_url} alt="" />
        : <span className="account-avatar account-avatar-fallback">{initials}</span>}
      <span className="hidden max-w-40 truncate text-left sm:block">
        <span className="block font-bold text-slate-700">{displayName}</span>
        <span className="mt-0.5 block text-[10px] text-slate-500">{user.email}</span>
      </span>
      <ChevronDown size={14} className={`text-slate-400 transition-transform ${menuOpen ? 'rotate-180' : ''}`} />
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

function AuthScreen({ authError }) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [mode, setMode] = useState('signin');
  const [message, setMessage] = useState('');
  const [busy, setBusy] = useState(false);

  async function submit(event) {
    event.preventDefault();
    if (!supabase) {
      setMessage('Sign-in is unavailable until Supabase is configured.');
      return;
    }
    setBusy(true);
    setMessage('');
    try {
      const result = mode === 'signin'
        ? await supabase.auth.signInWithPassword({ email, password })
        : await supabase.auth.signUp({ email, password });
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

  return <main className="auth-page">
    <div className="auth-layout">
      <section className="auth-intro">
        <a href="/" className="auth-brand" aria-label="JobForSure home">
          <span className="auth-brand-mark">J.</span>
          <span>JobFor<span className="text-indigo-600">Sure</span></span>
        </a>
        <div className="auth-intro-copy">
          <span className="auth-kicker">YOUR NEXT CHAPTER STARTS HERE</span>
          <h1>Prepare with purpose.<br /><span>Get there with confidence.</span></h1>
          <p>A focused learning space for engineering students preparing for the exams that matter.</p>
          <div className="auth-benefits">
            <div><BookOpen size={18} /><span>Learn with structured tutorials</span></div>
            <div><Target size={18} /><span>Practice around your exam goals</span></div>
            <div><GraduationCap size={18} /><span>Grow alongside your community</span></div>
          </div>
        </div>
        <span className="auth-footer">A little progress, every day.</span>
      </section>
      <section className="auth-card" aria-labelledby="auth-heading">
        <span className="auth-kicker">{mode === 'signin' ? 'WELCOME BACK' : 'GET STARTED'}</span>
        <h2 id="auth-heading">{mode === 'signin' ? 'Sign in to your account' : 'Create your student account'}</h2>
        <p className="small">{mode === 'signin' ? 'Pick up where your preparation left off.' : 'Create an account to start your exam preparation.'}</p>
        <button className="auth-google" type="button" disabled={busy || !supabase} onClick={signInWithGoogle}>
          <span className="google-g" aria-hidden="true">G</span>
          Continue with Google
        </button>
        <div className="auth-divider"><span>or continue with email</span></div>
        <form className="auth-form" onSubmit={submit}>
          <label htmlFor="auth-email">Email address</label>
          <input id="auth-email" className="field" type="email" autoComplete="email" placeholder="you@example.com" value={email} onChange={event => setEmail(event.target.value)} required />
          <label htmlFor="auth-password">Password</label>
          <input id="auth-password" className="field" type="password" autoComplete={mode === 'signin' ? 'current-password' : 'new-password'} placeholder="At least 6 characters" value={password} onChange={event => setPassword(event.target.value)} minLength={6} required />
          <button className="btn btn-primary auth-submit" type="submit" disabled={busy || !supabase}>
            {busy ? 'Please wait...' : mode === 'signin' ? 'Sign in' : 'Create account'}
          </button>
        </form>
        {!supabase && <p className="auth-notice" role="status">Authentication is not configured. Add your Supabase URL and anon key to <code>.env</code>, then restart the app.</p>}
        {authError && <p className="auth-message" role="alert">{authError}</p>}
        {message && <p className="auth-message" role="alert">{message}</p>}
        <p className="auth-switch">
          {mode === 'signin' ? 'New to JobForSure?' : 'Already have an account?'}
          <button type="button" disabled={busy} onClick={() => { setMode(mode === 'signin' ? 'signup' : 'signin'); setMessage(''); }}>
            {mode === 'signin' ? 'Create an account' : 'Sign in'}
          </button>
        </p>
        <p className="auth-terms">By continuing, you agree to use JobForSure for your learning journey.</p>
      </section>
    </div>
  </main>;
}

function Onboarding({ user, setUser }) {
  const [exams, setExams] = useState([]);
  const [branch, setBranch] = useState(practiceBranches[0].name);
  const [subject, setSubject] = useState(practiceBranches[0].subjects[0].name);
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
      preferredBranch: branch,
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
        <label htmlFor="preferred-branch">Your engineering branch</label>
        <select id="preferred-branch" className="field" value={branch} onChange={event => changeBranch(event.target.value)}>
          {practiceBranches.map(item => <option key={item.name} value={item.name}>{item.name}</option>)}
        </select>
        <label htmlFor="preferred-subject">Your preferred subject</label>
        <select id="preferred-subject" className="field" value={subject} onChange={event => setSubject(event.target.value)} required>
          {availableSubjects.map(item => <option key={item.name} value={item.name}>{item.name}</option>)}
        </select>
        {message && <p className="auth-message" role="alert">{message}</p>}
        <button className="btn btn-primary auth-submit" type="submit" disabled={busy || !subject}>
          {busy ? 'Saving your preferences...' : 'Continue to your workspace'}
        </button>
      </form>
    </section>
  </main>;
}

function ProfilePage({ user, setUser }) {
  const savedPreferences = user.user_metadata?.jobforsure_preferences || {};
  const [exams, setExams] = useState(savedPreferences.exams || []);
  const [branch, setBranch] = useState(savedPreferences.preferredBranch || practiceBranches[0].name);
  const [subject, setSubject] = useState(savedPreferences.preferredSubject || practiceBranches[0].subjects[0].name);
  const [message, setMessage] = useState('');
  const [saved, setSaved] = useState(false);
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
      preferredBranch: branch,
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
        setSaved(true);
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
      <h2 className="mt-2 text-xl font-extrabold">Preparation preferences</h2>
      <p className="small mt-2">Update your exam goals and focus subject to personalize your dashboard and practice suggestions.</p>
      <div className="mt-5 rounded-lg bg-slate-50 p-3">
        <span className="eyebrow">ACCOUNT EMAIL</span>
        <p className="mt-1 text-sm font-semibold">{user.email}</p>
      </div>
      <form className="onboarding-form mt-6" onSubmit={saveProfile}>
        <fieldset>
          <legend>Which exams are you preparing for?</legend>
          <div className="exam-options">
            {examOptions.map(exam => <label key={exam} className={`exam-option ${exams.includes(exam) ? 'exam-option-selected' : ''}`}>
              <input type="checkbox" checked={exams.includes(exam)} onChange={() => toggleExam(exam)} />
              <span>{exam}</span>
            </label>)}
          </div>
        </fieldset>
        <label htmlFor="profile-branch">Your engineering branch</label>
        <select id="profile-branch" className="field" value={branch} onChange={event => changeBranch(event.target.value)}>
          {practiceBranches.map(item => <option key={item.name} value={item.name}>{item.name}</option>)}
        </select>
        <label htmlFor="profile-subject">Your preferred subject</label>
        <select id="profile-subject" className="field" value={subject} onChange={event => { setSubject(event.target.value); setSaved(false); }} required>
          {availableSubjects.map(item => <option key={item.name} value={item.name}>{item.name}</option>)}
        </select>
        {message && <p className="auth-message" role="alert">{message}</p>}
        {saved && <p className="profile-success" role="status">Your profile is saved. Your dashboard will use these preferences.</p>}
        <button className="btn btn-primary auth-submit" type="submit" disabled={busy || !subject}>
          {busy ? 'Saving profile...' : 'Save profile'}
        </button>
      </form>
    </Card>
  </div>;
}

const demoDiscussionPosts = [
  { id: 'demo-kvl', author: 'Rahul K.', initials: 'RK', label: 'Electrical Engineering · 18 min ago', title: 'Why does KVL fail when a time-varying magnetic field is present?', body: 'Faraday’s law suggests a non-zero closed-loop integral of the electric field. How should we handle this in a GATE circuit problem?', likes: 42, comments: [{ author: 'Dr. Sneha Patel · Mentor', body: 'KVL assumes a conservative electric field. With changing magnetic flux, use Faraday’s law: the induced electric field is non-conservative.' }, { author: 'Meera S.', body: 'So for the usual lumped-circuit questions, we can use KVL unless changing flux is specified?' }] },
  { id: 'demo-study-plan', author: 'Aarav M.', initials: 'AM', label: 'Computer Science · 1 hr ago', title: 'How are you balancing revision with full-length mocks?', body: 'I have 10 weeks left and keep losing time reviewing every question. What review routine is working for you?', likes: 28, comments: [{ author: 'Nisha R.', body: 'I tag misses by topic and review only the two weakest areas the next morning.' }] },
  { id: 'demo-resource', author: 'Ishita P.', initials: 'IP', label: 'Mechanical Engineering · 3 hrs ago', title: 'Thermodynamics: quick revision checklist', body: 'Shared a short checklist for cycles, property relations, and common sign-convention mistakes. What would you add before a mock?', likes: 16, comments: [] },
];

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

function Dashboard({ setPage, onPracticePreferred, preferences }) {
  const [posts, setPosts] = useState(() => demoDiscussionPosts.map(post => ({ ...post, comments: [...post.comments], liked: false })));
  const [draft, setDraft] = useState('');
  const [commentDrafts, setCommentDrafts] = useState({});
  const [openComments, setOpenComments] = useState({ 'demo-kvl': true });
  function publishPost(event) {
    event.preventDefault();
    const body = draft.trim();
    if (!body) return;
    setPosts(previous => [{ id: `local-${Date.now()}`, author: 'You', initials: 'YO', label: 'Just now · Demo post', title: body.split('\n')[0].slice(0, 120), body, likes: 0, comments: [], liked: false }, ...previous]);
    setDraft('');
  }

  function toggleLike(postId) {
    setPosts(previous => previous.map(post => post.id === postId ? { ...post, liked: !post.liked, likes: post.likes + (post.liked ? -1 : 1) } : post));
  }

  function addComment(event, postId) {
    event.preventDefault();
    const body = commentDrafts[postId]?.trim();
    if (!body) return;
    setPosts(previous => previous.map(post => post.id === postId ? { ...post, comments: [...post.comments, { author: 'You', body }] } : post));
    setCommentDrafts(previous => ({ ...previous, [postId]: '' }));
    setOpenComments(previous => ({ ...previous, [postId]: true }));
  }

  return <><div className="mb-4 flex justify-end"><DashboardProgress /></div>
    <div className="grid items-start gap-4 lg:grid-cols-[minmax(190px,0.72fr)_minmax(0,1.8fr)_minmax(230px,0.9fr)]">
    <aside className="space-y-4">
      <Card className="p-4"><div className="eyebrow">YOUR WEEK</div><div className="mt-3 flex items-center justify-between"><span className="text-xs text-slate-600">Study streak</span><span className="inline-flex items-center gap-1 text-xs font-bold"><Flame size={14} className="text-orange-500" /> 6 days</span></div><div className="mt-4 flex items-center justify-between"><span className="text-xs text-slate-600">Learning time</span><b className="text-xs">8h 40m</b></div><div className="mt-3 h-1.5 rounded bg-slate-100"><div className="h-full w-[72%] rounded bg-emerald-500" /></div><p className="small mt-2">72% of your weekly goal</p></Card>
      <Card><div className="card-head"><b>Your focus</b><Target size={16} className="text-indigo-600" /></div><div className="p-4"><span className="eyebrow">{preferences.preferredBranch}</span><b className="mt-2 block text-sm">{preferences.preferredSubject}</b><div className="mt-3 flex flex-wrap gap-1.5">{preferences.exams.map(exam => <span className="pill" key={exam}>{exam}</span>)}</div><button className="btn btn-primary mt-4 w-full justify-center" onClick={onPracticePreferred}>Practice this subject <ArrowRight size={13} /></button></div><button className="w-full border-t border-slate-100 p-3 text-xs font-bold text-indigo-700 hover:bg-slate-50" onClick={() => setPage('Profile')}>Edit preparation profile</button></Card>
      <Card><div className="card-head"><b>Continue learning</b><BookOpen size={16} className="text-indigo-600" /></div><button className="w-full p-4 text-left" onClick={onPracticePreferred}><span className="eyebrow">{preferences.preferredBranch}</span><b className="mt-2 block text-xs">{preferences.preferredSubject}</b><span className="small mt-2 block">Continue with your preferred subject</span></button></Card>
    </aside>

    <section className="min-w-0 space-y-4" aria-label="Engineering community feed">
      <Card><form className="p-4" onSubmit={publishPost}><label className="mb-2 block text-xs font-bold" htmlFor="dashboard-post">Start a discussion</label><textarea id="dashboard-post" className="field min-h-20 resize-y" placeholder="Ask a question, share a study tip, or start a topic..." value={draft} onChange={event => setDraft(event.target.value)} /><div className="mt-3 flex flex-wrap items-center justify-between gap-2"><span className="small">Posting to the student community</span><button className="btn btn-primary" disabled={!draft.trim()}><Send size={14} /> Share post</button></div></form></Card>
      {posts.map(post => <Card key={post.id}>
        <article className="p-4 sm:p-5"><div className="flex items-start gap-3"><div className="avatar bg-indigo-50 text-indigo-700">{post.initials}</div><div className="min-w-0 flex-1"><div className="flex flex-wrap items-center gap-x-2 gap-y-1"><b className="text-xs">{post.author}</b><span className="small">{post.label}</span></div><h2 className="mt-3 text-sm font-bold leading-5">{post.title}</h2><p className="mt-2 whitespace-pre-wrap text-sm leading-6 text-slate-700">{post.body}</p><div className="mt-4 flex items-center justify-between border-b border-slate-100 pb-3 text-xs text-slate-500"><span>{post.likes} reactions</span><span>{post.comments.length} comments</span></div><div className="flex gap-2 border-b border-slate-100 py-2"><button className={`btn border-0 px-2 ${post.liked ? 'text-indigo-700' : ''}`} onClick={() => toggleLike(post.id)}><ThumbsUp size={14} /> Like</button><button className="btn border-0 px-2" onClick={() => setOpenComments(previous => ({ ...previous, [post.id]: !previous[post.id] }))}><MessageCircle size={14} /> Comment</button></div>
          {openComments[post.id] && <div className="space-y-3 pt-3">{post.comments.map((comment, index) => <div key={`${post.id}-${index}`} className="flex gap-2"><div className="avatar h-7 w-7 bg-slate-100 text-slate-600">{comment.author.split(' ').slice(0, 2).map(part => part[0]).join('').replace('.', '')}</div><div className="min-w-0 flex-1 rounded-lg bg-slate-50 px-3 py-2"><b className="text-[11px]">{comment.author}</b><p className="mt-1 text-xs leading-5 text-slate-600">{comment.body}</p></div></div>)}<form className="flex gap-2" onSubmit={event => addComment(event, post.id)}><input className="field" aria-label={`Comment on ${post.title}`} placeholder="Write a comment..." value={commentDrafts[post.id] || ''} onChange={event => setCommentDrafts(previous => ({ ...previous, [post.id]: event.target.value }))} /><button className="btn" disabled={!commentDrafts[post.id]?.trim()} aria-label="Submit comment"><Send size={14} /></button></form></div>}
        </div></div></article>
      </Card>)}
      <p className="small text-center">Dashboard discussions are sample content for preview. Community page posts use Supabase.</p>
    </section>

    <aside className="space-y-4">
      <Card><div className="card-head"><div><b>Important updates</b><p className="small mt-1">For your preparation</p></div><Bell size={16} className="text-indigo-600" /></div><div className="divide-y divide-slate-100">
        <button className="block w-full p-4 text-left hover:bg-slate-50" onClick={() => setPage('Notifications')}><span className="pill">EXAM ALERT</span><b className="mt-2 block text-xs">{preferences.exams[0]} exam updates</b><span className="small mt-1 block">Review dates and set a reminder</span><span className="mt-2 inline-flex items-center gap-1 text-[10px] font-bold text-indigo-700">View notifications <ArrowRight size={12} /></span></button>
        <button className="block w-full p-4 text-left hover:bg-slate-50" onClick={() => setPage('Tutorials')}><span className="pill pill-green">NEW LESSON</span><b className="mt-2 block text-xs">Control Systems: Root Locus</b><span className="small mt-1 block">A new tutorial is ready to explore</span></button>
        <div className="p-4"><span className="pill">LIVE DISCUSSION</span><b className="mt-2 block text-xs">Power systems Q&amp;A</b><span className="small mt-1 block">Today · 6:30 PM</span></div>
      </div></Card>
      <Card className="p-4"><div className="flex items-center gap-2"><TrendingUp size={16} className="text-emerald-600" /><b className="text-xs">Recent progress</b></div><div className="mt-4 space-y-3"><div className="flex justify-between text-xs"><span className="text-slate-600">Tutorials completed</span><b>12 / 16</b></div><div className="flex justify-between text-xs"><span className="text-slate-600">Mock accuracy</span><b>78%</b></div><div className="flex items-center gap-2 text-xs text-emerald-700"><CheckCircle2 size={14} /> Up 6% this month</div></div><button className="btn mt-4 w-full justify-center" onClick={() => setPage('Mock Tests')}>View mock tests <ArrowRight size={13} /></button></Card>
    </aside>
  </div></>;
}

function DashboardProgress() {
  return <div className="min-w-[190px] rounded-lg border border-slate-200 bg-white px-4 py-3"><div className="flex items-baseline justify-between gap-4"><span className="text-xs font-semibold text-slate-500">Overall progress</span><b className="text-2xl font-extrabold text-indigo-700">78%</b></div><div className="mt-2 h-1.5 rounded bg-slate-100"><div className="h-full w-[78%] rounded bg-indigo-600" /></div><p className="small mt-2">On track this week</p></div>;
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
    if (user && supabase && !String(branch.id).startsWith('fallback:')) {
      const { error: saveError } = await supabase.from('profiles').update({ branch_id: branch.id }).eq('id', user.id);
      if (saveError) setError(saveError.message);
    }
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
  const [tutorials, setTutorials] = useState([]);
  const [progress, setProgress] = useState({});
  const [selectedId, setSelectedId] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  useEffect(() => {
    let active = true;
    async function load() {
      if (!supabase) { setLoading(false); return; }
      const { data, error: queryError } = await supabase.from('tutorials').select('id,title,content,code_example,equation_latex,video_url,difficulty,estimated_minutes,topic_id,topics(title,subjects(name))').eq('is_published', true).order('created_at', { ascending: false });
      if (!active) return;
      if (queryError) setError(queryError.message); else { setTutorials(data || []); setSelectedId(current => current || data?.[0]?.id || ''); }
      if (user) {
        const { data: rows, error: progressError } = await supabase.from('student_progress').select('tutorial_id,status,progress_percent').eq('student_id', user.id);
        if (!active) return;
        if (progressError) setError(progressError.message); else setProgress(Object.fromEntries((rows || []).map(row => [row.tutorial_id, row])));
      }
      setLoading(false);
    }
    load(); return () => { active = false; };
  }, [user]);
  const selected = tutorials.find(item => item.id === selectedId);
  async function updateProgress(status, percent) {
    if (!user || !selected) { setError('Sign in to save tutorial progress.'); return; }
    const row = { student_id: user.id, tutorial_id: selected.id, status, progress_percent: percent, last_accessed_at: new Date().toISOString() };
    const { error: saveError } = await supabase.from('student_progress').upsert(row, { onConflict: 'student_id,tutorial_id' });
    if (saveError) setError(saveError.message); else setProgress(previous => ({ ...previous, [selected.id]: row }));
  }
  return <div className="grid items-start gap-4 lg:grid-cols-[minmax(220px,0.8fr)_minmax(0,2fr)]"><Card>
    <div className="card-head"><div><b>Published tutorials</b><p className="small mt-1">Browse by topic</p></div><BookOpen size={17} className="text-indigo-600" /></div>
    {loading && <p className="p-4 small">Loading tutorials...</p>}{!loading && !tutorials.length && <p className="p-4 small">No published tutorials yet.</p>}
    <div className="divide-y divide-slate-100">{tutorials.map(item => <button key={item.id} className={`block w-full p-4 text-left hover:bg-slate-50 ${item.id === selectedId ? 'bg-indigo-50/70' : ''}`} onClick={() => setSelectedId(item.id)}><span className="block text-xs font-bold">{item.title}</span><span className="small mt-1 block">{item.topics?.subjects?.name || 'Engineering'} · {item.topics?.title || 'Topic'}</span>{progress[item.id] && <span className="mt-2 block text-[10px] font-bold text-emerald-700">{progress[item.id].progress_percent}% complete</span>}</button>)}</div>
  </Card><Card>{!selected ? <div className="p-6"><h2 className="text-sm font-bold">Tutorial reader</h2><p className="small mt-2">{supabase ? 'Choose a published tutorial to begin.' : 'Connect Supabase to load published tutorials.'}</p></div> : <article className="p-5 sm:p-7"><div className="eyebrow">{selected.topics?.subjects?.name || 'ENGINEERING'} · {selected.topics?.title || 'TUTORIAL'}</div><h2 className="mt-2 text-xl font-extrabold">{selected.title}</h2><div className="mt-3 flex gap-2"><span className="pill">{selected.difficulty}</span>{selected.estimated_minutes && <span className="pill">{selected.estimated_minutes} min</span>}</div><div className="mt-6 whitespace-pre-wrap text-sm leading-7 text-slate-700">{selected.content}</div>{selected.equation_latex && <pre className="terminal mt-5">{selected.equation_latex}</pre>}{selected.code_example && <pre className="terminal mt-4">{selected.code_example}</pre>}{selected.video_url && <a className="mt-4 inline-block text-xs font-bold text-indigo-700" href={selected.video_url} target="_blank" rel="noreferrer">Open video lesson</a>}<div className="mt-7 flex flex-wrap gap-2 border-t border-slate-100 pt-4"><button className="btn" onClick={() => updateProgress('in_progress', Math.max(progress[selected.id]?.progress_percent || 0, 50))}>Mark in progress</button><button className="btn btn-primary" onClick={() => updateProgress('completed', 100)}><Check size={14} /> Mark complete</button></div></article>}{error && <p className="px-5 pb-4 text-xs text-rose-700" role="alert">{error}</p>}</Card></div>;
}

function SimulationsPage({ user, filters }) {
  const [tests, setTests] = useState([]);
  const [testSearch, setTestSearch] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('All tests');
  const [attempt, setAttempt] = useState(null);
  const [answers, setAnswers] = useState({});
  const [result, setResult] = useState(null);
  const [historyRefresh, setHistoryRefresh] = useState(0);
  const [historyOpen, setHistoryOpen] = useState(false);
  const [remaining, setRemaining] = useState(0);
  const [loading, setLoading] = useState(true);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState('');
  useEffect(() => {
    let active = true;
    async function loadTests() {
      setLoading(true);
      if (!supabase) { setLoading(false); return; }
      let query = supabase.from('mock_tests').select('id,title,description,exam_type,duration_minutes,total_marks,passing_marks').eq('is_published', true);
      if (filters.subjectId) query = query.eq('subject_id', filters.subjectId);
      if (filters.examType) query = query.in('exam_type', [filters.examType.toUpperCase(), 'OTHER']);
      const { data, error: queryError } = await query.order('created_at', { ascending: false });
      if (!active) return;
      if (queryError) setError(queryError.message); else setTests((data || []).filter(test => !isLinkedPaperMock(test)));
      setLoading(false);
    }
    loadTests();
    return () => { active = false; };
  }, [filters.subjectId, filters.examType]);
  useEffect(() => {
    if (!attempt) return undefined;
    const timer = setInterval(() => setRemaining(value => Math.max(0, value - 1)), 1000);
    return () => clearInterval(timer);
  }, [attempt]);
  useEffect(() => { if (attempt && remaining === 0 && !busy) submitAttempt(); }, [attempt, remaining, busy]);
  async function start(test) {
    if (!user) { setError('Sign in before starting a simulation.'); return; }
    setBusy(true); setError(''); setResult(null);
    const { data, error: startError } = await supabase.rpc('start_mock_attempt', { p_mock_test_id: test.id });
    if (startError) setError(startError.message); else { setAttempt({ ...data, total_marks: test.total_marks, test_description: test.description }); setAnswers({}); setRemaining(data.duration_minutes * 60); }
    setBusy(false);
  }
  async function submitAttempt() {
    if (!attempt || busy) return;
    setBusy(true); setError('');
    const payload = Object.entries(answers).filter(([, value]) => String(value).trim() !== '').map(([question_id, selected_answer]) => ({ question_id, selected_answer }));
    const { data, error: submitError } = await supabase.rpc('submit_mock_attempt', { p_attempt_id: attempt.attempt_id, p_answers: payload });
    if (submitError) setError(submitError.message); else {
      const completed = attempt;
      setResult({ ...data, title: completed.test_title, total_marks: completed.total_marks });
      setAttempt(null); setHistoryRefresh(value => value + 1);
      const { data: history } = await supabase.rpc('get_mock_attempt_history', { p_attempt_id: completed.attempt_id, p_limit: 1, p_offset: 0 });
      if (history?.[0]) setResult(history[0]);
    }
    setBusy(false);
  }
  const clock = `${String(Math.floor(remaining / 60)).padStart(2, '0')}:${String(remaining % 60).padStart(2, '0')}`;
  const getCategory = test => /^GATE/i.test(test.title) ? 'GATE' : /ssc\s*cgl/i.test(test.title) ? 'SSC CGL' : /tgpsc|tspsc/i.test(test.title) ? 'TGPSC AEE' : test.title.toLowerCase().includes('junior engineer') ? 'SSC JE' : String(test.exam_type || 'Other');
  const categories = ['All tests', ...new Set(tests.map(getCategory))];
  const visibleTests = tests.filter(test => {
    const matchesCategory = selectedCategory === 'All tests' || getCategory(test) === selectedCategory;
    const query = testSearch.trim().toLowerCase();
    const matchesSearch = !query || `${test.title} ${test.description || ''} ${getCategory(test)}`.toLowerCase().includes(query);
    return matchesCategory && matchesSearch;
  });
  return <div className="space-y-4">{attempt ? <MockExam attempt={attempt} answers={answers} setAnswers={setAnswers} clock={clock} busy={busy} onSubmit={submitAttempt} error={error} /> : <>
    {result && <AttemptScorecard result={result} onClose={() => setResult(null)} />}

    <section className="overflow-hidden rounded-2xl border border-indigo-100 bg-white shadow-sm">
      <div className="flex flex-wrap items-center justify-between gap-3 border-b border-slate-100 px-5 py-4">
        <div className="flex items-center gap-3"><div className="rounded-xl bg-indigo-50 p-2.5 text-indigo-600"><GraduationCap size={22} /></div><div><h2 className="text-base font-extrabold text-slate-900">Find your next mock test</h2><p className="mt-0.5 text-xs text-slate-500">Timed practice with instant scores and section insights.</p></div></div>
        <div className="flex items-center gap-2"><span className="rounded-full bg-indigo-50 px-3 py-1.5 text-xs font-bold text-indigo-700">{tests.length} available {tests.length === 1 ? 'test' : 'tests'}</span><button className="btn" aria-expanded={historyOpen} aria-controls="mock-attempt-history" onClick={() => setHistoryOpen(value => !value)}>{historyOpen ? 'Hide attempts' : 'View attempts'}</button></div>
      </div>

      <MockAttemptHistory open={historyOpen} supabase={supabase} user={user} refresh={historyRefresh} onSelect={row => { setResult(row); window.scrollTo({ top: 0, behavior: 'smooth' }); }} />

      <div className="border-b border-slate-100 p-4 sm:p-6">
        <label className="flex h-11 max-w-2xl items-center gap-3 rounded-xl border border-slate-200 bg-slate-50 px-3.5 text-slate-400 focus-within:border-indigo-400 focus-within:bg-white focus-within:ring-2 focus-within:ring-indigo-100">
          <Search size={17} />
          <input className="h-full min-w-0 flex-1 border-0 bg-transparent text-sm text-slate-800 outline-none placeholder:text-slate-400" value={testSearch} onChange={event => setTestSearch(event.target.value)} placeholder="Search exams or mock tests" aria-label="Search mock tests" />
          <SlidersHorizontal size={16} />
        </label>
        <div className="mt-4 flex flex-wrap gap-2" role="tablist" aria-label="Filter tests by exam">
          {categories.map(category => <button key={category} type="button" role="tab" aria-selected={selectedCategory === category} onClick={() => setSelectedCategory(category)} className={`rounded-full border px-4 py-2 text-xs font-bold transition ${selectedCategory === category ? 'border-indigo-600 bg-indigo-600 text-white shadow-sm' : 'border-slate-200 bg-white text-slate-600 hover:border-indigo-200 hover:text-indigo-700'}`}>{category}</button>)}
        </div>
      </div>

      <div className="bg-slate-50/70 p-4 sm:p-6">
        <div className="mb-4 flex items-center justify-between gap-3">
          <div>
            <h3 className="text-base font-extrabold text-slate-900">{selectedCategory === 'All tests' ? 'Explore mock tests' : `${selectedCategory} mock tests`}</h3>
            <p className="mt-1 text-xs text-slate-500">{loading ? 'Finding available tests...' : `${visibleTests.length} ${visibleTests.length === 1 ? 'test' : 'tests'} to practice`}</p>
          </div>
          <span className="hidden items-center gap-1.5 text-xs font-semibold text-slate-500 sm:flex"><FileQuestion size={15} /> Exam-style practice</span>
        </div>
        {loading && <div className="rounded-xl border border-slate-200 bg-white p-6 text-sm text-slate-500">Loading available tests...</div>}
        {!loading && !tests.length && <div className="rounded-xl border border-dashed border-slate-300 bg-white px-5 py-12 text-center"><GraduationCap size={26} className="mx-auto text-indigo-400" /><h4 className="mt-3 text-sm font-bold text-slate-800">No mock tests available yet</h4><p className="mt-1 text-xs text-slate-500">Published tests will appear here when they are ready.</p></div>}
        {!loading && tests.length > 0 && !visibleTests.length && <div className="rounded-xl border border-dashed border-slate-300 bg-white px-5 py-10 text-center"><p className="text-sm font-bold text-slate-800">No matching tests</p><p className="mt-1 text-xs text-slate-500">Try another exam category or search term.</p></div>}
        <div className="mock-catalog-grid">
          {visibleTests.map(test => <article key={test.id} className="mock-catalog-card">
            <div className="mock-catalog-top">
              <div className="mock-catalog-icon"><GraduationCap size={21} /></div>
              <span className="mock-catalog-available">Available</span>
            </div>
            <div className="mock-catalog-category">{getCategory(test)}</div>
            <h4 title={test.title}>{test.title}</h4>
            <p className="mock-catalog-description">{test.description || 'Timed exam practice with instant scoring after submission.'}</p>
            <div className="mock-catalog-details">
              <span><Clock3 size={14} /><b>{test.duration_minutes}</b> min</span>
              <span><FileQuestion size={14} /><b>{test.total_marks}</b> marks</span>
            </div>
            <p className="mock-catalog-pass">{/^GATE 2025/i.test(test.title) ? '2025 General cutoff' : /unofficial/i.test(test.description || '') ? 'Practice benchmark' : 'Pass marks'}: <b>{test.passing_marks}</b></p>
            <button className="btn btn-primary mock-catalog-start" disabled={busy} onClick={() => start(test)}><Play size={14} /> Start mock test <ArrowRight size={14} /></button>
          </article>)}
        </div>
        {!supabase && <p className="mt-4 rounded-lg border border-amber-200 bg-amber-50 p-3 text-xs text-amber-800">Connect Supabase to load tests and save attempts.</p>}
      </div>
    </section>
  </>}{error && <p className="text-xs text-rose-700" role="alert">{error}</p>}</div>;
}

function CommunityPage({ user }) {
  const [posts, setPosts] = useState([]);
  const [draft, setDraft] = useState('');
  const [error, setError] = useState('');
  const [busy, setBusy] = useState(false);
  useEffect(() => {
    let active = true;
    if (!supabase) return undefined;
    supabase.from('community_posts').select('id,title,content,post_type,created_at').order('created_at', { ascending: false }).limit(30).then(({ data, error: queryError }) => { if (!active) return; if (queryError) setError(queryError.message); else setPosts(data || []); });
    return () => { active = false; };
  }, []);
  async function publish(event) {
    event.preventDefault();
    if (!user) { setError('Sign in to post to the community.'); return; }
    const content = draft.trim(); if (!content) return;
    setBusy(true); setError('');
    const { data, error: insertError } = await supabase.from('community_posts').insert({ student_id: user.id, title: content.split('\n')[0].slice(0, 250), content }).select('id,title,content,post_type,created_at').single();
    if (insertError) setError(insertError.message); else { setPosts(previous => [data, ...previous]); setDraft(''); }
    setBusy(false);
  }
  return <div className="space-y-4"><Card><div className="card-head"><b>Community discussions</b><MessageCircle size={17} className="text-indigo-600" /></div><form className="p-4" onSubmit={publish}><textarea className="field min-h-24" placeholder="Share a question or discussion" value={draft} onChange={event => setDraft(event.target.value)} /><button className="btn btn-primary mt-3" disabled={busy}><Send size={14} /> Post</button></form></Card>{posts.map(post => <Card key={post.id} className="p-4"><div className="flex items-center gap-2"><span className="pill">{post.post_type}</span><time className="small">{new Date(post.created_at).toLocaleDateString()}</time></div><h2 className="mt-3 text-sm font-bold">{post.title}</h2><p className="mt-2 whitespace-pre-wrap text-sm leading-6 text-slate-700">{post.content}</p></Card>)}{!supabase && <p className="small">Connect Supabase to load and publish discussions.</p>}{error && <p className="text-xs text-rose-700" role="alert">{error}</p>}</div>;
}

export default function App() {
  const [page, setPageState] = useState('Dashboard');
  const [user, setUser] = useState(null);
  const [authLoading, setAuthLoading] = useState(Boolean(supabase));
  const [authError, setAuthError] = useState('');
  const [focusPreferredSubject, setFocusPreferredSubject] = useState(false);
  const [practiceFilters, setPracticeFilters] = useState({ subjectId: null, examType: '' });
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
  const needsOnboarding = !Array.isArray(preferences?.exams) || preferences.exams.length === 0 || !preferences.preferredSubject;
  if (needsOnboarding) return <Onboarding user={user} setUser={setUser} />;

  const content = page === 'Practice' ? <PracticePage user={user} setPage={setPage} setPracticeFilters={setPracticeFilters} focusPreferredSubject={focusPreferredSubject} />
    : page === 'Notifications' ? <NotificationsPage user={user} setPage={setPage} />
    : page === 'Tutorials' ? <TutorialsPage user={user} />
      : page === 'Mock Tests' ? <SimulationsPage user={user} filters={practiceFilters} />
        : page === 'Previous Papers' ? <PreviousYearPapers />
        : page === 'Community' ? <CommunityPage user={user} />
          : page === 'Profile' ? <ProfilePage user={user} setUser={setUser} />
            : <Dashboard setPage={setPage} onPracticePreferred={openPreferredPractice} preferences={preferences} />;
  return <div className="min-h-screen bg-[#F8FAFC] text-slate-900"><header className="sticky top-0 z-20 border-b border-slate-200 bg-white"><div className="mx-auto flex max-w-7xl flex-wrap items-center justify-between gap-3 px-4 py-3"><button className="flex items-center gap-2 text-left" onClick={() => setPage('Dashboard')}><span className="grid h-9 w-9 place-items-center rounded-lg bg-indigo-600 font-black text-white">J.</span><span className="text-lg font-extrabold">JobFor<span className="text-indigo-600">Sure</span></span></button><AuthPanel user={user} onLogout={() => setUser(null)} setPage={setPage} /></div><nav className="mx-auto flex max-w-7xl gap-1 overflow-x-auto px-3 pb-2">{pages.map(([name, Icon]) => <button key={name} onClick={() => setPage(name)} className={`nav-item ${page === name ? 'nav-active' : ''}`}><Icon size={15} />{name}</button>)}</nav></header><main className="mx-auto max-w-7xl px-4 py-6 sm:px-5">{page !== 'Mock Tests' && <div className="mb-5"><div className="eyebrow">STUDENT LEARNING WORKSPACE</div><h1 className="mt-1 text-2xl font-extrabold">{page === 'Dashboard' ? 'Your learning hub' : page}</h1><p className="small mt-1">Learn consistently. Prepare with purpose.</p></div>}{content}</main></div>;
}
