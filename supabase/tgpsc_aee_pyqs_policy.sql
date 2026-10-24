-- Allow the app (anon/authenticated) to read TGPSC AEE PYQs.
-- Without a SELECT policy, the query returns zero rows when RLS is enabled.
alter table public.tgpsc_aee_pyqs enable row level security;

drop policy if exists "Anyone can read tgpsc_aee_pyqs" on public.tgpsc_aee_pyqs;
create policy "Anyone can read tgpsc_aee_pyqs"
  on public.tgpsc_aee_pyqs for select
  to anon, authenticated
  using (true);

grant select on public.tgpsc_aee_pyqs to anon, authenticated;
