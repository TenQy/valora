create table growth_paths (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references profiles(id) on delete cascade,
  current_level text not null,
  next_level text not null,
  estimated_time text not null,
  summary text not null,
  milestones jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now()
);

create index idx_growth_paths_profile_id on growth_paths(profile_id);

alter table growth_paths enable row level security;

drop policy if exists "Usuarios leen y guardan sus rutas de crecimiento" on growth_paths;
create policy "Usuarios leen y guardan sus rutas de crecimiento" on growth_paths
  for all to authenticated
  using (profile_id in (select id from profiles where user_id = auth.uid()))
  with check (profile_id in (select id from profiles where user_id = auth.uid()));
