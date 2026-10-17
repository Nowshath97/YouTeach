import React, { useEffect, useState } from 'react';
import { ArrowRight, Bell, BookOpen, Flame, Target, TrendingUp } from 'lucide-react';
import { supabase } from './supabase';

function YourWeek({ user }) {
  const [activity, setActivity] = useState(null);
  const [unavailable, setUnavailable] = useState(false);
  useEffect(() => {
    let active = true;
    if (!supabase) return;
    supabase.rpc('get_mock_attempt_history', { p_limit: 20, p_offset: 0 }).then(({ data, error }) => {
      if (!active) return;
      if (error) { setUnavailable(true); return; }
      const dateKey = date => new Intl.DateTimeFormat('en-CA', { timeZone: 'Asia/Kolkata', year: 'numeric', month: '2-digit', day: '2-digit' }).format(date);
      const dates = new Set();
      for (let n = 0; n < 7; n++) dates.add(dateKey(new Date(Date.now() - n * 86400000)));
      const recent = (data || []).filter(row => row.status === 'submitted' && row.submitted_at && dates.has(dateKey(new Date(row.submitted_at))));
      setActivity({ days: new Set(recent.map(row => dateKey(new Date(row.submitted_at)))).size, minutes: Math.floor(recent.reduce((sum, row) => sum + Number(row.time_taken_seconds || 0), 0) / 60) });
    }).catch(() => { if (active) setUnavailable(true); });
    return () => { active = false; };
  }, [user.id]);
  return <section className="card p-4"><h2 className="eyebrow">YOUR WEEK</h2><div className="mt-4 flex justify-between text-xs"><span>Mock study days</span><b className="flex gap-1 items-center"><Flame size={14} className="text-orange-500" />{activity ? `${activity.days} days` : '?'}</b></div><div className="mt-4 flex justify-between text-xs"><span>Mock test time</span><b>{activity ? `${Math.floor(activity.minutes / 60)}h ${activity.minutes % 60}m` : '?'}</b></div><p className="small mt-3">{unavailable ? 'Activity is currently unavailable.' : 'Last 7 days, from your latest 20 attempts.'}</p></section>;
}

export function StudyFocus({ user, preferences, onPractice, setPage }) {
  return <div className="space-y-4">
    <YourWeek user={user} />
    <section className="card"><div className="card-head"><b>Your focus</b><Target size={17} className="text-indigo-600" /></div><div className="p-4"><p className="eyebrow">{preferences.preferredBranch || 'Explore all branches'}</p><p className="text-sm font-bold mt-3">{preferences.preferredSubject || 'Choose a subject to begin'}</p><div className="flex flex-wrap gap-2 mt-3">{preferences.exams?.map(exam => <span className="pill" key={exam}>{exam}</span>)}</div><button className="btn btn-primary w-full justify-center mt-4" onClick={onPractice}>{preferences.preferredSubject ? 'Practice this subject' : 'Browse subjects'}<ArrowRight size={14} /></button></div><button className="w-full border-t border-slate-100 p-3 text-xs font-bold text-indigo-700" onClick={() => setPage('Study Preferences')}>Edit preparation profile</button></section>
    <section className="card"><div className="card-head"><b>Continue learning</b><BookOpen size={17} className="text-indigo-600" /></div><button className="p-4 text-left w-full" onClick={onPractice}><p className="eyebrow">{preferences.preferredBranch || 'All branches'}</p><p className="text-sm font-bold mt-3">{preferences.preferredSubject || 'Explore your next subject'}</p><p className="small mt-3">Continue with your preferred subject</p></button></section>
  </div>;
}

