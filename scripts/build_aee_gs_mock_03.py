"""Build the separate, unpublished Full Length Mock 03 from its reviewed source."""
import collections
import csv
import difflib
import json
import random
import re
from pathlib import Path
import build_aee_gs_master as base

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / 'supabase/data'
DOCS = ROOT / 'docs'
TITLE = 'TGPSC AEE 2026 - General Studies Full Length Mock 03'
PREFIX = 'aee_gs_mock_03'
CURRENT_URLS = [
 'https://www.isro.gov.in/halo-orbit-insertion-adtya-l1.html',
 'https://www.isro.gov.in/XPoSat.html',
 'https://www.nobelprize.org/uploads/2025/04/annual-report-2024.pdf',
 'https://www.nobelprize.org/uploads/2025/04/annual-report-2024.pdf',
 'https://www.nobelprize.org/uploads/2025/04/annual-report-2024.pdf',
 'https://www.nobelprize.org/prizes/economic-sciences/2024/summary/',
 'https://whc.unesco.org/en/list/1711',
 'https://www.g20.org.za/g20-media/commencement-of-media-accreditation-for-the-g20-summit/',
 'https://www.cbd.int/article/cop-16-opens-in-cali-colombia-2024',
 'https://www.unccd.int/cop16',
 'https://www.icc-cricket.com/media-releases/rohit-leads-india-to-icc-men-s-champions-trophy-glory',
 'https://www.fide.com/fide-world-championship-game-14-gukesh-d-claims-title/',
 'https://www.unep.org/en/news-and-stories/press-release/world-environment-day-2025-mobilizes-commitment-action-end-plastic',
 'https://www.expo2025.or.jp/en/overview/',
 'https://wmo.int/news/media-centre/wmo-confirms-2024-warmest-year-record-about-155degc-above-pre-industrial-level',
]
BUDGET = 'https://www.telangana.gov.in/news/press-releases/2024/07/deputy-cm-presents-budget-for-the-year-2024-25/'
SOURCES = {
 'Telangana income statistic': BUDGET,
 'Telangana agriculture share': BUDGET,
 'National SDG score': 'https://www.pib.gov.in/Pressreleaseshare.aspx?PRID=2032857&lang=2&reg=48',
 'Female labour participation statistic': 'https://www.mospi.gov.in/sites/default/files/press_release/Press_note_AR_PLFS_2023_24_22092024.pdf',
 'NABARD role': 'https://financialservices.gov.in/node/4297',
 'Irrigation seasons': 'https://irrigation.telangana.gov.in/',
 'Rythu Bandhu policy type': 'https://gadwal.telangana.gov.in/scheme/rythu-bandhu-scheme/',
 'Rythu Bima policy type': 'https://mahabubabad.telangana.gov.in/scheme/rythu-bima/',
 'Kanti Velugu service': 'https://bhoopalapally.telangana.gov.in/scheme/kanti-velugu/',
}
COUNTS = [15,12,10,15,15,12,15,8,10,13,5,12,8]

