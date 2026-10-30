# JobForSure - Phase 1 MVP

A responsive React + Vite + Tailwind student dashboard with Supabase Auth and community persistence.

## Run locally

1. Install Node.js 20+.
2. Run `npm install`.
3. Run `npm run dev` and open the local address printed in the terminal.

Without Supabase credentials, authentication is unavailable and the app stays on the sign-in screen. Supabase is required to enter the student workspace.

## Connect Supabase Free Tier

1. Create a Supabase project and run the student learning schema from the project brief in SQL Editor. The checked-in `supabase/schema.sql` is an older, incompatible schema; do not run it for this setup.
2. Run `supabase/mock_simulation_functions.sql` after the schema for secure mock-test attempts and grading.
3. Run `supabase/practice_question_functions.sql` after the schema to enable secure question paging and answer grading.
4. Run `supabase/engineering_materials_practice_seed.sql` to add 200 original Engineering Materials questions. It creates the Mechanical Engineering branch and subject if they are missing.
5. Run `supabase/strength_of_materials_practice_seed.sql` to create a separate Strength of Materials subject with 200 original questions covering 20 major syllabus areas. It creates the Mechanical Engineering branch and subject if they are missing; repeated runs skip questions already seeded.
6. Run `supabase/civil_fluid_mechanics_practice_seed.sql` to add 200 original exam-style Fluid Mechanics questions. It creates the Civil Engineering branch and subject if they are missing.
7. Run `supabase/junior_engineer_2024_civil_paper_i_mock_seed.sql` to publish the original 200-question “Junior Engineer 2024 Civil Paper I” mock (120 minutes, +1 for a correct answer, −0.25 for an incorrect answer, and 0 for an unanswered question). It creates the Civil Engineering branch and subject if missing. The mock is stored under `OTHER` to match the current database exam-type constraint; its title and description identify the SSC JE exam. The seed is safe to rerun: it enforces the marking values on an existing complete mock and stops rather than overwriting a partial set.
8. Run `supabase/junior_engineer_2024_mechanical_paper_i_mock_seed.sql` to publish the original 200-question “Junior Engineer 2024 Mechanical Paper I” mock. It uses the same timing, marking, and safe rerun behavior as the Civil mock and creates the Mechanical Engineering branch and subject if missing. The mock is stored under `OTHER` to match the current database exam-type constraint.
9. Copy `.env.example` to `.env` and add your Project URL and publishable/anon key from Supabase settings.
10. Restart `npm run dev`.
11. In Supabase **Authentication → Providers**, enable Email and Google. For Google, configure the OAuth client in Google Cloud and enter its client ID/secret in Supabase.
12. In **Authentication → URL Configuration**, add the local app URL (for example `http://localhost:5173`) and your production URL to the allowed redirect URLs. The Google OAuth callback URL shown by Supabase must also be registered with Google.
13. Create an account or continue with Google. New accounts are asked to choose their exam goals, engineering branch, and preferred subject before entering the workspace. These preferences are saved to the user's Supabase Auth metadata and can be edited later from the Profile page; the dashboard and practice view use the saved exam and subject.

Never put a Supabase service-role/secret key in a Vite `VITE_` variable.

### SSC JE Civil DI-70 Paper-I practice mock

Run `supabase/junior_engineer_civil_paper_i_di70_mock_seed.sql` after the student learning schema and `supabase/mock_simulation_functions.sql`. It publishes one original, unofficial 200-question Civil-branch practice mock with a 50/50/100 section blueprint, 120-minute practice duration, +1/−0.25/0 practice scoring, 80 Moderate and 120 Hard items, and 75 theory/concept/application plus 25 short numerical Civil questions. The cycle-specific SSC pattern could not be verified while authoring; these proportions and settings are mock configuration, not a claim about current official rules. The seed checks existing questions and will not overwrite conflicting question content.

The full answer key and worked explanations are in `supabase/data/ssc_je_civil_di70_review.md`; the keyed question source is `supabase/data/ssc_je_civil_di70_questions.json`. Both are answer-bearing authoring/review files and should not be copied into browser assets. Regenerate deliverables with `python scripts/build_ssc_je_civil_di70_seed.py` after editing its authored question banks. See the review file for the editorial blueprint, validation summary, and source limitations. The supplied 2024 PDF was used only as a style reference; no question text or explanations were copied or paraphrased.

Notifications include a checked snapshot of recent FreeJobAlert exam notices with future exam or selection dates. This is not a live feed or a complete site-wide import; use the source links and verify dates with the conducting authority.

## Scope / known gaps

- React dashboard, tutorial tree, daily challenge, discussion creation, replies, votes, verified sample solution, exam tracker, and sample diagnostic mock.
- Published tutorials and student progress, exam listings and reminders, community posts, and mock attempts use their Supabase tables when configured.
- Mock simulations require the SQL RPC migration, which keeps answer keys in PostgreSQL and grades responses server-side.
- Subject practice uses a reusable `practice_questions` bank, loaded 15 per page and graded in PostgreSQL. The setup migration copies existing daily questions and answers into it.
- Verified answers require a trusted moderation/admin backend; users cannot self-verify through client-side inserts.
- Anonymous posts hide the author in the UI but are **not identity-anonymous to the backend**; admins/database operators can see author_id.
- In production, use server-side grading for daily challenges and mock tests, content moderation, anti-spam controls, and verified official exam feeds.
- Sample posts are local demonstration content, not real community activity.


## TGPSC AEE Civil mock

In Supabase SQL Editor, run these files in order: `supabase/mock_test_setup.sql`, `supabase/mock_simulation_functions.sql`, then `supabase/tgpsc_aee_civil_mock_seed.sql`. The setup creates the missing UUID-based branch, subject and mock tables, enables RLS, and grants catalogue access. It does not install the rest of the student workspace schema. It stops if legacy bigint subjects exist; do not use the older `schema.sql` for this setup. It publishes **TGPSC AEE Civil Exam** under Civil Engineering: 150 questions, 150 minutes, 300 maximum marks. Practice scoring is +2 correct and 0 wrong/unanswered. The 150-mark benchmark is a practice setting, not an official cutoff.

This is an **unofficial** practice version of the uploaded `MockTests/tspsc civil aee.pdf` (22 January 2023, Civil Paper II). It retains 108 normalized question transcriptions and uses 42 labeled clarifications, corrections, or similar concept questions. The answer key is independently derived. See `supabase/data/tgpsc_aee_civil_review.md` for source pages and per-question reasoning. Diagram-dependent adaptations are written as self-contained text.

The seed checks existing content before adding missing questions and refuses to overwrite conflicting questions or keys. Regenerate it with `python scripts/build_tgpsc_aee_civil_seed.py` after editing `supabase/data/tgpsc_aee_civil_questions.json`. Keep these answer-bearing files out of public browser assets.


## Previous Year Question Papers

The **Previous Papers** tab provides original GATE 2025 Mechanical, Electrical and Civil Engineering (CE1) PDFs, with branch filters, an embedded reader and separate official answer-key links.

Deploy the updated app; no SQL or database setup is needed for this section. PDF-backed GATE entries are excluded from Mock Tests. If previously imported, optionally run `supabase/archive_gate_pdf_mocks.sql` to unpublish those obsolete entries while preserving questions and attempt history. The older PDF mock seed and grading files are retained for historical reference.
