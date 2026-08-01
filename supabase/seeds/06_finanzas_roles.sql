insert into job_roles (professional_area_id, name, description, min_salary, max_salary, currency) values
  ((select id from professional_areas where name = 'Finanzas'), 'Analista Financiero', 'Analiza datos financieros, proyecciones y viabilidad de proyectos.', 20000, 45000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Contador', 'Maneja el registro contable, pólizas y estados financieros.', 12000, 30000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Especialista en Impuestos (Fiscalista)', 'Gestión, planeación y cumplimiento de obligaciones fiscales y tributarias.', 18000, 40000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Auditor', 'Revisa y evalúa la exactitud de los registros contables y el cumplimiento de normativas.', 20000, 45000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Tesorero / Gerente de Tesorería', 'Administra el flujo de efectivo, liquidez e inversiones a corto plazo.', 25000, 55000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Contralor (Controller)', 'Supervisa la contabilidad general, auditorías internas y control financiero.', 35000, 70000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Director Financiero (CFO)', 'Máximo responsable de la estrategia financiera, riesgo y estructura de capital.', 60000, 150000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Especialista en Cuentas por Pagar (AP)', 'Gestiona los pagos a proveedores y obligaciones a corto plazo.', 12000, 22000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Especialista en Cuentas por Cobrar (AR)', 'Gestiona la cobranza, facturación y crédito a clientes.', 12000, 22000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Analista de Riesgos', 'Evalúa y mitiga riesgos financieros, operativos y de crédito.', 25000, 50000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Analista de Crédito', 'Evalúa la solvencia de solicitantes de crédito o financiamiento.', 15000, 30000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Gestor de Patrimonios (Wealth Manager)', 'Asesora sobre inversiones y gestión de capital para clientes o instituciones.', 30000, 80000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Analista de Inversiones', 'Investiga mercados y activos para fundamentar decisiones de inversión.', 22000, 50000, 'MXN')
on conflict (professional_area_id, name) do nothing;
