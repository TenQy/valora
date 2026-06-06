create extension if not exists pgcrypto;

create table professional_areas (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  description text,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table competencies (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  description text,
  category text check (
    category is null
    or category in (
      'language',
      'framework',
      'database',
      'tool',
      'design_tool',
      'marketing_tool',
      'methodology',
      'soft_skill',
      'domain_knowledge',
      'platform'
    )
  ),
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table competency_areas (
  id uuid primary key default gen_random_uuid(),
  competency_id uuid not null references competencies(id) on delete cascade,
  professional_area_id uuid not null references professional_areas(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (competency_id, professional_area_id)
);

create table profiles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references auth.users(id) on delete cascade,
  full_name text not null,
  professional_area_id uuid references professional_areas(id) on delete restrict,
  career text,
  professional_level text check (
    professional_level is null
    or professional_level in (
      'Estudiante',
      'Practicante',
      'Junior',
      'Semi Senior',
      'Senior',
      'Especialista'
    )
  ),
  years_experience integer check (years_experience is null or years_experience >= 0),
  bio text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table languages (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table language_levels (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  description text,
  created_at timestamptz not null default now()
);

create table user_languages (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references profiles(id) on delete cascade,
  language_id uuid not null references languages(id) on delete restrict,
  language_level_id uuid not null references language_levels(id) on delete restrict,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (profile_id, language_id)
);

create table user_competencies (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references profiles(id) on delete cascade,
  competency_id uuid not null references competencies(id) on delete restrict,
  level text check (
    level is null
    or level in (
      'Básico',
      'Intermedio',
      'Avanzado'
    )
  ),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (profile_id, competency_id)
);

create table certifications (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references profiles(id) on delete cascade,
  name text not null,
  issuer text,
  issue_date date,
  credential_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table projects (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references profiles(id) on delete cascade,
  professional_area_id uuid not null references professional_areas(id) on delete restrict,
  name text not null,
  description text,
  project_type text,
  complexity text,
  estimated_time text,
  platforms text[] not null default '{}',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table project_competencies (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references projects(id) on delete cascade,
  competency_id uuid not null references competencies(id) on delete restrict,
  created_at timestamptz not null default now(),
  unique (project_id, competency_id)
);

create table job_roles (
  id uuid primary key default gen_random_uuid(),
  professional_area_id uuid not null references professional_areas(id) on delete restrict,
  name text not null,
  description text,
  min_salary numeric(12, 2) check (min_salary is null or min_salary >= 0),
  max_salary numeric(12, 2) check (max_salary is null or max_salary >= 0),
  currency varchar(3) not null default 'MXN',
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  unique (professional_area_id, name),
  check (
    min_salary is null
    or max_salary is null
    or min_salary <= max_salary
  )
);

create table salary_estimations (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references profiles(id) on delete cascade,
  professional_area_id uuid not null references professional_areas(id) on delete restrict,
  estimated_min_salary numeric(12, 2) not null check (estimated_min_salary >= 0),
  estimated_max_salary numeric(12, 2) not null check (estimated_max_salary >= 0),
  currency varchar(3) not null default 'MXN',
  professional_level text,
  summary text,
  created_at timestamptz not null default now(),
  check (estimated_min_salary <= estimated_max_salary)
);

create table job_matches (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references profiles(id) on delete cascade,
  job_role_id uuid not null references job_roles(id) on delete restrict,
  match_percentage numeric(5, 2) not null check (
    match_percentage >= 0
    and match_percentage <= 100
  ),
  estimated_min_salary numeric(12, 2) check (
    estimated_min_salary is null
    or estimated_min_salary >= 0
  ),
  estimated_max_salary numeric(12, 2) check (
    estimated_max_salary is null
    or estimated_max_salary >= 0
  ),
  currency varchar(3) not null default 'MXN',
  matched_competencies text[] not null default '{}',
  missing_competencies text[] not null default '{}',
  summary text,
  created_at timestamptz not null default now(),
  check (
    estimated_min_salary is null
    or estimated_max_salary is null
    or estimated_min_salary <= estimated_max_salary
  )
);

create table project_estimations (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references projects(id) on delete cascade,
  profile_id uuid not null references profiles(id) on delete cascade,
  estimated_min_value numeric(12, 2) not null check (estimated_min_value >= 0),
  estimated_max_value numeric(12, 2) not null check (estimated_max_value >= 0),
  currency varchar(3) not null default 'MXN',
  complexity_result text,
  summary text,
  recommendations text[] not null default '{}',
  created_at timestamptz not null default now(),
  check (estimated_min_value <= estimated_max_value)
);

create index idx_profiles_user_id on profiles(user_id);
create index idx_profiles_professional_area_id on profiles(professional_area_id);

create index idx_competency_areas_competency_id on competency_areas(competency_id);
create index idx_competency_areas_professional_area_id on competency_areas(professional_area_id);

create index idx_user_competencies_profile_id on user_competencies(profile_id);
create index idx_user_competencies_competency_id on user_competencies(competency_id);

create index idx_user_languages_profile_id on user_languages(profile_id);
create index idx_user_languages_language_id on user_languages(language_id);
create index idx_user_languages_language_level_id on user_languages(language_level_id);

create index idx_certifications_profile_id on certifications(profile_id);

create index idx_projects_profile_id on projects(profile_id);
create index idx_projects_professional_area_id on projects(professional_area_id);

create index idx_project_competencies_project_id on project_competencies(project_id);
create index idx_project_competencies_competency_id on project_competencies(competency_id);

create index idx_job_roles_professional_area_id on job_roles(professional_area_id);

create index idx_salary_estimations_profile_id on salary_estimations(profile_id);

create index idx_job_matches_profile_id on job_matches(profile_id);
create index idx_job_matches_job_role_id on job_matches(job_role_id);

create index idx_project_estimations_project_id on project_estimations(project_id);
create index idx_project_estimations_profile_id on project_estimations(profile_id);

create or replace function update_updated_at_column()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger update_profiles_updated_at
before update on profiles
for each row
execute function update_updated_at_column();

create trigger update_user_languages_updated_at
before update on user_languages
for each row
execute function update_updated_at_column();

create trigger update_user_competencies_updated_at
before update on user_competencies
for each row
execute function update_updated_at_column();

create trigger update_certifications_updated_at
before update on certifications
for each row
execute function update_updated_at_column();

create trigger update_projects_updated_at
before update on projects
for each row
execute function update_updated_at_column();
