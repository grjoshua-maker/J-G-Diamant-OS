create or replace function public.sync_offer_response() returns trigger language plpgsql security definer set search_path=public as $$
declare
  o public.offers%rowtype;
  p public.projects%rowtype;
  admin_rec record;
begin
  select * into o from public.offers where id=new.offer_id;
  if o.id is null or o.user_id <> new.user_id then raise exception 'invalid_offer_response'; end if;
  if o.status <> 'sent' then raise exception 'offer_not_open'; end if;
  update public.offers set status=case when new.decision='accepted' then 'accepted' else 'declined' end,updated_at=now() where id=o.id;
  if o.project_id is not null then
    select * into p from public.projects where id=o.project_id;
    update public.projects set status=case when new.decision='accepted' then 'approved' else 'quoted' end,next_step=case when new.decision='accepted' then 'Ausführung terminieren' else 'Offerte überarbeiten / Rückmeldung prüfen' end,updated_at=now() where id=o.project_id;
    if p.request_id is not null then update public.requests set status=case when new.decision='accepted' then 'approved' else 'reviewing' end,updated_at=now() where id=p.request_id; end if;
  end if;
  insert into public.notifications(user_id,kind,title,body,entity_type,entity_id) values(new.user_id,'offer',case when new.decision='accepted' then 'Offerte angenommen' else 'Offerte abgelehnt' end,case when new.decision='accepted' then 'Vielen Dank. Ihre Annahme wurde gespeichert.' else 'Ihre Rückmeldung wurde gespeichert. Wir melden uns bei Ihnen.' end,'offer',o.id::text);
  for admin_rec in select id from public.profiles where role='admin' loop
    insert into public.notifications(user_id,kind,title,body,entity_type,entity_id) values(admin_rec.id,'offer',case when new.decision='accepted' then 'Kunde hat Offerte angenommen' else 'Kunde hat Offerte abgelehnt' end,coalesce(o.offer_number,'Offerte')||' · '||coalesce(o.title,''),'offer',o.id::text);
  end loop;
  insert into public.activity_log(actor_id,entity_type,entity_id,action,details) values(new.user_id,'offer',o.id::text,'customer_response',jsonb_build_object('decision',new.decision,'comment',new.comment));
  return new;
end $$;
drop trigger if exists trg_sync_offer_response on public.offer_responses;
create trigger trg_sync_offer_response after insert on public.offer_responses for each row execute function public.sync_offer_response();
revoke execute on function public.sync_offer_response() from public,anon,authenticated;
revoke execute on function public.workflow_request_to_project(uuid) from public,anon;
revoke execute on function public.workflow_project_to_offer(uuid) from public,anon;
revoke execute on function public.workflow_offer_to_invoice(uuid) from public,anon;
grant execute on function public.workflow_request_to_project(uuid) to authenticated;
grant execute on function public.workflow_project_to_offer(uuid) to authenticated;
grant execute on function public.workflow_offer_to_invoice(uuid) to authenticated;
