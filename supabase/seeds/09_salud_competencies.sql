insert into competencies (name, description, category) values
  -- Herramientas y Sistemas Clínicos
  ('Expediente Clínico Electrónico (ECE)', 'Software para la gestión de historiales médicos digitales de los pacientes.', 'tool'),
  ('PACS (Picture Archiving)', 'Sistemas de almacenamiento y comunicación de imágenes médicas (Rayos X, RM).', 'tool'),

  -- Soporte Vital y Urgencias
  ('Soporte Vital Básico (BLS)', 'Maniobras iniciales de atención de emergencias cardiopulmonares.', 'domain_knowledge'),
  ('Soporte Vital Cardiovascular Avanzado (ACLS)', 'Protocolos avanzados para emergencias cardiovasculares y paro cardíaco.', 'domain_knowledge'),
  ('Primeros Auxilios', 'Atención inmediata y temporal a víctimas de accidentes o enfermedades repentinas.', 'domain_knowledge'),
  ('Reanimación Cardiopulmonar (RCP)', 'Técnicas manuales para mantener la oxigenación en emergencias.', 'domain_knowledge'),
  
  -- Procedimientos Clínicos Generales
  ('Suturas y Cuidado de Heridas', 'Técnicas de cierre y manejo de heridas quirúrgicas o traumáticas.', 'domain_knowledge'),
  ('Venopunción / Extracción de Sangre', 'Procedimientos seguros para la recolección de muestras sanguíneas.', 'domain_knowledge'),
  ('Inmunización / Vacunación', 'Manejo de red de frío y administración segura de vacunas.', 'domain_knowledge'),
  ('Control de Infecciones / Bioseguridad', 'Protocolos para prevenir infecciones intrahospitalarias (nosocomiales).', 'domain_knowledge'),
  
  -- Diagnóstico
  ('Interpretación de Análisis Clínicos', 'Lectura diagnóstica de estudios de laboratorio (hematología, química sanguínea, etc.).', 'domain_knowledge'),
  ('Interpretación de Imagenología', 'Lectura básica de estudios radiológicos, ultrasonidos y tomografías.', 'domain_knowledge'),
  ('Electrocardiografía (ECG)', 'Toma e interpretación de la actividad eléctrica del corazón.', 'domain_knowledge'),

  -- Conocimientos por Especialidad
  ('Farmacología', 'Conocimiento de interacciones, mecanismos y dosis de medicamentos.', 'domain_knowledge'),
  ('Anatomía y Fisiología', 'Conocimiento profundo de la estructura y funcionamiento del cuerpo humano.', 'domain_knowledge'),
  ('Terapia Cognitivo-Conductual (TCC)', 'Enfoque psicoterapéutico basado en la modificación de pensamientos y conductas.', 'domain_knowledge'),
  ('Evaluación Nutricional', 'Cálculo de requerimientos calóricos y diseño de planes dietéticos.', 'domain_knowledge'),
  ('Kinesioterapia / Rehabilitación Física', 'Tratamiento de dolencias mediante el movimiento y terapia manual.', 'domain_knowledge'),
  ('Odontología Preventiva y Restaurativa', 'Prevención de caries, limpieza dental, resinas y tratamientos bucales básicos.', 'domain_knowledge'),
  
  -- Gestión y Normativa
  ('Normativas de Salud', 'Conocimiento de la legislación sanitaria (Ej. NOMs en México, HIPAA en EE.UU.).', 'domain_knowledge'),
  ('Ética Médica y Bioética', 'Principios éticos aplicados al trato del paciente y experimentación médica.', 'domain_knowledge')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in (
  'Expediente Clínico Electrónico (ECE)', 'PACS (Picture Archiving)',
  'Soporte Vital Básico (BLS)', 'Soporte Vital Cardiovascular Avanzado (ACLS)', 'Primeros Auxilios', 'Reanimación Cardiopulmonar (RCP)',
  'Suturas y Cuidado de Heridas', 'Venopunción / Extracción de Sangre', 'Inmunización / Vacunación', 'Control de Infecciones / Bioseguridad',
  'Interpretación de Análisis Clínicos', 'Interpretación de Imagenología', 'Electrocardiografía (ECG)',
  'Farmacología', 'Anatomía y Fisiología', 'Terapia Cognitivo-Conductual (TCC)', 'Evaluación Nutricional',
  'Kinesioterapia / Rehabilitación Física', 'Odontología Preventiva y Restaurativa',
  'Normativas de Salud', 'Ética Médica y Bioética'
)
and a.name = 'Salud'
on conflict (competency_id, professional_area_id) do nothing;

-- Marcar competencias como binarias (no requieren nivel)
update competencies
set requires_level = false
where name in (
  'Soporte Vital Básico (BLS)',
  'Soporte Vital Cardiovascular Avanzado (ACLS)',
  'Primeros Auxilios',
  'Reanimación Cardiopulmonar (RCP)',
  'Inmunización / Vacunación',
  'Control de Infecciones / Bioseguridad',
  'Anatomía y Fisiología',
  'Normativas de Salud',
  'Ética Médica y Bioética'
);
