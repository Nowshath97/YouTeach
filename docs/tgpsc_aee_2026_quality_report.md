# TGPSC AEE 2026 separate mocks: quality report

Status: **300-question draft package, not cleared for publication.** This is not a claim that all editorial acceptance criteria have passed. Both records are initially unpublished.

The latest direct request for separate mocks overrides the pasted specification's combined-test title and 1–300 ordering. Each paper uses its own 1–150 order, attempt, timer and result.

## Reference inspection

| Reference | Identification visible in document | Inspection |
|---|---|---|
| `2023_test GS.pdf` | Adda247 reproduction; GS & GA Paper I; 9 May 2023; first question page shows 10:00–12:30; Q150 appears on final page | 39 scanned pages; no extractable text. Windows OCR processed all pages. Cover and first question page visually checked. |
| `AEE Civil.pdf` | ACE reproduction labelled TSPSC 2022; exam held 22 January 2023; 150 questions stated in weightage table | 37 scanned pages; no extractable text. Windows OCR processed all pages. Cover, weightage table and first question page visually checked. No shift time established. |
| `MockTests/tspsc civil aee.pdf` | Existing workspace reproduction of 22 January 2023 Paper II | 22 pages; cover inspected. Existing curated/transcribed bank also inspected for novelty checks. Not independently re-transcribed in this task. |

These are third-party reproductions, not proof of an official answer key. Marked answers, participant selections and coaching solutions were not treated as authoritative. OCR can corrupt symbols, numerical data and two-column reading order. This task used the papers for patterns, not copied stems or options.

GS observations: chronology, matching, regional culture and policies, current events, statement evaluation, reasoning/data sufficiency and English are all present. The draft includes those syllabus areas, but contains fewer explicit coded multiple-statement and matching items than the reference. Its `analytical` label must not be interpreted as an actual count of those particular formats.

Civil observations: theory, linked statement/matching answers and numerical applications occur together. The inspected first question page includes production chronology, buoyancy, valuation, hydraulic-model scaling and a staggered connection diagram. Genuine engineering interpretation is needed beyond formula recall. The new package includes indeterminate beams, force/stiffness methods, eccentric bolt groups, pipe networks, groundwater/soil response, water treatment and construction economics. It does not reproduce that particular paper's subject weights exactly.

The ACE publisher's page-2 weightage table reports Building Materials 17; Surveying 15; FM/HM/OCF 25; Geotechnical 16; RCC/PSC 6; Hydrology 10; Irrigation 8; Construction Management 6; Estimation 4; Structural Analysis 10; Steel 2; Strength of Materials 15; Transportation/Railway 16. These sum to 150. This is the publisher's classification, not an official prescribed distribution. The requested proposed distribution was retained for broader practice, including Environmental Engineering. Complete numerical/conceptual/style frequencies of the reference papers have **not** been reliably tallied from the imperfect OCR; no invented percentages are supplied.

## Official-source research

