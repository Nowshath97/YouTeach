"""Build a standalone, unpublished AEE GS master mock without touching existing mocks."""
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
TITLE = 'TGPSC AEE 2026 - General Studies Full Length Mock 02'
AS_OF = '2026-10-18'
SYLLABUS_URL = 'https://websitenew.tspsc.gov.in/preview/DIRECTRECRUITMENTNOTI/12-2022-AEES-NOTIFN20220916120651.pdf'
CONSTITUTION = 'https://www.legislative.gov.in/static/uploads/2025/08/7af1daa22d65f9d04c00ae9b9aa5a799.pdf'
CURRENT_SOURCES = [
 ['https://www.wto.org/english/news_e/news24_e/acc_26feb24_e.htm', 'https://www.wto.org/english/tratop_e/devel_e/teccop_e/ta_annrep24_e.pdf'],
 ['https://unfccc.int/news/cop29-un-climate-conference-agrees-to-triple-finance-to-developing-countries-protecting-lives-and'],
 ['https://www.isro.gov.in/Mission_GSLVF16_NISAR.html'],
 ['https://www.isro.gov.in/mission_SpaDeX.html', 'https://new1.isro.gov.in/spadex_undocking_successful.html'],
 ['https://www.isro.gov.in/ISRO_EN/Successful_Launch_of_Axiom_Mission.html', 'https://www.isro.gov.in/Axiom04_mission_successfully_concluded_return_ISRO_Gaganyatri_ShubhanshuShukla.html'],
 ['https://www.who.int/news/item/20-05-2025-world-health-assembly-adopts-historic-pandemic-agreement-to-make-the-world-more-equitable-and-safer-from-future-pandemics'],
 ['https://www.un.org/bbnjagreement/en'],
 ['https://whc.unesco.org/en/list/1739'],
 ['https://taxation-customs.ec.europa.eu/carbon-border-adjustment-mechanism/cbam-definitive-regime_en'],
 ['https://brics.br/pt-br/noticias/brasil-anuncia-indonesia-como-membro-pleno-do-brics'],
 ['https://www.un.org/observances/international-years'],
 ['https://unfccc.int/process-and-meetings/conferences/past-conferences/un-climate-change-conference-belem-november-2025/the-road-to-belem'],
 ['https://www.nobelprize.org/uploads/2025/10/press-peaceprize2025.pdf'],
 ['https://www.paralympic.org/paris-2024-paralympic-games/results/medalstandings'],
 ['https://static.pib.gov.in/WriteReadData/specificdocs/documents/2025/feb/doc2025213501801.pdf', CONSTITUTION],
]
PRIMARY_BY_TOPIC = {
 'Forest rights individual community distinction': ['https://tribal.nic.in/downloads/FRA/FRAActnRulesBook.pdf'],
 'PESA geographic scope': ['https://tribal.nic.in/downloads/Statistics/OtherReport/BhuriaReportFinal.pdf'],
 'Ramappa construction technology': ['https://whc.unesco.org/en/list/1570'],
 'Article 371D policy objective': [CONSTITUTION, 'https://www.mha.gov.in/sites/default/files/2022-08/CCSAP-Appendix-060111%5B1%5D.pdf'],
 'Movement safeguard chronology': ['https://www.mha.gov.in/sites/default/files/2022-08/CCSAP-Appendix-060111%5B1%5D.pdf', 'https://www.telangana.gov.in/government-orders/'],
 'GO610 corrective purpose': ['https://www.telangana.gov.in/government-orders/'],
 'Formation legal dates distinction': ['https://www.mha.gov.in/sites/default/files/2022-08/ExpertCommittee_CapitalAP_Final_0%5B1%5D_0.pdf'],
 'Mission programme distinctions': ['https://www.telangana.gov.in/mission-kakatiya/', 'https://yadadri.telangana.gov.in/scheme/mission-bhagiratha/', 'https://hyderabad.telangana.gov.in/scheme/haritha-haram/', 'https://ipass.telangana.gov.in/about.aspx/1000'],
 'Craft technique discrimination': ['https://www.tourism.telangana.gov.in/page/arts-crafts', 'https://jangaon.telangana.gov.in/en-handicraft/'],
 'Oggu narrative tradition': ['https://www.tourism.telangana.gov.in/page/arts-crafts'],
 'Literary author attribution': ['https://commons.wikimedia.org/wiki/File:Andhrula_Sanghika_Charithra_-_Suravaram_Pratap_Reddy.pdf', 'https://wbchse.wb.gov.in/wp-content/uploads/2022/06/Part-1.pdf'],
 'Industrial approval facilitation limits': ['https://ipass.telangana.gov.in/about.aspx/1000'],
}

