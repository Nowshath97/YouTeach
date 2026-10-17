"""Build two separate unpublished mocks from original, reviewable source rows.

No database/network credentials are read. Does not publish or upload anything.
"""
import collections
import csv
import difflib
import hashlib
import json
import random
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / 'supabase/data'
SEEDS = ROOT / 'supabase/seeds'
DOCS = ROOT / 'docs'
STYLES = {'N': 'numerical', 'C': 'conceptual/application', 'A': 'analytical', 'D': 'design interpretation'}
CONFIG = {
 'gs': ('TGPSC AEE 2026 - General Studies Full Length Mock 01', 'General Studies', 1),
 'civil': ('TGPSC AEE 2026 - Civil Engineering Full Length Mock 01', 'Civil Engineering', 2),
}
CA_SOURCES = [
 'https://www.isro.gov.in/spadex_docking.html',
 'https://www.isro.gov.in/media_isro/pdf/Annexure_Achievements_during_FY_2025_2026.pdf',
 'https://www.isro.gov.in/media_isro/pdf/Annexure_Achievements_during_FY_2025_2026.pdf',
 'https://www.nobelprize.org/prizes/peace/2025/summary/',
 'https://unfccc.int/news/cop29-un-climate-conference-agrees-to-triple-finance-to-developing-countries-protecting-lives-and',
 'https://unfccc.int/cop30',
 'https://invest.telangana.gov.in/why-telangana/',
 'https://bhubharati.telangana.gov.in/assets/images/userManuals/G_O_Ms_No_36_Dated_14_04_2025.pdf',
 'https://whc.unesco.org/en/list/1739/',
 'https://www.un.org/observances/international-years',
 'https://www.un.org/observances/international-years',
 'https://www.un.org/en/node/222894',
 'https://www.who.int/news/item/20-05-2025-world-health-assembly-adopts-historic-pandemic-agreement-to-make-the-world-more-equitable-and-safer-from-future-pandemics',
 'https://www.pib.gov.in/Pressreleaseshare.aspx?PRID=2090480&lang=2&reg=48',
 'https://www.un.org/en/node/74111',
 'https://brics.br/en/news/brazil-announces-indonesia-as-full-member-of-brics',
 'https://www.pib.gov.in/Pressreleaseshare.aspx?PRID=2145147&lang=2&reg=48',
 'https://www.isro.gov.in/media_isro/pdf/AdityaL1_second_Cycle_AO_01042026.pdf',
 'https://rythubharosa.telangana.gov.in/',
 'https://www.isro.gov.in/Coronagraphs_India_Aditya_L1_Europe_Proba_3.html',
]


def normalize(text):
    text = re.sub(r'^\[[^]]+\]\s*', '', text)
    return ' '.join(re.findall(r'[a-z0-9]+', text.lower()))


