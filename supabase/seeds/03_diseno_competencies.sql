insert into competencies (name, description, category) values
  ('Figma', 'Herramienta de diseño de interfaces y prototipos.', 'design_tool'),
  ('Adobe Illustrator', 'Herramienta de ilustración y diseño vectorial.', 'design_tool'),
  ('Adobe Photoshop', 'Edición de imágenes y fotografía.', 'design_tool'),
  ('UI/UX', 'Diseño de interfaz y experiencia de usuario.', 'domain_knowledge'),
  ('Blender', 'Modelado y animación 3D.', 'design_tool')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in ('Figma', 'Adobe Illustrator', 'Adobe Photoshop', 'UI/UX', 'Blender')
and a.name = 'Diseño'
on conflict (competency_id, professional_area_id) do nothing;