export function ExamAndProgress({ user, setPage }) {
  const [exams, setExams] = useState(null);
  const [latestLessons, setLatestLessons] = useState(null);
  const [tutorials, setTutorials] = useState(null);
  const [attempts, setAttempts] = useState(null);
  const [errors, setErrors] = useState({});
  useEffect(() => {
    let active = true;
    if (!supabase) return;
    const today = new Intl.DateTimeFormat('en-CA', { timeZone: 'Asia/Kolkata', year: 'numeric', month: '2-digit', day: '2-digit' }).format(new Date());
    Promise.allSettled([
      supabase.from('exams').select('id,name,exam_date,application_end_date').gte('exam_date', today).order('exam_date').limit(3),
      supabase.from('student_progress').select('status,progress_percent').eq('student_id', user.id),
      supabase.rpc('get_mock_attempt_history', { p_limit: 20, p_offset: 0 }),
      supabase.from('tutorials').select('id,title').eq('is_published', true).order('created_at', { ascending: false }).limit(1),
    ]).then(results => {
      if (!active) return;
      const setters = [setExams, setTutorials, setAttempts, setLatestLessons];
      const nextErrors = {};
      results.forEach((result, index) => {
        if (result.status === 'rejected' || result.value.error) nextErrors[index] = true;
        else setters[index](result.value.data || []);
      });
      setErrors(nextErrors);
    });
    return () => { active = false; };
  }, [user.id]);
  const scored = (attempts || []).filter(row => row.status === 'submitted' && Number(row.total_marks) > 0);
  const average = scored.length ? scored.reduce((sum, row) => sum + 100 * Number(row.score) / Number(row.total_marks), 0) / scored.length : null;
  const completed = tutorials?.filter(row => row.status === 'completed').length || 0;
  const inProgress = tutorials?.filter(row => row.status === 'in_progress').length || 0;
  return <div className="space-y-4">
    <section className="card"><div className="card-head"><div><b>Important updates</b><p className="small mt-1">For your preparation</p></div><Bell size={17} className="text-indigo-600" /></div><div className="p-4"><span className="pill">EXAM ALERT</span><div className="divide-y divide-slate-100 mt-3">{exams?.map(exam => <button key={exam.id} className="block py-3 text-left w-full" onClick={() => setPage('Notifications')}><b className="text-xs">{exam.name}</b><span className="small block mt-1">Exam: {new Date(`${exam.exam_date}T00:00:00`).toLocaleDateString()}</span>{exam.application_end_date && <span className="small block mt-1">Apply by {new Date(`${exam.application_end_date}T00:00:00`).toLocaleDateString()}</span>}</button>)}</div><p className="small mt-2">{errors[0] ? 'Exam dates are currently unavailable.' : exams === null ? 'Loading exam dates...' : !exams.length ? 'No upcoming exams have been added yet.' : ''}</p><button className="btn w-full justify-center mt-3" onClick={() => setPage('Notifications')}>View notifications <ArrowRight size={14} /></button></div><div className="p-4 border-t border-slate-100"><span className="pill pill-green">LATEST LESSON</span>{latestLessons?.length ? latestLessons.map(lesson => <button className="block text-left mt-3" key={lesson.id} onClick={() => setPage('Tutorials')}><b className="text-xs">{lesson.title}</b><p className="small mt-2">Explore this tutorial</p></button>) : <p className="small mt-3">{errors[3] ? 'Lessons are currently unavailable.' : latestLessons === null ? 'Loading lessons...' : 'No published lessons yet.'}</p>}</div><button className="block w-full p-4 text-left border-t border-slate-100" onClick={() => setPage('Community')}><span className="pill">COMMUNITY</span><b className="block text-xs mt-3">Join the discussion</b><span className="small block mt-2">See posts from people you follow</span></button></section>
    <section className="card p-4"><h2 className="text-sm font-bold flex items-center gap-2"><TrendingUp size={17} className="text-emerald-600" />Recent progress</h2>{errors[1] ? <p className="small mt-3">Tutorial progress is currently unavailable.</p> : tutorials === null ? <p className="small mt-3">Loading tutorial progress...</p> : <div className="mt-4 space-y-3 text-xs"><p className="flex justify-between"><span>Tutorials completed</span><b>{completed}</b></p><p className="flex justify-between"><span>In progress</span><b>{inProgress}</b></p></div>}
      {errors[2] ? <p className="small mt-3">Mock results are currently unavailable.</p> : attempts === null ? <p className="small mt-3">Loading mock results...</p> : <div className="mt-4 text-xs"><p className="flex justify-between"><span>Recent completed mocks</span><b>{scored.length}</b></p><p className="flex justify-between mt-3"><span>Average score</span><b>{average === null ? 'No scores yet' : `${average.toFixed(1)}%`}</b></p>{average !== null && <div className="h-2 bg-slate-100 rounded mt-3 overflow-hidden" aria-hidden="true"><div className="h-full bg-indigo-600" style={{ width: `${Math.min(100, Math.max(0, average))}%` }} /></div>}<p className="small mt-2">Based on your latest 20 mock attempts.</p></div>}
      <button className="btn w-full justify-center mt-4" onClick={() => setPage('Mock Tests')}>View mock tests</button>
    </section>
  </div>;
}
