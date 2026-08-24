create or replace function private.guard_customer_relationship_insert()
returns trigger
language plpgsql
security definer
set search_path = public, auth
as $$
begin
  if tg_table_name = 'leads' then
    new.status := 'new';
    new.source := 'website';
    new.user_id := auth.uid();
    new.created_at := now();
    new.updated_at := now();
    return new;
  end if;

  if private.current_user_role() = 'customer' then
    if tg_table_name = 'messages' then
      new.sender_id := auth.uid();
      new.user_id := auth.uid();
      new.read_at := null;
      new.created_at := now();
      if new.project_id is not null and not exists (select 1 from public.projects p where p.id=new.project_id and p.user_id=auth.uid()) then
        raise exception 'Invalid project reference';
      end if;
      if new.request_id is not null and not exists (select 1 from public.requests r where r.id=new.request_id and r.user_id=auth.uid()) then
        raise exception 'Invalid request reference';
      end if;
    elsif tg_table_name = 'calculation_sessions' then
      new.user_id := auth.uid();
      new.created_at := now();
      if new.project_id is not null and not exists (select 1 from public.projects p where p.id=new.project_id and p.user_id=auth.uid()) then
        raise exception 'Invalid project reference';
      end if;
      if new.request_id is not null and not exists (select 1 from public.requests r where r.id=new.request_id and r.user_id=auth.uid()) then
        raise exception 'Invalid request reference';
      end if;
    elsif tg_table_name = 'concierge_events' then
      new.user_id := auth.uid();
      new.created_at := now();
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists guard_public_lead_insert on public.leads;
create trigger guard_public_lead_insert before insert on public.leads for each row execute function private.guard_customer_relationship_insert();
drop trigger if exists guard_customer_message_insert on public.messages;
create trigger guard_customer_message_insert before insert on public.messages for each row execute function private.guard_customer_relationship_insert();
drop trigger if exists guard_customer_calculation_insert on public.calculation_sessions;
create trigger guard_customer_calculation_insert before insert on public.calculation_sessions for each row execute function private.guard_customer_relationship_insert();
drop trigger if exists guard_customer_concierge_insert on public.concierge_events;
create trigger guard_customer_concierge_insert before insert on public.concierge_events for each row execute function private.guard_customer_relationship_insert();
