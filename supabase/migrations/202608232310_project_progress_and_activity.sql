alter table public.projects add column if not exists progress_percent smallint not null default 0 check (progress_percent between 0 and 100);
alter table public.projects add column if not exists next_step text;
alter table public.projects add column if not exists last_client_update_at timestamptz;

create table if not exists public.project_activity (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  activity_type text not null default 'update',
  title text not null,
  body text,
  visible_to_client boolean not null default true,
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now()
);
create index if not exists project_activity_project_created_idx on public.project_activity(project_id,created_at desc);
create index if not exists project_activity_user_created_idx on public.project_activity(user_id,created_at desc);
alter table public.project_activity enable row level security;
create policy project_activity_customer_read on public.project_activity for select to authenticated using (user_id = auth.uid() and visible_to_client = true and private.current_account_open());
create policy project_activity_staff_all on public.project_activity for all to authenticated using (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','employee'))) with check (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','employee')));

create or replace function public.sync_project_progress_activity() returns trigger language plpgsql security definer set search_path=public as $$
begin
  if new.progress_percent is distinct from old.progress_percent or new.status is distinct from old.status or new.next_step is distinct from old.next_step then
    insert into public.project_activity(project_id,user_id,activity_type,title,body,visible_to_client,created_by)
    values(new.id,new.user_id,'progress','Projektstatus aktualisiert',concat('Status: ',coalesce(new.status,'—'),' · Fortschritt: ',new.progress_percent,'% · Nächster Schritt: ',coalesce(new.next_step,'—')),true,auth.uid());
    new.last_client_update_at=now();
  end if;
  return new;
end $$;
create trigger trg_project_progress_activity before update on public.projects for each row execute function public.sync_project_progress_activity();
