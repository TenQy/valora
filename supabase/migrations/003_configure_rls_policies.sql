-- 003_configure_rls_policies.sql
--
-- Habilita Row Level Security (RLS) en todas las tablas de Valora
-- y define las políticas de acceso seguro según DATABASE.md y API_CONTRACT.md.

-- 1. Catálogos (Lectura pública para usuarios autenticados)
alter table professional_areas enable row level security;
alter table competencies enable row level security;
alter table competency_areas enable row level security;
alter table languages enable row level security;
alter table language_levels enable row level security;
alter table job_roles enable row level security;

drop policy if exists "Catálogos accesibles para usuarios autenticados" on professional_areas;
create policy "Catálogos accesibles para usuarios autenticados" on professional_areas
  for select to authenticated using (true);

drop policy if exists "Competencias accesibles para usuarios autenticados" on competencies;
create policy "Competencias accesibles para usuarios autenticados" on competencies
  for select to authenticated using (true);

drop policy if exists "Relaciones de competencias accesibles" on competency_areas;
create policy "Relaciones de competencias accesibles" on competency_areas
  for select to authenticated using (true);

drop policy if exists "Idiomas accesibles" on languages;
create policy "Idiomas accesibles" on languages
  for select to authenticated using (true);

drop policy if exists "Niveles de idioma accesibles" on language_levels;
create policy "Niveles de idioma accesibles" on language_levels
  for select to authenticated using (true);

drop policy if exists "Roles laborales accesibles" on job_roles;
create policy "Roles laborales accesibles" on job_roles
  for select to authenticated using (true);

-- 2. Tablas privadas por usuario (profiles)
alter table profiles enable row level security;

drop policy if exists "Usuarios manejan su propio perfil" on profiles;
create policy "Usuarios manejan su propio perfil" on profiles
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- 3. Competencias del usuario (user_competencies)
alter table user_competencies enable row level security;

drop policy if exists "Usuarios manejan sus propias competencias" on user_competencies;
create policy "Usuarios manejan sus propias competencias" on user_competencies
  for all to authenticated
  using (profile_id in (select id from profiles where user_id = auth.uid()))
  with check (profile_id in (select id from profiles where user_id = auth.uid()));

-- 4. Idiomas del usuario (user_languages)
alter table user_languages enable row level security;

drop policy if exists "Usuarios manejan sus propios idiomas" on user_languages;
create policy "Usuarios manejan sus propios idiomas" on user_languages
  for all to authenticated
  using (profile_id in (select id from profiles where user_id = auth.uid()))
  with check (profile_id in (select id from profiles where user_id = auth.uid()));

-- 5. Certificaciones (certifications)
alter table certifications enable row level security;

drop policy if exists "Usuarios manejan sus propias certificaciones" on certifications;
create policy "Usuarios manejan sus propias certificaciones" on certifications
  for all to authenticated
  using (profile_id in (select id from profiles where user_id = auth.uid()))
  with check (profile_id in (select id from profiles where user_id = auth.uid()));

-- 6. Proyectos (projects y project_competencies)
alter table projects enable row level security;

drop policy if exists "Usuarios manejan sus propios proyectos" on projects;
create policy "Usuarios manejan sus propios proyectos" on projects
  for all to authenticated
  using (profile_id in (select id from profiles where user_id = auth.uid()))
  with check (profile_id in (select id from profiles where user_id = auth.uid()));

alter table project_competencies enable row level security;

drop policy if exists "Usuarios manejan competencias de sus proyectos" on project_competencies;
create policy "Usuarios manejan competencias de sus proyectos" on project_competencies
  for all to authenticated
  using (project_id in (select id from projects where profile_id in (select id from profiles where user_id = auth.uid())))
  with check (project_id in (select id from projects where profile_id in (select id from profiles where user_id = auth.uid())));

-- 7. Historial y estimaciones
alter table salary_estimations enable row level security;

drop policy if exists "Usuarios leen y guardan sus estimaciones salariales" on salary_estimations;
create policy "Usuarios leen y guardan sus estimaciones salariales" on salary_estimations
  for all to authenticated
  using (profile_id in (select id from profiles where user_id = auth.uid()))
  with check (profile_id in (select id from profiles where user_id = auth.uid()));

alter table job_matches enable row level security;

drop policy if exists "Usuarios leen y guardan sus compatibilidades laborales" on job_matches;
create policy "Usuarios leen y guardan sus compatibilidades laborales" on job_matches
  for all to authenticated
  using (profile_id in (select id from profiles where user_id = auth.uid()))
  with check (profile_id in (select id from profiles where user_id = auth.uid()));

alter table project_estimations enable row level security;

drop policy if exists "Usuarios leen y guardan sus valoraciones de proyectos" on project_estimations;
create policy "Usuarios leen y guardan sus valoraciones de proyectos" on project_estimations
  for all to authenticated
  using (profile_id in (select id from profiles where user_id = auth.uid()))
  with check (profile_id in (select id from profiles where user_id = auth.uid()));
