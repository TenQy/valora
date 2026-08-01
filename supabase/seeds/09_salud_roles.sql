insert into job_roles (professional_area_id, name, description, min_salary, max_salary, currency) values
  ((select id from professional_areas where name = 'Salud'), 'Médico General', 'Atención médica primaria, diagnóstico y prevención de enfermedades.', 18000, 35000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Médico Especialista', 'Atención médica de alta especialidad (Pediatría, Cirugía, Cardiología, etc.).', 30000, 80000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Enfermero(a)', 'Atención directa y cuidado integral de pacientes en hospitales y clínicas.', 12000, 25000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Enfermero(a) Especialista', 'Atención especializada (quirúrgica, cuidados intensivos, pediatría).', 18000, 35000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Odontólogo / Dentista', 'Diagnóstico y tratamiento de la salud bucodental.', 15000, 40000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Psicólogo Clínico', 'Evaluación, diagnóstico y tratamiento de la salud mental y emocional.', 15000, 30000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Nutriólogo / Dietista', 'Evaluación y diseño de planes de alimentación para la salud y prevención.', 12000, 25000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Fisioterapeuta / Kinesiólogo', 'Rehabilitación física y tratamiento de lesiones musculoesqueléticas.', 12000, 25000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Paramédico / TUM', 'Técnico en Urgencias Médicas. Atención prehospitalaria y soporte vital.', 10000, 20000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Químico Farmacobiólogo (QFB)', 'Análisis clínicos, microbiológicos y de laboratorio para diagnóstico.', 12000, 25000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Farmacéutico', 'Gestión, control y dispensación técnica de medicamentos.', 15000, 30000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Optometrista', 'Cuidado primario de la salud visual, refracción y adaptación de lentes.', 10000, 25000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Médico Veterinario (MVZ)', 'Prevención, diagnóstico y tratamiento de enfermedades en animales.', 12000, 30000, 'MXN')
on conflict (professional_area_id, name) do nothing;
