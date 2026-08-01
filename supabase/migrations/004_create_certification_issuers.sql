create table certification_issuers (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

alter table certification_issuers enable row level security;



-- Finalmente, agregamos la restricción (Foreign Key) a la tabla certifications 
-- vinculando el texto issuer directamente a certification_issuers(name).
alter table certifications 
add constraint fk_cert_issuer 
foreign key (issuer) 
references certification_issuers(name) 
on update cascade 
on delete restrict;

