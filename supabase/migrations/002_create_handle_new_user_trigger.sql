-- 002_create_handle_new_user_trigger.sql
--
-- Trigger que crea automáticamente una fila en public.profiles cada vez que
-- un nuevo usuario se registra o inicia sesión con Google OAuth por primera vez.

create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (user_id, full_name)
  values (
    new.id,
    coalesce(
      nullif(trim(new.raw_user_meta_data->>'full_name'), ''),
      nullif(trim(new.raw_user_meta_data->>'name'), ''),
      split_part(new.email, '@', 1),
      'Usuario Valora'
    )
  )
  on conflict (user_id) do nothing;
  return new;
end;
$$ language plpgsql security definer;

-- Recrear el trigger para evitar duplicados
drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
