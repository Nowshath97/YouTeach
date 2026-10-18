# Full Length Mock 03 - import notes

Title: `TGPSC AEE 2026 - General Studies Full Length Mock 03`.

Run the complete `supabase/seeds/tgpsc_aee_gs_mock_03.sql` in Supabase SQL Editor after the existing UUID `mock_test_setup.sql` schema is installed.
The new test starts unpublished. It neither renames the master draft/Mock 02 nor modifies other mocks, questions or attempts. Identical reruns preserve IDs and publication status; differing existing content causes a rollback.
Metadata uses the existing private `aee_master_question_metadata` table. Scoring +1/0 and duration 150 minutes are practice settings, not certification of an official 2026 scheme. Passing marks 0 is a catalogue placeholder.
After reviewing the imported paper, publication can be enabled explicitly:

```sql
UPDATE public.mock_tests SET is_published = TRUE
WHERE title = 'TGPSC AEE 2026 - General Studies Full Length Mock 03'
RETURNING id, title, is_published;
```

## Review scope

Historical notification 12/2022 baseline; latest recruitment-specific scheme not certified
Selected 2024-2025 events; not a comprehensive latest-12-month digest
Previously supplied examination papers informed style; no new corpus frequency analysis claimed
Official contemporary claims have source links. Remaining stable facts have editorial review but are not represented as fully independently source-validated. Human subject review remains pending. No psychometric results are invented.
Accessible moderate/hard bank; the optional 15/75/45/15 target is not forced onto predominantly core-knowledge items
Direct knowledge emphasis; actual counts reported instead of claiming the suggested format quotas
Economy contains five India, five Telangana and five development items; four dated statistics and no arithmetic. Its illustrative application is a definition/application of industrial infrastructure rather than another named scheme.
Local duplicate audit: 0 exact matches; 0 near-text candidates. Related syllabus concepts can recur; see the manifest for candidate IDs.

## Blueprint

| Section | Questions |
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
| Total | 150 |

Formats: {'direct': 107, 'statements': 9, 'application': 10, 'matching': 9, 'chronology': 3, 'sequence': 1, 'logic': 9, 'numerical': 1, 'di': 1}
Difficulty estimates: {'moderate': 122, 'hard': 28}
Answer positions: {'1': 38, '2': 38, '3': 37, '4': 37}

Rebuild: `python scripts/build_aee_gs_mock_03.py`. Validate: `node scripts/test_aee_gs_mock_03.mjs`.