def normalise(text):
    return ' '.join(re.findall(r'[a-z0-9]+', text.lower()))

def read_rows():
    rows = []
    section = None
    for line_no, line in enumerate((DATA / 'aee_gs_master_01_source.txt').read_text(encoding='utf-8').splitlines(), 1):
        if not line or line.startswith('#'):
            continue
        if line.startswith('@ '):
            section, units = line[2:].split('|')
            continue
        fields = line.split('|')
        assert section and len(fields) == 9, (line_no, len(fields))
        difficulty, topic, form, stem, correct, *rest = fields
        distractors, explanation = rest[:3], rest[3]
        assert difficulty in {'M', 'H'} and all(field.strip() for field in fields)
        assert len(set(' '.join(x.split()) for x in [correct, *distractors])) == 4, topic
        rows.append(dict(id=len(rows)+1, section=section, topic=topic, item_format=form,
                         question_text=stem.replace('\\n', '\n'), _correct=correct,
                         _distractors=distractors, explanation=explanation,
                         syllabus_units=[int(unit) for unit in units.split(',')],
                         difficulty_target='moderate' if difficulty == 'M' else 'high',
                         difficulty_status='editorial target; not empirically calibrated'))
    assert len(rows) == 150
    assert len({normalise(row['question_text']) for row in rows}) == 150
    return rows

def sql_quote(text):
    return "'" + text.replace("'", "''") + "'"

def vary_statement_order(row, rng):
    """Avoid the repeated cue that the last statement is the false one."""
    if row['item_format'] != 'statements':
        return
    lines = row['question_text'].splitlines()
    indices = [i for i,line in enumerate(lines) if re.match(r'^\d+\. ', line)]
    assert indices and indices == list(range(indices[0],indices[-1]+1)), row['topic']
    original = [lines[i] for i in indices]
    order = list(range(len(original)))
    rng.shuffle(order)
    mapping = {str(old+1):str(new+1) for new,old in enumerate(order)}
    for new, old in enumerate(order):
        lines[indices[new]] = str(new+1)+'. '+original[old].split('. ',1)[1]
    row['question_text'] = '\n'.join(lines)
    row['statement_original_order'] = [i+1 for i in order]
    def remap(option):
        numbers = sorted([mapping[n] for n in re.findall(r'\d+',option)],key=int)
        assert numbers, option
        code = numbers[0] if len(numbers)==1 else ', '.join(numbers[:-1])+' and '+numbers[-1]
        return code + (' only' if option.endswith(' only') else '')
    row['_correct'] = remap(row['_correct'])
    row['_distractors'] = [remap(option) for option in row['_distractors']]
    # Explanations describe the claims rather than referring to shuffled positions.
    if row['topic']=='WTO accession stages':
        row['explanation']='Approval and effective membership were distinct stages. Comoros became a member on 21 August and Timor-Leste on 30 August 2024; approval at MC13 did not itself make membership effective on the conference date.'

