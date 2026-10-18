# Database-managed admin statistics

Run the entire `supabase/admin_mock_statistics.sql` in Supabase SQL Editor after the existing mock schema. Deploy the updated frontend. No admin signup option is added; accounts without a role row are students.

Assign an existing user as admin through SQL Editor only (replace the email):

```sql
INSERT INTO public.app_user_roles(user_id, role)
SELECT id, 'admin' FROM auth.users
WHERE lower(email) = lower('your-admin-email@example.com')
ON CONFLICT (user_id) DO UPDATE SET role = EXCLUDED.role
RETURNING user_id, role;
```

Require one returned row. Zero rows means no existing account matches that email. Refresh the application or focus its browser tab to reload the role. The **Admin Statistics** navigation item then appears. To remove access:

```sql
UPDATE public.app_user_roles SET role = 'student'
WHERE user_id = (
 SELECT id FROM auth.users WHERE lower(email) = lower('your-admin-email@example.com')
)
RETURNING user_id, role;
```

Roles are not read from editable user/profile metadata. Authenticated users cannot directly read or change the role table. Admin RPCs recheck the database role on every request, including after revocation. This does not add administrator access to question answers or other users' test-review payloads.

The admin page includes published/unpublished mocks, attempts, distinct learners per mock, submitted/expired/in-progress counts, average/highest final scores, and paginated user-email/score rows. Filters: mock, status and email substring. Fifty attempts per page. In-progress scores are blank. Paused attempts remain in-progress. Final statistics include submitted and expired scores as stored; restarted/expired attempts can therefore affect averages. `testnaushad@gmail.com` is excluded from the admin summary, learner counts, scores and attempt list. Repeat attempts by other users are included. The testing account's stored attempts are not deleted. Deleting an attempt removes it from these live statistics.

Public catalogue statistics are aggregates for signed-in users only. Count each learner once per published mock, excluding admins and `testnaushad@gmail.com`. Percentage denominator: unique eligible learners who started at least one published mock. A person may attempt multiple mocks, so shares need not sum to 100%. This is participation, not completion or pass rate. The **Popular** label requires at least 10 learners and at least 20% share. Counts load with the catalogue and refresh when returning from an attempt; page refresh fetches the latest data. An unavailable popularity RPC does not block the catalogue.

Validation: `node scripts/test_admin_mock_statistics.mjs` and `npm run build`.
