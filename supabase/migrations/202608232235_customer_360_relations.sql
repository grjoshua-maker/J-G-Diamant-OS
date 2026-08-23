alter table public.calculation_sessions add column if not exists request_id uuid references public.requests(id) on delete set null;
alter table public.calculation_sessions add column if not exists project_id uuid references public.projects(id) on delete set null;
alter table public.requests add column if not exists calculation_id uuid references public.calculation_sessions(id) on delete set null;
alter table public.offers add column if not exists calculation_id uuid references public.calculation_sessions(id) on delete set null;
alter table public.invoices add column if not exists calculation_id uuid references public.calculation_sessions(id) on delete set null;

create index if not exists calculation_sessions_user_created_idx on public.calculation_sessions(user_id, created_at desc);
create index if not exists calculation_sessions_project_idx on public.calculation_sessions(project_id);
create index if not exists requests_calculation_idx on public.requests(calculation_id);
create index if not exists offers_calculation_idx on public.offers(calculation_id);
create index if not exists invoices_calculation_idx on public.invoices(calculation_id);
