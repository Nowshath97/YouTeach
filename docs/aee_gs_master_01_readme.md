# AEE General Studies Full Length Mock 02 - import and quality notes

## Deliverables

- `supabase/data/aee_gs_master_01_questions.json`: all 150 questions in the supplied id/section/question_text/options/correct_answer/explanation shape, plus curriculum and evidence metadata.
- `supabase/seeds/tgpsc_aee_gs_master_mock_01.sql`: application-compatible PostgreSQL/Supabase import.
- `supabase/data/aee_gs_master_01_answer_key.csv`: answer key and topic map.
- `docs/aee_gs_master_01_solutions.md`: complete question paper, options and explanations.
- `supabase/data/aee_gs_master_01_manifest.json`: counts, baseline, scoring and version.
- `supabase/data/aee_gs_master_01_duplicate_audit.json`: local text comparison results.

## Import

Run `mock_test_setup.sql` if the UUID mock schema has not already been configured. Then run the entire master seed in Supabase SQL Editor.
The new title is `TGPSC AEE 2026 - General Studies Full Length Mock 02`. It starts unpublished. It does not modify the existing 2026 GS mock, Civil mock, their manual SQL edits, or attempt history.
If this bank was already imported as `TGPSC AEE - General Studies Master Mock 01`, the seed renames and reuses that test. If both titles exist it stops for review. Renaming is rolled back if content validation fails.
Identical reruns preserve question IDs and publication status. A content or metadata difference causes a rollback instead of an overwrite.
Curriculum metadata is stored in `public.aee_master_question_metadata`, keyed by question UUID and inaccessible to ordinary authenticated/anonymous direct reads. Question keys and explanations remain behind the existing secure question/review RPC design.
Options use string values 1 through 4. Statement combinations have one selectable answer, not multiple simultaneous selections. All 14 matching stems use the existing side-by-side formatter.

## Scope and provenance

The curriculum baseline is the official AEE Notification 12/2022, Annexure III: https://websitenew.tspsc.gov.in/preview/DIRECTRECRUITMENTNOTI/12-2022-AEES-NOTIFN20220916120651.pdf
This is a verified historical AEE baseline, not certification of every change in a later recruitment notification. English is provided; no Telugu translation is implied.
The four supplied PDFs contain examination booklets (52, 52, 48 and 52 pages), not syllabus-only documents. Their statement combinations, chronology and matching formats informed style and breadth. Booklet instructions to candidates were treated as source content, not instructions to the authoring agent.
The pasted draft contains 50 items, covering current affairs and science. Four objects contain invalid JSON escape sequences in mathematical notation. It was used as contextual draft material rather than imported blindly. The completed bank is newly authored/adapted from the requested themes; it is not represented as 150 independently novel concepts or copied previous-paper questions.
One substantive draft correction: WTO MC13 approved accession packages; Comoros and Timor-Leste became members later, in August 2024. No supplied draft key was accepted merely because it was supplied.
Authoring reference date: 2026-10-18. Current-affairs questions deliberately name the event/year or enactment context. This is a selected 2024-2026 set, not an exhaustive digest of every event through the reference date.
Source URLs identify factual references where available. `evidence_status` distinguishes checked dated primary-source facts from editorial derivation. An automated answer check is not independent factual certification.

## Blueprint

| Reporting section | Questions |
|---|---:|
| Current Affairs & International Relations | 15 |
| General Science & Technology | 12 |
| Environment & Disaster Management | 10 |
| Economy & Development of India and Telangana | 15 |
| Geography of India and Telangana | 15 |
| Modern Indian History & National Movement | 12 |
| Indian Constitution, Governance & Public Policy | 15 |
| Social Inclusion & Rights | 8 |
| Telangana Society, Culture, Heritage & Literature | 10 |
| Telangana History, Movement & State Formation | 13 |
| Telangana State Policies | 5 |
| Logical Reasoning, Analytical Ability & Data Interpretation | 12 |
| Basic English | 8 |
| **Total** | **150** |

All 15 syllabus units are mapped. This allocation is an editorial blueprint; no official section-wise weightage is claimed.
Difficulty targets: {'high': 66, 'moderate': 84}. These are author estimates, not measured item difficulties.
Formats: {'statements': 27, 'matching': 14, 'chronology': 6, 'application': 77, 'numerical': 26}.
Answer positions: {'1': 38, '2': 38, '3': 37, '4': 37}. Statement order is permuted with corresponding option-code remapping to avoid a repeated last-statement-is-false cue.
Per-item planning budgets sum to 8820 seconds within the 9000-second practice timer; these are estimates, not observed response times.
Practice scoring is +1 correct, 0 wrong/unanswered. Zero passing marks is only the required catalogue placeholder. Neither the penalty nor a qualifying cutoff is asserted as an official 2026 rule.

## Validation and practical limits

Run `python scripts/build_aee_gs_master.py` and `node scripts/test_aee_gs_master.mjs` from the repository root.
Checks cover 150 unique slots/topics, four distinct options, valid keys, all syllabus units, explanations, all 26 numerical items, explicit mappings for all 14 matching items, all 27 statement permutations, selected exhaustive reasoning checks, and matching-parser compatibility.
The isolated PostgreSQL-compatible test exercises a fresh import, repeat import, preservation of a pre-existing GS bank, private metadata, preserved publication state and submitted score, and refusal to overwrite a later manual edit.
Local text audit: 0 exact matches and 0 near-text candidates against available JSON banks. Related concepts can still recur, and live database content was not queried.
Independent subject review and a human-facing preview of the imported paper remain appropriate before publication. This package is complete as an unpublished practice database; it is not an official TGPSC paper.

## Pilot psychometric review

Collect anonymised item responses, timing, omissions and option selections from a representative pilot. Estimate item facility and item-total discrimination, examine which distractors attract responses, and investigate flagged keys or wording before interpreting a total score.
Review reliability and section coverage at test level; inspect accessibility and subgroup fairness with adequate samples. Difficulty labels can then be revised using observed data. No discrimination, reliability coefficient, percentile, pass prediction or psychometric calibration is fabricated in this package.
