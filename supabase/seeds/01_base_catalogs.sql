
insert into languages (name) values
  ('Español'), ('Inglés'), ('Portugués'), ('Francés'), ('Alemán'), ('Italiano'),
  ('Chino Mandarín'), ('Japonés'), ('Ruso'), ('Coreano'), ('Árabe'), ('Hindi')
on conflict (name) do nothing;

insert into language_levels (name, description) values
  ('A1', 'Nivel inicial.'),
  ('A2', 'Nivel básico.'),
  ('B1', 'Nivel intermedio.'),
  ('B2', 'Nivel intermedio alto.'),
  ('C1', 'Nivel avanzado.'),
  ('C2', 'Nivel avanzado superior.'),
  ('Nativo', 'Dominio nativo del idioma.')
on conflict (name) do nothing;

insert into certification_issuers (name) values
  -- Tecnología y General
  ('Amazon Web Services'), ('Google'), ('Microsoft'), ('Meta'), ('Oracle'),
  ('Cisco'), ('IBM'), ('Apple'), ('Platzi'), ('Udemy'), ('Coursera'), ('edX'),
  ('LinkedIn Learning'), ('FreeCodeCamp'),
  -- Project Management y Agilidad
  ('Scrum.org'), ('Scrum Alliance'), ('Project Management Institute (PMI)'),
  -- Marketing
  ('HubSpot Academy'), ('Salesforce'), ('Digital Marketing Institute (DMI)'),
  -- Finanzas y Contabilidad
  ('CFA Institute'), ('CFP Board'), ('GARP'), ('CAIA Association'),
  -- Salud
  ('American Heart Association (AHA)'), ('AAPC'),
  -- Administración y RRHH
  ('SHRM'), ('HRCI'),
  -- Diseño y Arquitectura
  ('Autodesk'), ('Interaction Design Foundation (IxDF)'), ('NCARB'), ('USGBC'),
  -- Idiomas y Educación
  ('Cambridge Assessment English'), ('ETS (TOEFL, GRE)'), ('EF SET')
on conflict (name) do nothing;

insert into professional_areas (name, description) values
  ('Tecnología', 'Desarrollo de software, datos e infraestructura tecnológica.'),
  ('Diseño', 'Diseño visual, experiencia de usuario, industrial e identidad de marca.'),
  ('Marketing', 'Marketing digital, comunicación, posicionamiento y campañas.'),
  ('Administración', 'Gestión empresarial, operaciones y recursos humanos.'),
  ('Finanzas', 'Contabilidad, análisis financiero, inversiones y economía.'),
  ('Arquitectura', 'Diseño, urbanismo, modelado 3D y planeación de espacios.'),
  ('Ingenierías', 'Ingeniería civil, industrial, mecánica, mecatrónica, etc.'),
  ('Salud', 'Medicina, enfermería, psicología, nutrición y especialidades médicas.'),
  ('Educación', 'Pedagogía, docencia, capacitación e investigación educativa.'),
  ('Derecho', 'Asesoría legal, litigio, corporativo y notarial.')
on conflict (name) do nothing;
