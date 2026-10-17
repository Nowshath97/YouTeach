# Current paper library

These papers now appear in **Previous Papers** as PDF resources with branch filters and official answer-key links. No seed or grading migration is required. PDF-backed entries are excluded from Mock Tests. If already imported, `supabase/archive_gate_pdf_mocks.sql` optionally unpublishes them without deleting history.

The following documents the superseded PDF mock implementation and historical validation. Its installation instructions do not apply to the current paper library.

---

# GATE 2025 full previous-year mocks

These are independent practice interfaces for the complete master papers published by IIT Roorkee. No questions have been invented, shortened or replaced. The candidate reads the official paper in a linked PDF viewer and answers the corresponding question in JobForSure.

| Mock | Questions | MCQ / MSQ / NAT | Time | Marks |
| --- | --- | --- | --- | --- |
| Mechanical Engineering (ME) | 65 | 38 / 1 / 26 | 180 minutes | 100 |
| Electrical Engineering (EE) | 65 | 42 / 4 / 19 | 180 minutes | 100 |
| Civil Engineering, Session 1 (CE1) | 65 | 32 / 11 / 22 | 180 minutes | 100 |

## Install in the existing database

1. Deploy the updated React app so the original-paper viewer, MSQ checkboxes and NAT input are available.
2. Run `supabase/gate_2025_grading.sql` in Supabase SQL Editor.
3. Run `supabase/gate_2025_previous_year_mock_seed.sql` in Supabase SQL Editor.

These files create no tables or columns. They reuse `mock_tests`, `mock_questions`, `mock_attempts` and `mock_attempt_answers`. Existing question options JSON carries the public paper URL, page and response type; private `correct_answer` text carries the typed official grading key. The existing `start_mock_attempt` RPC returns the public options without returning the key.

The seed reuses an exact branch-name UUID subject if available. If no matching subject exists and your existing `mock_tests.subject_id` permits NULL, the paper is imported without a subject link and remains visible in the all-tests catalogue. If that column is mandatory, the seed stops and asks for an existing subject mapping. It does not create branches, subjects or replacement tables.

Rerunning the seed fills missing matching questions and refuses to overwrite conflicting question data. The grading migration retains legacy plain-text keys for existing mocks. Run the upgraded grading file again if an older `mock_simulation_functions.sql` subsequently replaces the submit function.

## Scoring

- Correct responses receive the question's original one or two marks.
- Wrong MCQs deduct exactly one-third of that question's marks, accumulated before rounding the final score to two decimals.
- MSQs require the exact option set. There is no partial credit or negative marking.
- NATs accept the inclusive ranges from the final key, including disjoint accepted ranges. There is no negative marking.
- Unanswered questions receive zero. These three keys contain no MTA questions.
- Displayed reference cutoffs are the official 2025 General-category qualifying scores (ME 35.8, EE 25, CE 29.2). Other categories have different cutoffs; the practice interface does not certify qualification.

The original fixed exam frame remains: response controls and navigation stay visible while the PDF scrolls internally. Some original PDF pages contain multiple questions. The interface identifies the current question number and page; candidates must answer that number. On browsers without embedded PDF support or reliable page-fragment navigation, use the Open original PDF link and navigate to the indicated page. The official website must remain reachable; no copyrighted question text/diagrams are republished in the application bundle.

## Official sources

Checked 16 October 2026. Each question's type, marks, key and starting PDF page are recorded in `supabase/data/gate_2025_official_papers.json`; SHA-256 hashes identify the downloaded source versions. This file contains keys and must not be served as a public app asset.

- Master-paper/final-key index and marking rules: https://gate2025.iitr.ac.in/question-papers.html
- ME paper: https://gate2025.iitr.ac.in/doc/2025/2025_QP/ME.pdf
- ME final key: https://gate2025.iitr.ac.in/doc/2025/2025_Key/ME_Keys.pdf
- EE paper: https://gate2025.iitr.ac.in/doc/2025/2025_QP/EE.pdf
- EE final key: https://gate2025.iitr.ac.in/doc/2025/2025_Key/EE_Keys.pdf
- CE1 paper: https://gate2025.iitr.ac.in/doc/2025/2025_QP/CE1.pdf
- CE1 final key: https://gate2025.iitr.ac.in/doc/2025/2025_Key/CE1_Keys.pdf
- 2025 category cutoffs: https://gate2025.iitr.ac.in/cut-off-marks.html

## Validation and regeneration

- All 195 question numbers and page mappings are present; each paper totals 100 marks, including 15 General Aptitude marks.
- Key tables and representative question-page mappings were inspected visually.
- A temporary local PostgreSQL engine passed 740 key/range cases, all-correct submission of all three papers, exact rational penalties, duplicate-answer rejection, key-access restrictions, and reruns preserving attempts.
- Production build passed. No live Supabase database or signed-in browser attempt was used.

Regenerate SQL with `python scripts/build_gate_2025_mock_seeds.py`. To repeat the local database checks, install the isolated engine with `npm install --no-save --package-lock=false --prefix tmp/gate2025/runtime @electric-sql/pglite`, then run `node scripts/test_gate_2025_mocks.mjs` from the repository root. The test creates a disposable in-memory database; it never connects to Supabase.

`scripts/extract_gate_2025_metadata.py` can rebuild the factual metadata from the six source PDFs in `tmp/gate2025`. It requires `pymupdf`. The extraction intentionally stores no question wording or diagrams.
