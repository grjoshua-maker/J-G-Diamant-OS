-- Release-ready billing closeout: paid invoice closes the related project/journey and records activity.
create or replace function public.sync_paid_invoice_closeout()
returns trigger
language plpgsql
security definer
set search_path=public
as $$
begin
  if new.status = 'paid' and old.status is distinct from 'paid' then
    if new.project_id is not null then
      update public.projects
         set status='completed', progress_percent=100, next_step='Abgeschlossen / archiviert', updated_at=now()
       where id=new.project_id;
    end if;

    if new.offer_id is not null then
      update public.mobility_bookings
         set status='completed'
       where offer_id=new.offer_id;
    end if;

    insert into public.activity_log(actor_id,entity_type,entity_id,action,details)
    values(auth.uid(),'invoice',new.id::text,'payment_recorded',jsonb_build_object('invoice_number',new.invoice_number,'total_chf',new.total_chf));
  end if;
  return new;
end $$;

drop trigger if exists trg_sync_paid_invoice_closeout on public.invoices;
create trigger trg_sync_paid_invoice_closeout
after update of status on public.invoices
for each row execute function public.sync_paid_invoice_closeout();

revoke all on function public.sync_paid_invoice_closeout() from public,anon,authenticated;
