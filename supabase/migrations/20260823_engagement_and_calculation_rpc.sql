create or replace function public.register_calculation(
  p_calculation_type text,
  p_input_data jsonb default '{}'::jsonb,
  p_result_data jsonb default '{}'::jsonb,
  p_estimated_total_chf numeric default null,
  p_source text default 'platform'
) returns uuid
language plpgsql
security invoker
set search_path = public, auth
as $$
declare v_id uuid;
begin
  if auth.uid() is null then raise exception 'Authentication required'; end if;
  insert into public.calculation_sessions(user_id, calculation_type, input_data, result_data, estimated_total_chf, source)
  values(auth.uid(), coalesce(nullif(btrim(p_calculation_type),''),'general'), coalesce(p_input_data,'{}'::jsonb), coalesce(p_result_data,'{}'::jsonb), p_estimated_total_chf, coalesce(nullif(btrim(p_source),''),'platform'))
  returning id into v_id;
  return v_id;
end;
$$;

grant execute on function public.register_calculation(text,jsonb,jsonb,numeric,text) to authenticated;

drop trigger if exists mobility_mark_engaged on public.mobility_bookings;
create trigger mobility_mark_engaged
after insert on public.mobility_bookings
for each row execute function private.trg_mark_engaged('mobility_request');

drop trigger if exists memberships_mark_engaged on public.memberships;
create trigger memberships_mark_engaged
after insert on public.memberships
for each row execute function private.trg_mark_engaged('membership_request');
