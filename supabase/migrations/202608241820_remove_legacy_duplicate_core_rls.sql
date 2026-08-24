-- Keep the newer account-aware policies as the single source of truth.
drop policy if exists jg_mobility_insert on public.mobility_bookings;
drop policy if exists jg_mobility_read on public.mobility_bookings;
drop policy if exists jg_mobility_staff_update on public.mobility_bookings;
drop policy if exists jg_offers_read on public.offers;
drop policy if exists jg_offers_staff_write on public.offers;
drop policy if exists jg_invoices_read on public.invoices;
drop policy if exists jg_invoices_staff_write on public.invoices;
drop policy if exists jg_projects_read on public.projects;
drop policy if exists jg_projects_staff_write on public.projects;