def read_rows(kind):
    rows, topic = [], None
    for line in (DATA / f'aee_2026_{kind}_source.txt').read_text(encoding='utf-8').splitlines():
        if not line or line.startswith('#'):
            continue
        if line.startswith('@ '):
            topic = line[2:]
            continue
        fields = line.split('|')
        assert len(fields) == 8 and topic, line
        style, concept, stem, correct, *rest = fields
        options, explanation = [correct, *rest[:3]], rest[3]
        assert style in STYLES and all(x.strip() for x in fields)
        assert len(set(x.casefold() for x in options)) == 4
        rows.append(dict(subject=topic, topic=concept, concept_id=f'{kind}:{concept.replace(" ", "-")}',
                         question_text=stem, options=options, correct_text=correct,
                         explanation=explanation, style=STYLES[style]))
    assert len(rows) == 150, (kind, len(rows))
    assert len({r['concept_id'] for r in rows}) == 150
    assert len({normalize(r['question_text']) for r in rows}) == 150
    # Difficulty is an editorial target, not a calibrated psychometric claim.
    # A separate reviewer must confirm/reclassify before publication.
    hard_counts = {10: 4, 15: 6, 12: 5, 8: 3, 9: 3}
    grouped = collections.defaultdict(list)
    for row in rows:
        grouped[row['subject']].append(row)
    for items in grouped.values():
        hard = hard_counts[len(items)] if kind == 'civil' else max(1, len(items)//3)
        for index, row in enumerate(items):
            row['difficulty_target'] = 'hard' if index >= len(items)-hard else 'medium'
            row['difficulty_validation'] = 'pending independent review; not calibrated'
            row['syllabus_unit'] = row['subject']
            row['reference_pattern'] = 'Original application/numerical item; reference-paper style, not copied'
            row['source_verification'] = 'editorial derivation; independent subject review required'
            row['numerical_validation'] = 'not applicable'
    if kind == 'gs':
        for row, source in zip(rows[:20], CA_SOURCES):
            row['source_url'] = source
            row['source_verification'] = 'primary source checked 2026-10-17; recheck before publication'
    else:
        assert collections.Counter(r['difficulty_target'] for r in rows) == {'medium': 90, 'hard': 60}
    return rows


def old_questions():
    found = {}
    for path in (ROOT / 'supabase').glob('*.sql'):
        text = path.read_text(encoding='utf-8-sig')
        for match in re.finditer(r'\$questions\$\s*(\[.*?\])\s*\$questions\$', text, re.S):
            for question in json.loads(match.group(1)):
                found[normalize(question['question_text'])] = dict(text=question['question_text'], source=str(path.relative_to(ROOT)))
    # Include all available JSON question banks as well as SQL payloads.
    for path in DATA.glob('*.json'):
        if 'aee_2026' in path.name:
            continue
        try:
            bank = json.loads(path.read_text(encoding='utf-8-sig'))
            if isinstance(bank, list):
                for question in bank:
                    if isinstance(question, dict) and question.get('question_text'):
                        found[normalize(question['question_text'])] = dict(text=question['question_text'], source=str(path.relative_to(ROOT)))
        except (ValueError, TypeError):
            continue
    return found


def quote(text):
    return "'" + text.replace("'", "''") + "'"


def seed(kind, rows):
    title, branch, marks = CONFIG[kind]
    description = (
        f'Original unofficial {"Paper I GS/GA" if kind == "gs" else "Paper II Civil"} practice draft: '
        f'150 questions, 150 minutes, {150*marks} marks. Separate paper and timer. '
        f'Practice scoring +{marks} correct, 0 wrong/unanswered; this is not a verified 2026 penalty rule. '
        'Provisional syllabus reference; applicable AEE-specific 2026 notification and marking require verification. '
        'Passing marks 0 is a schema placeholder, not an official cutoff. Unpublished pending independent content review.'
    )
    payload = [dict(display_order=r['number'], question_text='['+r['subject']+'] '+r['question_text'],
                    options=r['options'], correct_answer=r['correct_answer'], explanation=r['explanation']) for r in rows]
    return f"""-- Generated by scripts/build_aee_2026_mocks.py. Run mock_test_setup.sql first.
-- Original draft, NOT publication-cleared. No existing questions or attempts are overwritten.
-- Explanation is required by the requested review feature; older schemas lack this column.
BEGIN;
ALTER TABLE public.mock_questions ADD COLUMN IF NOT EXISTS explanation TEXT;
DO $seed$
DECLARE v_branch UUID; v_subject UUID; v_test UUID; v_new BOOLEAN := FALSE;
 v_seed JSONB := $questions$
{json.dumps(payload, ensure_ascii=True, indent=2)}
$questions$::JSONB;
BEGIN
 PERFORM pg_advisory_xact_lock(hashtext({quote(title)}));
 SELECT id INTO v_branch FROM public.engineering_branches WHERE name={quote(branch)};
 IF v_branch IS NULL THEN
  INSERT INTO public.engineering_branches(name,code,description,is_active)
  VALUES({quote(branch)},'AEE26-'||substr(gen_random_uuid()::TEXT,1,8),'AEE practice catalogue',TRUE) RETURNING id INTO v_branch;
 END IF;
 INSERT INTO public.subjects(branch_id,name,code,description,display_order,is_active)
 VALUES(v_branch,{quote(branch)},'AEE26-'||substr(gen_random_uuid()::TEXT,1,8),'Separate full-length AEE practice paper',0,TRUE)
 ON CONFLICT(branch_id,name) DO NOTHING;
 SELECT id INTO v_subject FROM public.subjects WHERE branch_id=v_branch AND name={quote(branch)};
 IF (SELECT count(*) FROM public.mock_tests WHERE title={quote(title)})>1 THEN
  RAISE EXCEPTION 'Duplicate test titles require manual resolution';
 END IF;
 SELECT id INTO v_test FROM public.mock_tests WHERE title={quote(title)};
 IF v_test IS NULL THEN
  INSERT INTO public.mock_tests(title,description,exam_type,subject_id,duration_minutes,total_marks,passing_marks,is_published)
  VALUES({quote(title)},{quote(description)},'OTHER',v_subject,150,{150*marks},0,FALSE) RETURNING id INTO v_test;
  v_new := TRUE;
 ELSE
  IF EXISTS(SELECT 1 FROM public.mock_tests WHERE id=v_test AND
    (duration_minutes IS DISTINCT FROM 150 OR total_marks IS DISTINCT FROM {150*marks} OR subject_id IS DISTINCT FROM v_subject))
   OR (SELECT count(*) FROM public.mock_questions WHERE mock_test_id=v_test)<>150
   OR EXISTS(SELECT 1 FROM public.mock_questions e LEFT JOIN jsonb_to_recordset(v_seed)
    AS q(display_order INT,question_text TEXT,options JSONB,correct_answer TEXT,explanation TEXT)
    ON e.display_order=q.display_order WHERE e.mock_test_id=v_test AND
    (q.display_order IS NULL OR e.question_text IS DISTINCT FROM q.question_text
     OR e.options IS DISTINCT FROM q.options OR e.correct_answer IS DISTINCT FROM q.correct_answer
     OR e.explanation IS DISTINCT FROM q.explanation OR e.question_type IS DISTINCT FROM 'mcq'
     OR e.marks IS DISTINCT FROM {marks} OR e.negative_marks IS DISTINCT FROM 0)) THEN
   RAISE EXCEPTION 'Existing mock differs from seed; refusing to overwrite questions or attempt history';
  END IF;
 END IF;
 IF v_new THEN
  -- Live exact-text guard. Semantic/template novelty still requires human review.
  IF EXISTS(SELECT 1 FROM public.mock_questions e JOIN jsonb_to_recordset(v_seed)
   AS q(question_text TEXT) ON
   regexp_replace(lower(regexp_replace(e.question_text,'^\\[[^]]+\\]\\s*','')),'[^a-z0-9]+',' ','g') =
   regexp_replace(lower(regexp_replace(q.question_text,'^\\[[^]]+\\]\\s*','')),'[^a-z0-9]+',' ','g')) THEN
   RAISE EXCEPTION 'An existing database question matches this draft; review duplicates before importing';
  END IF;
  INSERT INTO public.mock_questions(mock_test_id,question_text,question_type,options,correct_answer,explanation,marks,negative_marks,display_order)
  SELECT v_test,q.question_text,'mcq',q.options,q.correct_answer,q.explanation,{marks},0,q.display_order
  FROM jsonb_to_recordset(v_seed) AS q(display_order INT,question_text TEXT,options JSONB,correct_answer TEXT,explanation TEXT);
 END IF;
 IF (SELECT count(*) FROM public.mock_questions WHERE mock_test_id=v_test)<>150
  OR (SELECT count(DISTINCT display_order) FROM public.mock_questions WHERE mock_test_id=v_test)<>150
  OR (SELECT sum(marks) FROM public.mock_questions WHERE mock_test_id=v_test)<>{150*marks} THEN
  RAISE EXCEPTION 'Invalid question count, display order or marks';
 END IF;
 RAISE NOTICE 'Separate AEE practice draft ready; publication status was not changed on repeat imports.';
END;
$seed$;
COMMIT;
"""


def main():
    SEEDS.mkdir(exist_ok=True); DOCS.mkdir(exist_ok=True)
    existing = old_questions()
    manifest = dict(status='unpublished drafts; not cleared for publication', live_database_checked=False,
                    checked_local_bank_questions=len(existing), applicable_2026_notification_verified=False,
                    official_2026_negative_marking_verified=False, papers={})
    candidates = []
    keys = []
    all_normalized = set()
    for kind in CONFIG:
        rows = read_rows(kind)
        # Shuffle question and option order reproducibly while keeping explanation and key together.
        rng = random.Random(20261017 + (1 if kind == 'civil' else 0))
        rng.shuffle(rows)
        for number, row in enumerate(rows, 1):
            norm = normalize(row['question_text'])
            assert norm not in existing, ('exact duplicate', row['concept_id'])
            assert norm not in all_normalized, ('cross-paper duplicate', row['concept_id'])
            all_normalized.add(norm)
            words = set(norm.split())
            shortlist = sorted(existing, key=lambda old: len(words & set(old.split()))/max(1,len(words | set(old.split()))), reverse=True)[:20]
            best = max(shortlist, key=lambda old: difflib.SequenceMatcher(None,norm,old).ratio()) if shortlist else None
            if best:
                score = difflib.SequenceMatcher(None,norm,best).ratio()
                candidates.append(dict(paper=kind,concept=row['concept_id'], similarity=round(score,4),
                                       nearest_existing=existing[best]))
            options = row['options'][:]; rng.shuffle(options)
            row['correct_answer'] = 'ABCD'[options.index(row.pop('correct_text'))]
            row['options'] = [dict(value=k,text=v) for k,v in zip('ABCD',options)]
            row['number'] = number
            keys.append([kind,number,row['correct_answer'],row['subject'],row['topic'],row['difficulty_target']])
        (DATA/f'aee_2026_{kind}_questions.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
        (SEEDS/f'tgpsc_aee_2026_{kind}_mock_01.sql').write_text(seed(kind,rows),encoding='utf-8')
        explanations = ['# '+CONFIG[kind][0], '', 'Unofficial draft answer key and solutions. Independent review pending.', '']
        for r in rows:
            explanations += [f"## {r['number']}. {r['subject']} - answer {r['correct_answer']}",r['question_text'],'',r['explanation'],'']
        (DOCS/f'tgpsc_aee_2026_{kind}_solutions.md').write_text('\n'.join(explanations),encoding='utf-8')
        manifest['papers'][kind] = dict(title=CONFIG[kind][0],questions=150,marks=150*CONFIG[kind][2],duration_minutes=150,
            subjects=dict(collections.Counter(r['subject'] for r in rows)),
            difficulty_targets=dict(collections.Counter(r['difficulty_target'] for r in rows)),
            styles=dict(collections.Counter(r['style'] for r in rows)),
            source_sha256=hashlib.sha256((DATA/f'aee_2026_{kind}_source.txt').read_bytes()).hexdigest())
    (DATA/'aee_2026_duplicate_candidates.json').write_text(json.dumps(sorted(candidates,key=lambda c:-c['similarity']),indent=2)+'\n',encoding='utf-8')
    (DATA/'aee_2026_progress.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
    with (DOCS/'tgpsc_aee_2026_answer_key.csv').open('w',newline='',encoding='utf-8') as stream:
        writer=csv.writer(stream);writer.writerow(['paper','question','correct_option','subject','topic','difficulty_target']);writer.writerows(keys)
    combined = '\n'.join((SEEDS/f'tgpsc_aee_2026_{kind}_mock_01.sql').read_text(encoding='utf-8').replace('BEGIN;\n', '', 1).removesuffix('COMMIT;\n') for kind in CONFIG)
    (SEEDS/'tgpsc_aee_civil_2026_full_mock_01.sql').write_text('-- Convenience package: creates TWO SEPARATE mocks, not a combined 300-question test.\nBEGIN;\n'+combined+'\nCOMMIT;\n',encoding='utf-8')
    print(json.dumps(manifest,indent=2))


if __name__ == '__main__':
    main()
