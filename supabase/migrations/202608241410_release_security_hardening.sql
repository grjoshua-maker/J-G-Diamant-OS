-- V1 release security hardening: explicit RLS ownership boundaries for core private-client records.

alter table public.mobility_bookings enable row level security;
alter table public.offers enable row level security;
alter table public.invoices enable row level security;
alter table public.projects enable row level security;

-- Customers may read only their own commercial records; staff may read all.
drop policy if exists jg_mobility_read on public.mobility_bookings;
create policy jg_mobility_read on public.mobility_bookings for select to authenticated
using (user_id=auth.uid() or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','employee')));

drop policy if exists jg_offers_read on public.offers;
create policy jg_offers_read on public.offers for select to authenticated
using (user_id=auth.uid() or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','employee')));

drop policy if exists jg_invoices_read on public.invoices;
create policy jg_invoices_read on public.invoices for select to authenticated
using (user_id=auth.uid() or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','employee')));

drop policy if exists jg_projects_read on public.projects;
create policy jg_projects_read on public.projects for select to authenticated
using (user_id=auth.uid() or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','employee')));

-- A customer can create only a journey owned by their authenticated account.
drop policy if exists jg_mobility_insert on public.mobility_bookings;
create policy jg_mobility_insert on public.mobility_bookings for insert to authenticated
with check (user_id=auth.uid());

-- Operational/commercial mutations remain staff-only. Customer offer decisions use offer_responses instead.
drop policy if exists jg_mobility_staff_update on public.mobility_bookings;
create policy jg_mobility_staff_update on public.mobility_bookings for update to authenticated
using (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','employee')))
with check (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','employee')));

drop policy if exists jg_offers_staff_write on public.offers;
create policy jg_offers_staff_write on public.offers for all to authenticated
using (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','employee')))
with check (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','employee')));

drop policy if exists jg_invoices_staff_write on public.invoices;
create policy jg_invoices_staff_write on public.invoices for all to authenticated
using (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','employee')))
with check (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','employee')));

drop policy if exists jg_projects_staff_write on public.projects;
create policy jg_projects_staff_write on public.projects for all to authenticated
using (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','employee')))
with check (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','employee')));
