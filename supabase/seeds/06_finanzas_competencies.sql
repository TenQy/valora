insert into competencies (name, description, category) values
  -- Software Contable y Financiero
  ('QuickBooks', 'Software de contabilidad diseñado para pequeñas y medianas empresas.', 'tool'),
  ('Xero', 'Software de contabilidad en la nube popular para pymes.', 'tool'),
  ('SAP FI/CO', 'Módulo de SAP para gestión contable y controlling.', 'tool'),
  ('Aspel COI / NOI', 'Sistemas de contabilidad y nómina muy utilizados en México y LATAM.', 'tool'),
  ('Contpaqi', 'Software contable y administrativo estándar en México.', 'tool'),
  ('Sage', 'Software de gestión empresarial y contable.', 'tool'),

  -- Terminales y Herramientas Especializadas
  ('Bloomberg Terminal', 'Sistema de software para acceder a datos y análisis financieros en tiempo real.', 'tool'),
  ('Reuters Eikon', 'Plataforma de información financiera para profesionales.', 'tool'),

  -- Normativas e Impuestos
  ('NIIF / IFRS', 'Normas Internacionales de Información Financiera.', 'domain_knowledge'),
  ('US GAAP', 'Principios de contabilidad generalmente aceptados en los Estados Unidos.', 'domain_knowledge'),
  ('Legislación Fiscal', 'Conocimiento de leyes tributarias e impuestos (ISR, IVA, etc.).', 'domain_knowledge'),
  ('Declaraciones de Impuestos', 'Proceso de calcular y presentar obligaciones tributarias al gobierno.', 'domain_knowledge'),

  -- Conceptos y Metodologías Financieras
  ('Contabilidad General', 'Registro y análisis sistemático de las transacciones financieras.', 'domain_knowledge'),
  ('Cuentas por Cobrar (AR)', 'Gestión del dinero adeudado a la empresa por sus clientes.', 'domain_knowledge'),
  ('Cuentas por Pagar (AP)', 'Gestión de las obligaciones de pago de la empresa a sus proveedores.', 'domain_knowledge'),
  ('Conciliación Bancaria', 'Proceso de cuadrar los registros contables con los estados bancarios.', 'domain_knowledge'),
  ('Análisis de Estados Financieros', 'Evaluación del balance general, estado de resultados y flujo de caja.', 'domain_knowledge'),
  ('Presupuesto y Pronóstico (Forecasting)', 'Planificación financiera y estimación de ingresos/gastos futuros.', 'domain_knowledge'),
  ('Modelado Financiero (Financial Modeling)', 'Construcción de representaciones matemáticas del desempeño financiero.', 'domain_knowledge'),
  ('Gestión de Riesgos (Risk Management)', 'Identificación y mitigación de amenazas a la salud financiera de la empresa.', 'domain_knowledge'),
  ('Auditoría', 'Revisión sistemática e independiente de los registros contables y operativos.', 'domain_knowledge'),
  ('Evaluación de Proyectos de Inversión', 'Cálculo de viabilidad de inversiones (TIR, VAN / NPV, Payback).', 'domain_knowledge'),
  ('Gestión de Flujo de Efectivo', 'Monitoreo y optimización de las entradas y salidas de dinero.', 'domain_knowledge'),
  ('Tesorería', 'Administración de la liquidez, fondos e inversiones a corto plazo de una empresa.', 'domain_knowledge'),
  ('Contabilidad de Costos', 'Análisis de los costos de producción y rentabilidad de productos/servicios.', 'domain_knowledge')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in (
  'QuickBooks', 'Xero', 'SAP FI/CO', 'Aspel COI / NOI', 'Contpaqi', 'Sage',
  'Bloomberg Terminal', 'Reuters Eikon',
  'NIIF / IFRS', 'US GAAP', 'Legislación Fiscal', 'Declaraciones de Impuestos',
  'Contabilidad General', 'Cuentas por Cobrar (AR)', 'Cuentas por Pagar (AP)', 'Conciliación Bancaria',
  'Análisis de Estados Financieros', 'Presupuesto y Pronóstico (Forecasting)', 'Modelado Financiero (Financial Modeling)',
  'Gestión de Riesgos (Risk Management)', 'Auditoría', 'Evaluación de Proyectos de Inversión',
  'Gestión de Flujo de Efectivo', 'Tesorería', 'Contabilidad de Costos',
  'Microsoft Excel', 'SAP', 'Oracle ERP Cloud', 'Power BI', 'Tableau'
)
and a.name = 'Finanzas'
on conflict (competency_id, professional_area_id) do nothing;