- [Official gazetted category scheme](https://websitenew.tgpsc.gov.in/preview/UFJFU1NOT1RFL0dhemV0dGVkX0NhdGVnb3J5MjAyMjExMjcxMTA0MzkucGRmr95v17a0y2d8i13v): 150 questions/150 minutes/150 marks for GS; 150 questions/150 minutes/300 marks for the concerned subject. Its GS syllabus includes rights/inclusion, Telangana policies, international relations and English.
- [Official AEE notification 12/2022, Annexure III](https://websitenew.tspsc.gov.in/preview/DIRECTRECRUITMENTNOTI/12-2022-AEES-NOTIFN20220916120651.pdf): the indexed official text confirms the two-paper AEE scheme and GS syllabus. Direct PDF retrieval failed, so a complete current Civil syllabus reconciliation is **not** certified.
- [TGPSC syllabus web-note, 21 September 2026](https://websitenew.tgpsc.gov.in/preview/UFJFU1NOT1RFL1dFQi1OT1RFLVNZTExBQlVTLUNIQU5HRTIwMjYwOTIxMTYxNzE4LnBkZmFjY2Vzc3RpbWU9MjAyNy0xMi0zMQ==r95v17a0y2d8i13v): minor changes accompany the relevant notification. This note is not an AEE recruitment notification.
- [Official archived 2023 Civil response paper](https://websitenew.tspsc.gov.in/preview/Notification/CBRT/122022/22124.pdf): indexed entries show +2 correct and 0 wrong. This is historical evidence, not verification of a 2026 marking rule.

An applicable AEE-specific **2026 notification was not verified**. Third-party recruitment claims were not accepted as proof. Timing/marks are provisional practice settings using the verifiable official scheme. Wrong/unanswered scores are zero as an explicitly labelled **practice** convention; the applicable 2026 penalty remains unresolved. No official qualifying threshold is asserted: required `passing_marks=0` is documented as a schema placeholder.

All 20 current-affairs items have a primary-source URL and check date in `aee_2026_gs_questions.json`. Sources include ISRO, UN/UNFCCC, WHO, UNESCO, PIB, the Brazilian BRICS presidency and Telangana government portals. They use dated 2024–2026 events and avoid unsupported current appointment lists. Source coverage is not comprehensive coverage of all 2026 current affairs. Recheck before publication. Stable GS history/culture/polity/science items have editorial explanations but are not labelled independently source-certified.

## Checks actually executed

- Source parsing: 150 GS and 150 Civil rows, four distinct choices, one selected key, nonempty explanation for every row.
- Reproducible shuffling preserves the relationship among question, key and explanation. Counts by subject match the requested proposed distributions.
- Local novelty screening inspected **292 unique normalized questions** across available seed payloads and JSON banks. New stems contain no exact normalized duplicates within the package or against that corpus. Similarity candidates are saved in `supabase/data/aee_2026_duplicate_candidates.json`; these are heuristic candidates, not proof of semantic novelty.
- Editorial novelty review replaced a simple Euler ratio, an eccentric-prestress edge-stress calculation, a simple trigonometric height calculation and an annual-exceedance complement problem. Replacements test snap-through, a T-beam compression block, EDM correction/reduction and a Gumbel quantile. Local topic overlap alone does not imply repetition, but further mathematical-template review is required.
- **112 independent Python arithmetic checks** executed. The checker uses stated problem data rather than evaluating the explanation text; it checks rounding and scalar numeric-option uniqueness where applicable. Output is saved in `aee_2026_numerical_validation.json`. Passing arithmetic does not certify model applicability or every engineering assumption.
- PGlite PostgreSQL integration executed setup, both existing Civil seeds (250 questions), both new seeds twice, validation SQL, a submitted-attempt preservation fixture, review-explanation retrieval and a deliberately conflicting key. It verified two new unpublished records, 300 new rows, 450 total marks, independent 150-minute settings, preserved old keys/IDs and refusal to overwrite conflict/history.
- The seeds add the missing nullable `mock_questions.explanation` column if necessary. This supports the requested stored explanations without new tables. Existing question values are not backfilled or changed. Existing review RPC already reads this field.
- No production Supabase connection was used and no live database import was performed. Thus live duplicate/attempt review is not represented as completed. A live exact-text guard runs at first import; semantic checks still require review.

## Publication gates still open

1. Verify the applicable 2026 recruitment notification, full Civil syllabus, code editions and marking rules. Adjust the practice settings if needed **before** any real attempts.
2. Independently review all answers and distractors, including GS factual claims, Civil idealizations and multi-answer numeric options. Stated design equations are problem assumptions, not assertions that a particular code edition permits every design. Code-interpretation coverage is not independently certified.
3. Upgrade or replace items that an experienced paper setter judges too elementary. The 90 medium/60 hard Civil counts are **targets assigned for editorial review, not demonstrated difficulty**. No claim of zero easy questions or calibrated exam equivalence is made.
4. Expand explicit matching and multiple-statement formats if needed after a complete reference-pattern tally. The present draft is application/numerical-heavy and does not fully reproduce the reference format mix.
5. Review live existing question concepts and mathematical templates, not just string similarity. Only local banks were available.
6. Review coverage gaps (for example engineering geology, expansive-soil foundations, dam/weir detail and other notification-specific units) against the actual Civil syllabus. Airport/rail topics are included but not every possible syllabus subtopic is represented.
7. Only then explicitly publish the chosen mocks through the normal admin workflow. Rerunning these seeds does not publish drafts or overwrite an existing publication decision.

The progress manifest preserves these unresolved items. The package contains all 300 draft questions and is ready for editorial review, **not publication-ready certification**.
