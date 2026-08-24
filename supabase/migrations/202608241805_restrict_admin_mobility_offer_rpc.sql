-- Release hardening: this SECURITY DEFINER workflow is an internal privileged operation.
-- Browser clients must not be able to invoke it directly, even though the function
-- also performs its own role check.
revoke execute on function public.admin_mobility_to_offer(uuid,numeric) from public, anon, authenticated;
grant execute on function public.admin_mobility_to_offer(uuid,numeric) to service_role;