def make_sql(rows):
    payload = []
    for row in rows:
        payload.append(dict(display_order=row['id'], question_text=f"[{row['section']}] {row['question_text']}",
                            options=row['options'], correct_answer=row['correct_answer'], explanation=row['explanation'],
                            metadata={k:v for k,v in row.items() if k not in {'question_text','options','correct_answer','explanation'}}))
    description = ('Unofficial English AEE Paper-I master practice test: 150 questions, 150 minutes, 150 marks. '
                   'All 15 units mapped to historical official AEE Notification 12/2022. '
                   'Editorial moderate/high targets; not empirically calibrated. '
                   'Practice scoring +1 correct, 0 otherwise; negative marking and qualifying cutoff are not official claims. '
                   f'Current-event facts dated through {AS_OF}. Independent subject review pending.')
    return '''-- Generated by scripts/build_aee_gs_master.py. Prerequisite: mock_test_setup.sql.
-- Creates a NEW unpublished mock; never replaces existing tests, questions or attempts.
BEGIN;
ALTER TABLE public.mock_questions ADD COLUMN IF NOT EXISTS explanation TEXT;
CREATE TABLE IF NOT EXISTS public.aee_master_question_metadata (
 question_id UUID PRIMARY KEY REFERENCES public.mock_questions(id) ON DELETE CASCADE,
 metadata JSONB NOT NULL
);
ALTER TABLE public.aee_master_question_metadata ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.aee_master_question_metadata FROM anon,authenticated;
DO $master$
DECLARE v_branch UUID; v_subject UUID; v_test UUID;
 v_payload JSONB := $master_payload$PAYLOAD$master_payload$::JSONB;
BEGIN
 PERFORM pg_advisory_xact_lock(hashtext(TITLE));
 -- Reuse an earlier import of this same question bank under its draft title.
 PERFORM pg_advisory_xact_lock(hashtext('TGPSC AEE - General Studies Master Mock 01'));
 IF EXISTS(SELECT 1 FROM public.mock_tests WHERE title='TGPSC AEE - General Studies Master Mock 01') THEN
  IF (SELECT count(*) FROM public.mock_tests WHERE title='TGPSC AEE - General Studies Master Mock 01')<>1
   OR EXISTS(SELECT 1 FROM public.mock_tests WHERE title=TITLE) THEN
   RAISE EXCEPTION 'Both draft and final titles, or duplicate drafts, exist; review before importing';
  END IF;
  UPDATE public.mock_tests SET title=TITLE WHERE title='TGPSC AEE - General Studies Master Mock 01';
 END IF;
 SELECT id INTO v_branch FROM public.engineering_branches WHERE name='General Studies';
 IF v_branch IS NULL THEN
  INSERT INTO public.engineering_branches(name,code,description,is_active)
  VALUES('General Studies','GS-'||substr(gen_random_uuid()::TEXT,1,8),'General Studies practice',TRUE) RETURNING id INTO v_branch;
 END IF;
 INSERT INTO public.subjects(branch_id,name,code,description,display_order,is_active)
 VALUES(v_branch,'General Studies','GS-'||substr(gen_random_uuid()::TEXT,1,8),'General Studies practice',0,TRUE)
 ON CONFLICT(branch_id,name) DO NOTHING;
 SELECT id INTO v_subject FROM public.subjects WHERE branch_id=v_branch AND name='General Studies';
 IF (SELECT count(*) FROM public.mock_tests WHERE title=TITLE)>1 THEN
  RAISE EXCEPTION 'Duplicate master mock titles; review catalogue before importing';
 END IF;
 SELECT id INTO v_test FROM public.mock_tests WHERE title=TITLE;
 IF v_test IS NULL THEN
  INSERT INTO public.mock_tests(title,description,exam_type,subject_id,duration_minutes,total_marks,passing_marks,is_published)
  VALUES(TITLE,DESCRIPTION,'OTHER',v_subject,150,150,0,FALSE) RETURNING id INTO v_test;
  INSERT INTO public.mock_questions(mock_test_id,question_text,question_type,options,correct_answer,explanation,marks,negative_marks,display_order)
  SELECT v_test,r.question_text,'mcq',r.options,r.correct_answer,r.explanation,1,0,r.display_order
  FROM jsonb_to_recordset(v_payload) AS r(display_order INT,question_text TEXT,options JSONB,correct_answer TEXT,explanation TEXT);
  INSERT INTO public.aee_master_question_metadata(question_id,metadata)
  SELECT q.id,r.metadata FROM public.mock_questions q JOIN jsonb_to_recordset(v_payload)
   AS r(display_order INT,metadata JSONB) ON q.display_order=r.display_order WHERE q.mock_test_id=v_test;
 END IF;
 IF (SELECT count(*) FROM public.mock_questions WHERE mock_test_id=v_test)<>150
 OR (SELECT count(DISTINCT display_order) FROM public.mock_questions WHERE mock_test_id=v_test)<>150
 OR EXISTS(SELECT 1 FROM public.mock_tests WHERE id=v_test AND
   (duration_minutes<>150 OR total_marks<>150 OR subject_id IS DISTINCT FROM v_subject))
 OR EXISTS(SELECT 1 FROM public.mock_questions q LEFT JOIN jsonb_to_recordset(v_payload)
  AS r(display_order INT,question_text TEXT,options JSONB,correct_answer TEXT,explanation TEXT,metadata JSONB)
  ON q.display_order=r.display_order
  LEFT JOIN public.aee_master_question_metadata m ON m.question_id=q.id
  WHERE q.mock_test_id=v_test AND (r.display_order IS NULL
   OR q.question_text IS DISTINCT FROM r.question_text OR q.options IS DISTINCT FROM r.options
   OR q.correct_answer IS DISTINCT FROM r.correct_answer OR q.explanation IS DISTINCT FROM r.explanation
   OR q.question_type IS DISTINCT FROM 'mcq' OR q.marks IS DISTINCT FROM 1
   OR q.negative_marks IS DISTINCT FROM 0 OR m.metadata IS DISTINCT FROM r.metadata)) THEN
  RAISE EXCEPTION 'Existing master mock differs; refusing to overwrite questions, metadata or attempt history';
 END IF;
 RAISE NOTICE 'Master mock ready: 150 questions. Existing publication status preserved; new imports remain unpublished.';
END;
$master$;
COMMIT;
'''.replace('PAYLOAD', json.dumps(payload, ensure_ascii=True, indent=2)).replace('TITLE', sql_quote(TITLE)).replace('DESCRIPTION', sql_quote(description))

