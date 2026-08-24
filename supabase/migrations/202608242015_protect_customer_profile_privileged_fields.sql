create or replace function private.protect_customer_profile_privileged_fields()
returns trigger
language plpgsql
security definer
set search_path = public, auth, private
as $$
begin
  if auth.uid() is null or private.current_user_role() = 'admin' then
    return new;
  end if;

  if auth.uid() = old.id then
    if new.role is distinct from old.role
       or new.membership_tier is distinct from old.membership_tier
       or new.account_status is distinct from old.account_status
       or new.trial_expires_at is distinct from old.trial_expires_at
       or new.engaged_at is distinct from old.engaged_at
       or new.engagement_reason is distinct from old.engagement_reason
       or new.locked_at is distinct from old.locked_at
       or new.unlocked_at is distinct from old.unlocked_at
       or new.unlocked_by is distinct from old.unlocked_by
       or new.notes is distinct from old.notes
       or new.created_at is distinct from old.created_at
       or new.id is distinct from old.id
       or new.email is distinct from old.email then
      raise exception 'Privileged profile fields cannot be changed by this account'
        using errcode = '42501';
    end if;
  end if;

  return new;
end;
$$;

drop trigger if exists trg_protect_customer_profile_privileged_fields on public.profiles;
create trigger trg_protect_customer_profile_privileged_fields
before update on public.profiles
for each row execute function private.protect_customer_profile_privileged_fields();

create or replace function private.sync_profile_email_from_auth()
returns trigger
language plpgsql
security definer
set search_path = public, auth
as $$
begin
  if new.email is distinct from old.email then
    update public.profiles
       set email = new.email,
           updated_at = now()
     where id = new.id;
  end if;
  return new;
end;
$$;

drop trigger if exists trg_sync_profile_email_from_auth on auth.users;
create trigger trg_sync_profile_email_from_auth
after update of email on auth.users
for each row execute function private.sync_profile_email_from_auth();
