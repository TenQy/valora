create table certification_issuers (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

-- Migración de datos existentes: asegurarnos de que los issuers que ya existen 
-- en la tabla certifications sean insertados en nuestro catálogo para no 
-- violar la nueva llave foránea.
insert into certification_issuers (name)
select distinct issuer from certifications where issuer is not null
on conflict (name) do nothing;

-- Ahora insertamos un catálogo básico predefinido
insert into certification_issuers (name) values
  ('Amazon Web Services'),
  ('Google'),
  ('Microsoft'),
  ('Meta'),
  ('Oracle'),
  ('Cisco'),
  ('IBM'),
  ('Apple'),
  ('Platzi'),
  ('Udemy'),
  ('Coursera'),
  ('edX'),
  ('Scrum.org'),
  ('Scrum Alliance'),
  ('Project Management Institute (PMI)'),
  ('LinkedIn Learning'),
  ('FreeCodeCamp')
on conflict (name) do nothing;

-- Finalmente, agregamos la restricción (Foreign Key) a la tabla certifications 
-- vinculando el texto issuer directamente a certification_issuers(name).
alter table certifications 
add constraint fk_cert_issuer 
foreign key (issuer) 
references certification_issuers(name) 
on update cascade 
on delete restrict;

