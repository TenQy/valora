-- 013_allow_anon_catalogs.sql
-- Permite que tanto usuarios autenticados como anónimos (anon) puedan leer los catálogos.
-- Esto es necesario para la función de "Modo Invitado" (Guest Mode / Estimación Rápida).

-- Eliminar políticas anteriores limitadas solo a "authenticated"
drop policy if exists "Catálogos accesibles para usuarios autenticados" on professional_areas;
drop policy if exists "Competencias accesibles para usuarios autenticados" on competencies;
drop policy if exists "Relaciones de competencias accesibles" on competency_areas;
drop policy if exists "Idiomas accesibles" on languages;
drop policy if exists "Niveles de idioma accesibles" on language_levels;
drop policy if exists "Roles laborales accesibles" on job_roles;
drop policy if exists "Catálogos accesibles para usuarios autenticados" on certification_issuers;

-- Crear nuevas políticas permitiendo lectura global (tanto anon como authenticated)
create policy "Catálogos accesibles para todos" on professional_areas
  for select using (true);

create policy "Competencias accesibles para todos" on competencies
  for select using (true);

create policy "Relaciones de competencias accesibles para todos" on competency_areas
  for select using (true);

create policy "Idiomas accesibles para todos" on languages
  for select using (true);

create policy "Niveles de idioma accesibles para todos" on language_levels
  for select using (true);

create policy "Roles laborales accesibles para todos" on job_roles
  for select using (true);

create policy "Emisores de certificaciones accesibles para todos" on certification_issuers
  for select using (true);
