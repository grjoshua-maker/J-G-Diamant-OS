create or replace function public.notify_offer_status_change() returns trigger language plpgsql security definer set search_path=public as $$
begin
  if new.status is distinct from old.status and new.status='sent' then
    insert into public.notifications(user_id,kind,title,body,entity_type,entity_id)
    values(new.user_id,'offer','Neue Offerte verfügbar',coalesce(new.offer_number,'Offerte')||' · '||coalesce(new.title,''),'offer',new.id::text);
  end if;
  return new;
end $$;
drop trigger if exists trg_notify_offer_status on public.offers;
create trigger trg_notify_offer_status after update on public.offers for each row execute function public.notify_offer_status_change();
revoke execute on function public.notify_offer_status_change() from public,anon,authenticated;

create or replace function public.notify_invoice_status_change() returns trigger language plpgsql security definer set search_path=public as $$
begin
  if new.status is distinct from old.status and new.status in ('sent','due','paid') then
    insert into public.notifications(user_id,kind,title,body,entity_type,entity_id)
    values(new.user_id,'invoice',case new.status when 'sent' then 'Neue Rechnung verfügbar' when 'due' then 'Rechnung fällig' else 'Zahlung verbucht' end,coalesce(new.invoice_number,'Rechnung')||' · '||coalesce(new.title,''),'invoice',new.id::text);
  end if;
  return new;
end $$;
drop trigger if exists trg_notify_invoice_status on public.invoices;
create trigger trg_notify_invoice_status after update on public.invoices for each row execute function public.notify_invoice_status_change();
revoke execute on function public.notify_invoice_status_change() from public,anon,authenticated;

create or replace function public.notify_project_status_change() returns trigger language plpgsql security definer set search_path=public as $$
begin
  if new.status is distinct from old.status then
    insert into public.notifications(user_id,kind,title,body,entity_type,entity_id)
    values(new.user_id,'project','Projektstatus aktualisiert',coalesce(new.title,'Projekt')||' · Status: '||new.status,'project',new.id::text);
  end if;
  return new;
end $$;
drop trigger if exists trg_notify_project_status on public.projects;
create trigger trg_notify_project_status after update on public.projects for each row execute function public.notify_project_status_change();
revoke execute on function public.notify_project_status_change() from public,anon,authenticated;
