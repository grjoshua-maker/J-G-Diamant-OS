-- Keep Executive Journey status aligned with its commercial offer lifecycle.
create or replace function public.sync_mobility_offer_status()
returns trigger
language plpgsql
security definer
set search_path=public
as $$
begin
  if new.status is distinct from old.status then
    update public.mobility_bookings
       set status = case
         when new.status = 'accepted' then 'confirmed'
         when new.status = 'declined' then 'requested'
         when new.status = 'sent' then 'reviewing'
         else status
       end
     where offer_id = new.id;
  end if;
  return new;
end $$;

drop trigger if exists trg_sync_mobility_offer_status on public.offers;
create trigger trg_sync_mobility_offer_status
after update of status on public.offers
for each row execute function public.sync_mobility_offer_status();

revoke all on function public.sync_mobility_offer_status() from public, anon, authenticated;