def main():
    rows, section, units = [], None, []
    for line in (DATA / (PREFIX+'_source.txt')).read_text(encoding='utf-8').splitlines():
        if not line or line.startswith('#'):
            continue
        if line.startswith('@ '):
            section, raw = line[2:].split('|')
            units = list(map(int, raw.split(',')))
            continue
        fields = line.split('|')
        assert len(fields) == 8, fields
        topic, form, stem, correct, *tail = fields
        rows.append(dict(id=len(rows)+1, section=section, syllabus_units=units,
                         topic=topic, item_format=form, question_text=stem.replace('\\n','\n'),
                         _correct=correct, _wrong=tail[:3], explanation=tail[3]))
    assert len(rows)==150
    assert list(collections.Counter(r['section'] for r in rows).values()) == COUNTS
    rng=random.Random(2026101803)
    positions=[0]*38+[1]*38+[2]*37+[3]*37
    rng.shuffle(positions)
    for r,p in zip(rows,positions):
        correct=r.pop('_correct'); opts=r.pop('_wrong')
        assert len(set([correct,*opts]))==4, r['topic']
        rng.shuffle(opts);opts.insert(p,correct)
        r.update(options=[dict(value=str(i),text=t) for i,t in enumerate(opts,1)],
                 correct_answer=str(p+1),marks=1,negative_marks=0,
                 difficulty_target=('hard' if r['item_format'] in {'matching','statements','logic','di'} else 'moderate'),
                 difficulty_status='editorial estimate; no empirical calibration',
                 time_budget_seconds=70 if r['item_format'] in {'matching','statements','logic','di'} else 45,
                 as_of_date='2026-10-18', independent_review_status='not_performed',
                 evidence_status='editorial factual/derivation review completed; independent source review pending',
                 source_urls=[],answer_key_audit_status='editorial second pass; automated structural checks separately reported')
        if r['id']<=15:
            r['source_urls']=[CURRENT_URLS[r['id']-1]]
            r['evidence_status']='dated official-source claim checked during authoring; independent review pending'
        elif r['topic'] in SOURCES:
            r['source_urls']=[SOURCES[r['topic']]]
            r['evidence_status']='official-source claim checked during authoring; independent review pending'
        elif r['section']=='Indian Constitution, Governance & Public Policy':
            r['source_urls']=[base.CONSTITUTION]
            r['evidence_status']='constitutional reference supplied; item-level source review pending'
        elif r['section']=='Logical Reasoning, Analytical Ability & Data Interpretation':
            r['evidence_status']='editorial derivation; independently recomputed in test script'
    assert len({base.normalise(r['question_text']) for r in rows})==150
    old=[]
    for path in DATA.glob('*questions.json'):
        if path.name.startswith(PREFIX):continue
        bank=json.loads(path.read_text(encoding='utf-8-sig'))
        if isinstance(bank,list):
            old.extend((base.normalise(q['question_text']),path.name) for q in bank if isinstance(q,dict) and q.get('question_text'))
    exact=[];near=[]
    for r in rows:
        t=base.normalise(r['question_text'])
        best=(0,None)
        for text,bank in old:
            if t==text:exact.append(dict(question=r['id'],bank=bank))
            # Broad candidate screen for editorial review, not a semantic guarantee.
            if len(set(t.split()) & set(text.split())) / max(1,len(set(t.split()) | set(text.split()))) > .40:
                similarity=difflib.SequenceMatcher(None,t,text).ratio()
                if similarity>best[0]:best=(similarity,bank)
        if best[0]>.72:near.append(dict(question=r['id'],bank=best[1],similarity=round(best[0],3)))
    assert not exact,exact
    manifest=dict(title=TITLE,questions=150,language='English',duration_minutes=150,total_marks=150,
        is_published=False,practice_scoring=dict(correct=1,wrong=0,unanswered=0),
        section_counts=dict(collections.Counter(r['section'] for r in rows)),
        format_counts=dict(collections.Counter(r['item_format'] for r in rows)),
        difficulty_counts=dict(collections.Counter(r['difficulty_target'] for r in rows)),
        answer_counts=dict(sorted(collections.Counter(r['correct_answer'] for r in rows).items())),
        planning_seconds=sum(r['time_budget_seconds'] for r in rows),
        syllabus_reference=base.SYLLABUS_URL,
        syllabus_status='Historical notification 12/2022 baseline; latest recruitment-specific scheme not certified',
        current_affairs_window='Selected 2024-2025 events; not a comprehensive latest-12-month digest',
        reference_papers='Previously supplied examination papers informed style; no new corpus frequency analysis claimed',
        difficulty_deviation='Accessible moderate/hard bank; the optional 15/75/45/15 target is not forced onto predominantly core-knowledge items',
        format_deviation='Direct knowledge emphasis; actual counts reported instead of claiming the suggested format quotas',
        economy_numericals=0,independent_review_status='pending',psychometric_status='No pilot data; no calibration claimed',
        duplicate_check=dict(exact_matches=exact,near_text_candidates=near,scope='Available local question JSON only; live database and semantic originality not certified'))
    write=lambda path,obj:path.write_text(json.dumps(obj,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    write(DATA/(PREFIX+'_questions.json'),rows);write(DATA/(PREFIX+'_manifest.json'),manifest)
    base.TITLE=TITLE
    sql=base.make_sql(rows)
    # Mock 03 must never rename or reuse the Mock 02 bank's earlier draft title.
    start=sql.index(' -- Reuse an earlier import')
    end=sql.index(' SELECT id INTO v_branch',start)
    sql=sql[:start]+sql[end:]
    sql=sql.replace('scripts/build_aee_gs_master.py','scripts/build_aee_gs_mock_03.py')
    sql=sql.replace('Editorial moderate/high targets','Editorial moderate/hard targets')
    sql=sql.replace('Current-event facts dated through 2026-10-18.','Selected dated 2024-2025 current events; not a latest-news digest.')
    (ROOT/'supabase/seeds/tgpsc_aee_gs_mock_03.sql').write_text(sql,encoding='utf-8')
    paper=['# '+TITLE,'','Unofficial practice paper. 150 questions; practice duration 150 minutes.','']
    solutions=['# '+TITLE+' - solutions','', 'Editorial answer key; independent subject review pending.','']
    for r in rows:
        if r['id']==1 or r['section']!=rows[r['id']-2]['section']:
            paper+=['## '+r['section'],'']
        body=[f"### Q{r['id']}",'',r['question_text'],'']+[f"{chr(64+int(o['value']))}. {o['text']}" for o in r['options']]+['']
        paper+=body
        solutions+=body+[f"**Answer: {chr(64+int(r['correct_answer']))} ({r['correct_answer']})**",'',r['explanation'],'',r['evidence_status'],'']
        if r['source_urls']:solutions+=['Sources: '+', '.join(r['source_urls']),'']
    (DOCS/(PREFIX+'_paper.md')).write_text('\n'.join(paper),encoding='utf-8')
    (DOCS/(PREFIX+'_solutions.md')).write_text('\n'.join(solutions),encoding='utf-8')
    with (DATA/(PREFIX+'_answer_key.csv')).open('w',encoding='utf-8',newline='') as f:
        w=csv.writer(f);w.writerow(['question','section','topic','correct_option','correct_text'])
        for r in rows:w.writerow([r['id'],r['section'],r['topic'],r['correct_answer'],r['options'][int(r['correct_answer'])-1]['text']])
    notes=['# Full Length Mock 03 - import notes','',f'Title: `{TITLE}`.','',
      'Run the complete `supabase/seeds/tgpsc_aee_gs_mock_03.sql` in Supabase SQL Editor after the existing UUID `mock_test_setup.sql` schema is installed.',
      'The new test starts unpublished. It neither renames the master draft/Mock 02 nor modifies other mocks, questions or attempts. Identical reruns preserve IDs and publication status; differing existing content causes a rollback.',
      'Metadata uses the existing private `aee_master_question_metadata` table. Scoring +1/0 and duration 150 minutes are practice settings, not certification of an official 2026 scheme. Passing marks 0 is a catalogue placeholder.',
      'After reviewing the imported paper, publication can be enabled explicitly:', '', '```sql',
      "UPDATE public.mock_tests SET is_published = TRUE",f"WHERE title = '{TITLE}'",'RETURNING id, title, is_published;','```','',
      '## Review scope','',manifest['syllabus_status'],manifest['current_affairs_window'],manifest['reference_papers'],
      'Official contemporary claims have source links. Remaining stable facts have editorial review but are not represented as fully independently source-validated. Human subject review remains pending. No psychometric results are invented.',
      manifest['difficulty_deviation'],manifest['format_deviation'],
      'Economy contains five India, five Telangana and five development items; four dated statistics and no arithmetic. Its illustrative application is a definition/application of industrial infrastructure rather than another named scheme.',
      f"Local duplicate audit: {len(exact)} exact matches; {len(near)} near-text candidates. Related syllabus concepts can recur; see the manifest for candidate IDs.",'',
      '## Blueprint','','| Section | Questions |','|---|---:|']
    notes += [f'| {k} | {v} |' for k,v in manifest['section_counts'].items()]
    notes += ['| Total | 150 |','',f"Formats: {manifest['format_counts']}",f"Difficulty estimates: {manifest['difficulty_counts']}",f"Answer positions: {manifest['answer_counts']}",
              '', 'Rebuild: `python scripts/build_aee_gs_mock_03.py`. Validate: `node scripts/test_aee_gs_mock_03.mjs`.']
    (DOCS/(PREFIX+'_readme.md')).write_text('\n'.join(notes)+'\n',encoding='utf-8')
    print(json.dumps({k:manifest[k] for k in ['questions','section_counts','format_counts','answer_counts','planning_seconds','duplicate_check']},indent=2))

if __name__=='__main__':main()
