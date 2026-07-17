-- seed_demo_profile.sql
--
-- Crea el mismo perfil de prueba que se usaba como mock en la app
-- ("Juan Pérez"), pero enlazado a un usuario real de Supabase Auth.
--
-- REQUISITOS ANTES DE CORRER ESTE SCRIPT:
--   1. Ya debiste haber corrido tu seed de catálogos (professional_areas,
--      competencies, competency_areas, languages, language_levels, job_roles).
--   2. Ya debiste haberte registrado una vez en la app (o desde el Auth de
--      Supabase) con el correo que vas a poner abajo en `v_user_email`,
--      para que exista una fila en `auth.users`.
--
-- CÓMO USARLO:
--   1. Cambia el valor de `v_user_email` por el correo con el que te
--      registraste en la app.
--   2. Corre este archivo completo en el SQL Editor de Supabase.
--   3. Es idempotente: puedes volver a correrlo sin duplicar datos
--      (actualiza el perfil y evita duplicar certificaciones/proyectos).

-- Nota: 'Dart' y 'Supabase' no estaban en tu seed original de competencies,
-- se agregan aquí porque el perfil de prueba las usa. Si ya las tienes,
-- este bloque no hace nada gracias a "on conflict do nothing".
insert into competencies (name, description, category)
values
  ('Dart', 'Lenguaje de programación usado por Flutter.', 'language'),
  ('Supabase', 'Backend como servicio: base de datos, auth y funciones.', 'platform')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
values
  (
    (select id from competencies where name = 'Dart'),
    (select id from professional_areas where name = 'Tecnología')
  ),
  (
    (select id from competencies where name = 'Supabase'),
    (select id from professional_areas where name = 'Tecnología')
  )
on conflict (competency_id, professional_area_id) do nothing;

do $$
declare
  v_user_email text := 'imtenqy@gmail.com';
  v_user_id uuid;
  v_profile_id uuid;
  v_project_id uuid;
begin
  select id into v_user_id from auth.users where email = v_user_email;

  if v_user_id is null then
    raise exception
      'No se encontró un usuario en auth.users con el correo %. Regístrate en la app primero.',
      v_user_email;
  end if;

  insert into profiles (
    user_id, full_name, professional_area_id, career,
    professional_level, years_experience, bio
  )
  values (
    v_user_id,
    'Juan Pérez',
    (select id from professional_areas where name = 'Tecnología'),
    'Ingeniería en Sistemas Computacionales',
    'Junior',
    1,
    'Desarrollador frontend y móvil enfocado en Flutter y React. '
    'Interesado en construir productos con buena experiencia de usuario '
    'y código mantenible.'
  )
  on conflict (user_id) do update set
    full_name = excluded.full_name,
    professional_area_id = excluded.professional_area_id,
    career = excluded.career,
    professional_level = excluded.professional_level,
    years_experience = excluded.years_experience,
    bio = excluded.bio,
    updated_at = now()
  returning id into v_profile_id;

  -- Competencias
  insert into user_competencies (profile_id, competency_id, level)
  values
    (v_profile_id, (select id from competencies where name = 'Flutter'), 'Avanzado'),
    (v_profile_id, (select id from competencies where name = 'React'), 'Intermedio'),
    (v_profile_id, (select id from competencies where name = 'Dart'), 'Avanzado'),
    (v_profile_id, (select id from competencies where name = 'Git'), 'Intermedio'),
    (v_profile_id, (select id from competencies where name = 'PostgreSQL'), 'Básico')
  on conflict (profile_id, competency_id) do update set
    level = excluded.level,
    updated_at = now();

  -- Idiomas
  insert into user_languages (profile_id, language_id, language_level_id)
  values
    (
      v_profile_id,
      (select id from languages where name = 'Español'),
      (select id from language_levels where name = 'Nativo')
    ),
    (
      v_profile_id,
      (select id from languages where name = 'Inglés'),
      (select id from language_levels where name = 'B2')
    )
  on conflict (profile_id, language_id) do update set
    language_level_id = excluded.language_level_id,
    updated_at = now();

  -- Certificaciones (sin unique constraint en la tabla, evitamos duplicar
  -- manualmente si el script se corre más de una vez)
  insert into certifications (profile_id, name, issuer, issue_date)
  select v_profile_id, 'AWS Cloud Practitioner', 'Amazon Web Services', date '2026-01-15'
  where not exists (
    select 1 from certifications
    where profile_id = v_profile_id and name = 'AWS Cloud Practitioner'
  );

  -- Proyectos (mismo criterio: solo se crea si no existe ya)
  if not exists (
    select 1 from projects
    where profile_id = v_profile_id and name = 'Sistema de inventario'
  ) then
    insert into projects (
      profile_id, professional_area_id, name, description,
      project_type, complexity, estimated_time, platforms
    )
    values (
      v_profile_id,
      (select id from professional_areas where name = 'Tecnología'),
      'Sistema de inventario',
      'Aplicación para administrar ventas, productos e inventario.',
      'Aplicación web',
      'Media',
      '2 meses',
      array['Web', 'Android']
    )
    returning id into v_project_id;

    insert into project_competencies (project_id, competency_id)
    values
      (v_project_id, (select id from competencies where name = 'Flutter')),
      (v_project_id, (select id from competencies where name = 'PostgreSQL')),
      (v_project_id, (select id from competencies where name = 'Supabase'))
    on conflict (project_id, competency_id) do nothing;
  end if;

  raise notice 'Perfil de prueba listo para user_id %', v_user_id;
end $$;