def main():
    rows = read_rows()
    rng = random.Random(20261018)
    positions = [0]*38 + [1]*38 + [2]*37 + [3]*37
    rng.shuffle(positions)
    for row, position in zip(rows, positions):
        vary_statement_order(row, rng)
        correct = row.pop('_correct')
        options = row.pop('_distractors')
        rng.shuffle(options)
        options.insert(position, correct)
        row['options'] = [dict(value=str(i),text=option) for i,option in enumerate(options,1)]
        row['correct_answer'] = str(position+1)
        row['marks'] = 1
        row['negative_marks'] = 0
        row['time_budget_seconds'] = 50 if row['difficulty_target']=='moderate' else 70
        row['evidence_status'] = 'editorial derivation; independent subject review pending'
        row['source_urls'] = PRIMARY_BY_TOPIC.get(row['topic'], [])
        if row['id'] <= 15:
            row['source_urls'] = CURRENT_SOURCES[row['id']-1]
            row['evidence_status'] = 'dated primary-source facts checked during authoring; independent item review pending'
        elif (row['section']=='Indian Constitution, Governance & Public Policy' and row['item_format'] != 'application') or row['topic'] in {'Money Bill time and recommendation','Dissolved Panchayat election exception','Ordinance duration reassembly','Finance Commission versus GST Council','Constitutional amendment basic structure','CAG audit and PAC scrutiny'}:
            row['source_urls'] = [CONSTITUTION]
        row['as_of_date'] = AS_OF
        row['reference_role'] = 'syllabus mapping and supplied-paper style; not an official answer-key claim'
    counts = collections.Counter(row['section'] for row in rows)
    manifest = dict(title=TITLE,version='1.0.0',as_of_date=AS_OF,language='English',questions=150,
                    duration_minutes=150,total_marks=150,is_published=False,
                    syllabus_reference=dict(notification='12/2022',url=SYLLABUS_URL,
                                            status='historical official AEE baseline; latest recruitment-specific changes not certified'),
                    scoring=dict(correct=1,wrong=0,unanswered=0,status='practice configuration; not an official penalty claim'),
                    section_counts=dict(counts), difficulty_counts=dict(collections.Counter(r['difficulty_target'] for r in rows)),
                    format_counts=dict(collections.Counter(r['item_format'] for r in rows)),
                    answer_counts=dict(sorted(collections.Counter(r['correct_answer'] for r in rows).items())),
                    psychometric_status='No pilot response data: difficulty, discrimination, reliability and distractor functioning are not estimated.',
                    publication_status='Unpublished pending independent subject review and pilot validation',
                    source_sha256=hashlib.sha256((DATA/'aee_gs_master_01_source.txt').read_bytes()).hexdigest())
    (DATA/'aee_gs_master_01_questions.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    (DATA/'aee_gs_master_01_manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    (SEEDS/'tgpsc_aee_gs_master_mock_01.sql').write_text(make_sql(rows),encoding='utf-8')
    with (DATA/'aee_gs_master_01_answer_key.csv').open('w',newline='',encoding='utf-8') as stream:
        writer=csv.writer(stream)
        writer.writerow(['question','section','topic','correct_option','correct_text','difficulty_target','format'])
        for row in rows:
            writer.writerow([row['id'],row['section'],row['topic'],row['correct_answer'],row['options'][int(row['correct_answer'])-1]['text'],row['difficulty_target'],row['item_format']])
    solutions=['# '+TITLE,'','Unofficial original practice items. One selectable option per question, including statement combinations.','']
    for row in rows:
        solutions += [f"## Q{row['id']}. {row['section']} / {row['topic']}",'',row['question_text'],'']
        solutions += [f"{option['value']}. {option['text']}" for option in row['options']]
        solutions += ['',f"**Answer: {row['correct_answer']}**",row['explanation'],'']
        if row['source_urls']:
            solutions += ['References: '+', '.join(row['source_urls']),'']
    (DOCS/'aee_gs_master_01_solutions.md').write_text('\n'.join(solutions),encoding='utf-8')
    # Text novelty only: an exact/near-text audit cannot certify semantic novelty.
    old_items = []
    for path in DATA.glob('*.json'):
        if 'aee_gs_master_01' in path.name:
            continue
        try:
            bank = json.loads(path.read_text(encoding='utf-8-sig'))
        except (ValueError, OSError):
            continue
        if isinstance(bank,list):
            old_items.extend((normalise(q['question_text']),str(path.relative_to(ROOT))) for q in bank if isinstance(q,dict) and q.get('question_text'))
    exact, near = [], []
    for row in rows:
        text=normalise(row['question_text']); words=set(text.split())
        for other,path in old_items:
            if text==other:
                exact.append(dict(question=row['id'],bank=path))
            elif len(words & set(other.split()))/max(1,len(words | set(other.split())))>.45:
                similarity=difflib.SequenceMatcher(None,text,other).ratio()
                if similarity>.76:
                    near.append(dict(question=row['id'],bank=path,similarity=round(similarity,3)))
    audit=dict(exact_text_matches=exact,near_text_candidates=near,
               scope='Local JSON question banks only; semantic novelty and live database not certified')
    (DATA/'aee_gs_master_01_duplicate_audit.json').write_text(json.dumps(audit,indent=2)+'\n',encoding='utf-8')
    assert not exact, exact
    report=['# AEE General Studies Full Length Mock 02 - import and quality notes','',
            '## Deliverables','',
            '- `supabase/data/aee_gs_master_01_questions.json`: all 150 questions in the supplied id/section/question_text/options/correct_answer/explanation shape, plus curriculum and evidence metadata.',
            '- `supabase/seeds/tgpsc_aee_gs_master_mock_01.sql`: application-compatible PostgreSQL/Supabase import.',
            '- `supabase/data/aee_gs_master_01_answer_key.csv`: answer key and topic map.',
            '- `docs/aee_gs_master_01_solutions.md`: complete question paper, options and explanations.',
            '- `supabase/data/aee_gs_master_01_manifest.json`: counts, baseline, scoring and version.',
            '- `supabase/data/aee_gs_master_01_duplicate_audit.json`: local text comparison results.','',
            '## Import','',
            'Run `mock_test_setup.sql` if the UUID mock schema has not already been configured. Then run the entire master seed in Supabase SQL Editor.',
            f'The new title is `{TITLE}`. It starts unpublished. It does not modify the existing 2026 GS mock, Civil mock, their manual SQL edits, or attempt history.',
            'If this bank was already imported as `TGPSC AEE - General Studies Master Mock 01`, the seed renames and reuses that test. If both titles exist it stops for review. Renaming is rolled back if content validation fails.',
            'Identical reruns preserve question IDs and publication status. A content or metadata difference causes a rollback instead of an overwrite.',
            'Curriculum metadata is stored in `public.aee_master_question_metadata`, keyed by question UUID and inaccessible to ordinary authenticated/anonymous direct reads. Question keys and explanations remain behind the existing secure question/review RPC design.',
            'Options use string values 1 through 4. Statement combinations have one selectable answer, not multiple simultaneous selections. All 14 matching stems use the existing side-by-side formatter.','',
            '## Scope and provenance','',
            f'The curriculum baseline is the official AEE Notification 12/2022, Annexure III: {SYLLABUS_URL}',
            'This is a verified historical AEE baseline, not certification of every change in a later recruitment notification. English is provided; no Telugu translation is implied.',
            'The four supplied PDFs contain examination booklets (52, 52, 48 and 52 pages), not syllabus-only documents. Their statement combinations, chronology and matching formats informed style and breadth. Booklet instructions to candidates were treated as source content, not instructions to the authoring agent.',
            'The pasted draft contains 50 items, covering current affairs and science. Four objects contain invalid JSON escape sequences in mathematical notation. It was used as contextual draft material rather than imported blindly. The completed bank is newly authored/adapted from the requested themes; it is not represented as 150 independently novel concepts or copied previous-paper questions.',
            'One substantive draft correction: WTO MC13 approved accession packages; Comoros and Timor-Leste became members later, in August 2024. No supplied draft key was accepted merely because it was supplied.',
            f'Authoring reference date: {AS_OF}. Current-affairs questions deliberately name the event/year or enactment context. This is a selected 2024-2026 set, not an exhaustive digest of every event through the reference date.',
            'Source URLs identify factual references where available. `evidence_status` distinguishes checked dated primary-source facts from editorial derivation. An automated answer check is not independent factual certification.','',
            '## Blueprint','',
            '| Reporting section | Questions |','|---|---:|']
    report += [f'| {section} | {count} |' for section,count in counts.items()]
    report += ['| **Total** | **150** |','',
               'All 15 syllabus units are mapped. This allocation is an editorial blueprint; no official section-wise weightage is claimed.',
               f"Difficulty targets: {manifest['difficulty_counts']}. These are author estimates, not measured item difficulties.",
               f"Formats: {manifest['format_counts']}.",
               f"Answer positions: {manifest['answer_counts']}. Statement order is permuted with corresponding option-code remapping to avoid a repeated last-statement-is-false cue.",
               f"Per-item planning budgets sum to {sum(r['time_budget_seconds'] for r in rows)} seconds within the 9000-second practice timer; these are estimates, not observed response times.",
               'Practice scoring is +1 correct, 0 wrong/unanswered. Zero passing marks is only the required catalogue placeholder. Neither the penalty nor a qualifying cutoff is asserted as an official 2026 rule.','',
               '## Validation and practical limits','',
               'Run `python scripts/build_aee_gs_master.py` and `node scripts/test_aee_gs_master.mjs` from the repository root.',
               'Checks cover 150 unique slots/topics, four distinct options, valid keys, all syllabus units, explanations, all 26 numerical items, explicit mappings for all 14 matching items, all 27 statement permutations, selected exhaustive reasoning checks, and matching-parser compatibility.',
               'The isolated PostgreSQL-compatible test exercises a fresh import, repeat import, preservation of a pre-existing GS bank, private metadata, preserved publication state and submitted score, and refusal to overwrite a later manual edit.',
               f'Local text audit: {len(exact)} exact matches and {len(near)} near-text candidates against available JSON banks. Related concepts can still recur, and live database content was not queried.',
               'Independent subject review and a human-facing preview of the imported paper remain appropriate before publication. This package is complete as an unpublished practice database; it is not an official TGPSC paper.','',
               '## Pilot psychometric review','',
               'Collect anonymised item responses, timing, omissions and option selections from a representative pilot. Estimate item facility and item-total discrimination, examine which distractors attract responses, and investigate flagged keys or wording before interpreting a total score.',
               'Review reliability and section coverage at test level; inspect accessibility and subgroup fairness with adequate samples. Difficulty labels can then be revised using observed data. No discrimination, reliability coefficient, percentile, pass prediction or psychometric calibration is fabricated in this package.','']
    (DOCS/'aee_gs_master_01_readme.md').write_text('\n'.join(report),encoding='utf-8')
    print(json.dumps({k:manifest[k] for k in ['questions','section_counts','difficulty_counts','format_counts','answer_counts']},indent=2))

if __name__=='__main__':
    main()
