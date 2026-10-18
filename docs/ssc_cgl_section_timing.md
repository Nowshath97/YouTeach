# SSC CGL sectional timing

Deploy the frontend and run `supabase/ssc_cgl_section_timing.sql` in Supabase SQL Editor **after** `mock_pause_resume.sql` and the installed grading SQL. The migration patches the installed save/grading functions without replacing their scoring rules. If those functions are reinstalled later, rerun this migration last.

Applies to 100-question mocks whose title contains `SSC CGL`, excluding explicitly named Tier-II/Tier-2 tests. Questions must be ordered as four consecutive 25-question sections. The configured total duration is divided equally: a 60-minute mock gives 15 minutes per section; an 80-minute configuration gives 20 minutes. This does not automatically determine compensatory-time eligibility.

Only the current section can be navigated or edited. Future section tabs are disabled; earlier sections close permanently. At each time boundary the screen advances to the first question of the newly opened section. Save & Next cannot cross a boundary early. Manual test submission becomes available in the fourth section; the existing total-time auto-submission remains in place.

The existing Save & exit behaviour is preserved: pausing stops the clock and resuming continues the same section's remaining allowance. Closing the browser without pausing continues to consume time. Section progress is derived from total elapsed time, not editable navigation state, so reloading or returning from a background tab cannot reset it.

The database keeps the last saved answers from completed sections and discards future-section answers. SSC answer autosaves start immediately rather than waiting for the usual debounce. Only responses received by the server before the section boundary are preserved; offline or delayed requests cannot amend a section after its time ends. Watch the existing save-status indicator. The UI may still receive the complete question payload; this feature enforces navigation and response timing, not confidential delivery of future question text.

Other exams retain their existing timer and navigation behaviour. Existing saved SSC attempts continue according to their already elapsed time; restart an old testing attempt if a fresh four-section run is needed. Attempts and scores are not deleted by this migration.

Validation: `node scripts/test_ssc_section_timing.mjs` checks boundary seconds, equal timing, non-SSC/Tier-II isolation, repeat migration, server answer locks, pause/resume and grading. Production build: `npm run build`.
