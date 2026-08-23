create sequence if not exists public.offer_number_seq start 1001;
create sequence if not exists public.invoice_number_seq start 1001;

create unique index if not exists projects_request_unique_idx on public.projects(request_id) where request_id is not null;
create unique index if not exists invoices_offer_unique_idx on public.invoices(offer_id) where offer_id is not null;

create or replace function public.workflow_request_to_project(p_request_id uuid)
returns uuid language plpgsql security invoker set search_path=public as $$
declare r public.requests%rowtype; existing_id uuid; new_id uuid;
begin
  if not exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','employee')) then raise exception 'staff_only'; end if;
  select id into existing_id from public.projects where request_id=p_request_id limit 1;
  if existing_id is not null then return existing_id; end if;
  select * into r from public.requests where id=p_request_id;
  if r.id is null then raise exception 'request_not_found'; end if;
  insert into public.projects(user_id,request_id,title,description,status,assigned_to,progress_percent,next_step)
  values(r.user_id,r.id,r.title,r.description,'planning',r.assigned_to,0,'Offerte / Projektumfang vorbereiten') returning id into new_id;
  update public.requests set status='approved',updated_at=now() where id=r.id;
  update public.calculation_sessions set project_id=new_id where request_id=r.id and user_id=r.user_id;
  return new_id;
end $$;

create or replace function public.workflow_project_to_offer(p_project_id uuid)
returns uuid language plpgsql security invoker set search_path=public as $$
declare p public.projects%rowtype; prof public.profiles%rowtype; calc public.calculation_sessions%rowtype; company jsonb:='{}'::jsonb; defaults jsonb:='{}'::jsonb; new_id uuid; subtotal numeric:=0; vat_rate numeric:=8.10; vat numeric:=0; total numeric:=0; items jsonb:='[]'::jsonb;
begin
  if not exists(select 1 from public.profiles x where x.id=auth.uid() and x.role in ('admin','employee')) then raise exception 'staff_only'; end if;
  select * into p from public.projects where id=p_project_id;
  if p.id is null then raise exception 'project_not_found'; end if;
  select * into prof from public.profiles where id=p.user_id;
  select * into calc from public.calculation_sessions where project_id=p.id order by created_at desc limit 1;
  select value into company from public.app_settings where key='company_profile';
  select value into defaults from public.app_settings where key='document_defaults';
  vat_rate:=coalesce((defaults->>'vat_rate')::numeric,8.10);
  if calc.id is not null and coalesce(calc.estimated_total_chf,0)>0 then subtotal:=round(calc.estimated_total_chf,2); items:=jsonb_build_array(jsonb_build_object('description',coalesce(calc.calculation_type,'Kalkulation / Projektleistung'),'quantity',1,'unit_price_chf',subtotal,'total_chf',subtotal,'source','calculation'));
  elsif coalesce(p.budget_chf,0)>0 then subtotal:=round(p.budget_chf,2); items:=jsonb_build_array(jsonb_build_object('description',p.title,'quantity',1,'unit_price_chf',subtotal,'total_chf',subtotal,'source','project_budget')); end if;
  vat:=round(subtotal*vat_rate/100,2); total:=subtotal+vat;
  insert into public.offers(user_id,project_id,calculation_id,offer_number,title,status,currency,subtotal_chf,vat_rate,vat_chf,total_chf,line_items,customer_snapshot,company_snapshot,valid_until,created_by)
  values(p.user_id,p.id,calc.id,'JG-O-'||to_char(current_date,'YYYY')||'-'||lpad(nextval('public.offer_number_seq')::text,5,'0'),p.title,'draft','CHF',subtotal,vat_rate,vat,total,items,jsonb_strip_nulls(jsonb_build_object('full_name',prof.full_name,'email',prof.email,'phone',prof.phone,'company',prof.company,'street',prof.street,'postal_code',prof.postal_code,'city',prof.city,'country',prof.country)),coalesce(company,'{}'::jsonb),current_date+coalesce((defaults->>'offer_valid_days')::int,30),auth.uid()) returning id into new_id;
  update public.projects set status='quoted',next_step='Offerte prüfen / freigeben',updated_at=now() where id=p.id;
  if p.request_id is not null then update public.requests set status='quoted',updated_at=now() where id=p.request_id; end if;
  return new_id;
end $$;

create or replace function public.workflow_offer_to_invoice(p_offer_id uuid)
returns uuid language plpgsql security invoker set search_path=public as $$
declare o public.offers%rowtype; existing_id uuid; defaults jsonb:='{}'::jsonb; new_id uuid;
begin
  if not exists(select 1 from public.profiles x where x.id=auth.uid() and x.role in ('admin','employee')) then raise exception 'staff_only'; end if;
  select id into existing_id from public.invoices where offer_id=p_offer_id limit 1;
  if existing_id is not null then return existing_id; end if;
  select * into o from public.offers where id=p_offer_id;
  if o.id is null then raise exception 'offer_not_found'; end if;
  if o.status<>'accepted' then raise exception 'offer_not_accepted'; end if;
  select value into defaults from public.app_settings where key='document_defaults';
  insert into public.invoices(user_id,project_id,offer_id,calculation_id,invoice_number,title,status,currency,subtotal_chf,vat_rate,vat_chf,total_chf,line_items,customer_snapshot,company_snapshot,notes,issued_on,due_on,created_by)
  values(o.user_id,o.project_id,o.id,o.calculation_id,'JG-R-'||to_char(current_date,'YYYY')||'-'||lpad(nextval('public.invoice_number_seq')::text,5,'0'),o.title,'draft',o.currency,o.subtotal_chf,o.vat_rate,o.vat_chf,o.total_chf,o.line_items,o.customer_snapshot,o.company_snapshot,o.notes,current_date,current_date+coalesce((defaults->>'invoice_due_days')::int,30),auth.uid()) returning id into new_id;
  if o.project_id is not null then update public.projects set status='approved',next_step='Ausführung terminieren',updated_at=now() where id=o.project_id; end if;
  return new_id;
end $$;

grant execute on function public.workflow_request_to_project(uuid) to authenticated;
grant execute on function public.workflow_project_to_offer(uuid) to authenticated;
grant execute on function public.workflow_offer_to_invoice(uuid) to authenticated;
revoke all on function public.workflow_request_to_project(uuid) from anon;
revoke all on function public.workflow_project_to_offer(uuid) from anon;
revoke all on function public.workflow_offer_to_invoice(uuid) from anon;
