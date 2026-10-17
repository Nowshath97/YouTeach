# Separate AEE practice mocks

| Paper | Questions | Marks per correct answer | Maximum | Duration | Initial status |
|---|---:|---:|---:|---:|---|
| GS & General Abilities | 150 | 1 | 150 | 150 minutes | Unpublished draft |
| Civil Engineering | 150 | 2 | 300 | 150 minutes | Unpublished draft |

Each paper has its own questions numbered 1–150 and its own attempt/timer/results. Neither is a combined 300-question examination. Each question is a single-answer MCQ with four choices. Wrong/unanswered score zero under the labelled practice convention, pending notification verification.

## GS distribution

| Area | Questions |
|---|---:|
| Current affairs (regional, national, international) | 20 |
| Telangana history, culture and state formation | 25 |
| Indian polity and Constitution | 15 |
| Indian history and national movement | 15 |
| Indian and Telangana geography | 15 |
| Indian and Telangana economy | 15 |
| General science and technology | 15 |
| Environment and disaster management | 10 |
| Logical reasoning and analytical ability | 15 |
| Basic English | 5 |
| Total | 150 |

International relations are represented in current affairs; inclusion/disability and local government in polity; Telangana policies in current affairs/economy. These are draft crosswalks to the official generic Paper-I units, not official subject quotas. English-only practice does not reproduce Paper-I's official bilingual presentation.

## Civil distribution

| Area | Questions |
|---|---:|
| Building materials and construction | 10 |
| Strength of materials | 15 |
| Structural analysis | 15 |
| RCC design | 15 |
| Steel structures and prestressed concrete | 12 |
| Fluid mechanics and hydraulic machines | 15 |
| Hydrology and irrigation | 12 |
| Soil mechanics and foundations | 15 |
| Environmental engineering | 12 |
| Transportation (including railway/airport) | 12 |
| Surveying | 8 |
| Estimation, costing and construction management | 9 |
| Total | 150 |

Primary style classification: 67 numerical (44.7%), 46 conceptual/application (30.7%), 22 analytical (14.7%), 15 design-interpretation (10%). Categories overlap in practice: some design/analytical questions also require arithmetic, hence more arithmetic checks than `numerical` labels. Design interpretation does not certify current IS Code coverage. Civil difficulty targets are 90 medium and 60 hard; actual difficulty remains subject to independent review.

## Files and use

1. Run `supabase/mock_test_setup.sql` if mock tables are not already installed. Preserve existing data.
2. Run the separate GS seed `supabase/seeds/tgpsc_aee_2026_gs_mock_01.sql` and Civil seed `supabase/seeds/tgpsc_aee_2026_civil_mock_01.sql`. Alternatively, the requested compatibility file `tgpsc_aee_civil_2026_full_mock_01.sql` contains both separate seeds in one transaction. Use either method, not both unnecessarily; reimports are safe when unchanged.
3. Run `supabase/seeds/tgpsc_aee_civil_2026_validation.sql` to check both records.
4. Follow the unresolved publication gates in the quality report. The tests are deliberately invisible to students until explicitly published. GS maps to the existing General & Aptitude catalogue group and is also available alongside branch papers under existing filtering. Civil uses the Civil Engineering subject.

Original editable sources: `supabase/data/aee_2026_gs_source.txt` and `aee_2026_civil_source.txt`. Rebuild with `python scripts/build_aee_2026_mocks.py`, then run `python scripts/check_aee_2026_mocks.py` and `node scripts/test_aee_2026_mocks.mjs`. The local PostgreSQL test uses the existing PGlite installation under `tmp/gate2025/runtime`.

Rich question metadata and the 300 distinct concept identifiers are in the generated JSON banks. `tgpsc_aee_2026_answer_key.csv` lists paper, question number, key, subject, concept and target difficulty. Separate GS and Civil solution documents include every explanation. Keys and draft sources remain outside browser assets.
