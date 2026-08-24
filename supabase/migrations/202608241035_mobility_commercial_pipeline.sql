alter table public.mobility_bookings add column if not exists service_mode text;
alter table public.mobility_bookings add column if not exists duration_min integer;
alter table public.mobility_bookings add column if not exists waiting_min integer;
alter table public.mobility_bookings add column if not exists project_id uuid references public.projects(id) on delete set null;
alter table public.mobility_bookings add column if not exists offer_id uuid references public.offers(id) on delete set null;
create index if not exists mobility_bookings_project_idx on public.mobility_bookings(project_id);
create index if not exists mobility_bookings_offer_idx on public.mobility_bookings(offer_id);

create or replace function public.admin_mobility_to_offer(p_booking_id uuid, p_price_chf numeric default null)
returns uuid language plpgsql security definer set search_path=public as $$
declare
  b public.mobility_bookings%rowtype;
  c public.profiles%rowtype;
  v_project uuid;
  v_offer uuid;
  v_price numeric;
  v_company jsonb;
  v_customer jsonb;
  v_title text;
begin
  if not exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','employee')) then raise exception 'forbidden'; end if;
  select * into b from public.mobility_bookings where id=p_booking_id for update;
  if not found then raise exception 'booking_not_found'; end if;
  if b.offer_id is not null then return b.offer_id; end if;
  select * into c from public.profiles where id=b.user_id;
  v_price := coalesce(p_price_chf,b.estimated_price_chf,0);
  v_title := coalesce(nullif(trim(b.pickup),'')||' → '||nullif(trim(b.destination),''),'Executive Fahrservice');
  v_customer := jsonb_build_object('full_name',c.full_name,'company',c.company,'email',c.email,'phone',c.phone,'street',c.street,'postal_code',c.postal_code,'city',c.city,'country',c.country);
  select value into v_company from public.app_settings where key='company_profile';
  if b.project_id is null then insert into public.projects(user_id,title,description,status,budget_chf,created_by) values(b.user_id,'Executive Fahrservice · '||v_title,coalesce(b.notes,''),'planning',v_price,auth.uid()) returning id into v_project; else v_project:=b.project_id; end if;
  insert into public.offers(user_id,project_id,title,status,currency,subtotal_chf,vat_rate,vat_chf,total_chf,line_items,customer_snapshot,company_snapshot,notes,created_by)
  values(b.user_id,v_project,'Executive Fahrservice · '||v_title,'draft','CHF',v_price,8.1,round(v_price*0.081,2),round(v_price*1.081,2),jsonb_build_array(jsonb_build_object('label',coalesce(b.service_mode,'Executive Fahrservice'),'quantity',1,'unit_price_chf',v_price,'total_chf',v_price)),v_customer,coalesce(v_company,'{}'::jsonb),coalesce(b.notes,''),auth.uid()) returning id into v_offer;
  update public.mobility_bookings set project_id=v_project,offer_id=v_offer,status='reviewing',estimated_price_chf=v_price where id=b.id;
  return v_offer;
end $$;
revoke all on function public.admin_mobility_to_offer(uuid,numeric) from public,anon;
grant execute on function public.admin_mobility_to_offer(uuid,numeric) to authenticated;
