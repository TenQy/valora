insert into competencies (name, description, category) values
  -- Ramas del Derecho (Conceptos y Dominio)
  ('Derecho Civil', 'Regulación de las relaciones privadas entre personas (contratos, propiedad).', 'domain_knowledge'),
  ('Derecho Penal', 'Normas que regulan las conductas punibles y las penas impuestas por el Estado.', 'domain_knowledge'),
  ('Derecho Corporativo / Mercantil', 'Leyes relacionadas con la actividad empresarial y comercial.', 'domain_knowledge'),
  ('Derecho Laboral', 'Regulación de las relaciones entre empleadores y trabajadores.', 'domain_knowledge'),
  ('Derecho Familiar', 'Normas referentes a las relaciones de familia (divorcios, custodia).', 'domain_knowledge'),
  ('Derecho Fiscal', 'Estudio y aplicación de las leyes tributarias y obligaciones fiscales.', 'domain_knowledge'),
  ('Derecho Constitucional', 'Análisis de la Constitución y protección de los derechos fundamentales.', 'domain_knowledge'),
  ('Derecho Internacional', 'Regulación de las relaciones entre Estados y organizaciones internacionales.', 'domain_knowledge'),

  -- Competencias Técnicas y Procesales
  ('Litigio', 'Estrategia y representación activa en juicios ante tribunales.', 'domain_knowledge'),
  ('Redacción de Contratos', 'Elaboración técnica de documentos legales vinculantes.', 'domain_knowledge'),
  ('Negociación Legal', 'Técnicas para alcanzar acuerdos favorables y evitar procedimientos judiciales.', 'domain_knowledge'),
  ('Juicio de Amparo', 'Procedimiento legal para la defensa de los derechos humanos y garantías constitucionales.', 'domain_knowledge'),
  ('Investigación Jurídica', 'Búsqueda e interpretación profunda de leyes, jurisprudencia y doctrina.', 'domain_knowledge'),
  ('Argumentación Jurídica', 'Habilidad para razonar y presentar argumentos persuasivos ante un tribunal.', 'domain_knowledge'),
  ('Cumplimiento Normativo (Compliance)', 'Implementación de controles para asegurar que una empresa cumpla la ley.', 'domain_knowledge'),
  ('Propiedad Intelectual', 'Protección legal de marcas, patentes y derechos de autor.', 'domain_knowledge'),

  -- LegalTech y Bases de Datos
  ('vLex / Tirant lo Blanch', 'Uso de plataformas digitales avanzadas de bases de datos de jurisprudencia.', 'tool'),
  ('Sistemas de Gestión de Expedientes (Lex-Doctor, Clio, etc.)', 'Software especializado para la administración de firmas de abogados.', 'tool')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in (
  'Derecho Civil', 'Derecho Penal', 'Derecho Corporativo / Mercantil', 'Derecho Laboral',
  'Derecho Familiar', 'Derecho Fiscal', 'Derecho Constitucional', 'Derecho Internacional',
  'Litigio', 'Redacción de Contratos', 'Negociación Legal', 'Juicio de Amparo',
  'Investigación Jurídica', 'Argumentación Jurídica', 'Cumplimiento Normativo (Compliance)', 'Propiedad Intelectual',
  'vLex / Tirant lo Blanch', 'Sistemas de Gestión de Expedientes (Lex-Doctor, Clio, etc.)',
  -- Competencias transversales de ofimática
  'Microsoft Word', 'Microsoft Excel', 'Google Workspace'
)
and a.name = 'Derecho'
on conflict (competency_id, professional_area_id) do nothing;
