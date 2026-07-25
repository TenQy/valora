// Modelos simples que reflejan las tablas descritas en DATABASE.md.
// Uso temporal con datos mock — al conectar con Supabase, estos modelos
// deben mapearse a `profiles`, `user_competencies`, `certifications`,
// `user_languages` y `projects` (ver API_CONTRACT.md).

class UserCompetency {
  const UserCompetency({required this.name, required this.level});

  final String name;
  final String level; // Básico | Intermedio | Avanzado
}

class UserLanguage {
  const UserLanguage({
    required this.flagEmoji,
    required this.language,
    required this.level,
  });

  final String flagEmoji;
  final String language;
  final String level; // A1..C2, Nativo
}

class UserCertification {
  const UserCertification({
    required this.name,
    required this.issuer,
    required this.issueDate,
  });

  final String name;
  final String issuer;
  final String issueDate;
}

class UserProject {
  const UserProject({
    required this.name,
    required this.description,
    required this.competencies,
  });

  final String name;
  final String description;
  final List<String> competencies;
}

class ProfessionalProfile {
  const ProfessionalProfile({
    required this.fullName,
    required this.professionalArea,
    required this.career,
    required this.professionalLevel,
    required this.yearsExperience,
    required this.bio,
    required this.competencies,
    required this.languages,
    required this.certifications,
    required this.projects,
  });

  final String fullName;
  final String professionalArea;
  final String career;
  final String professionalLevel;
  final int? yearsExperience;
  final String bio;
  final List<UserCompetency> competencies;
  final List<UserLanguage> languages;
  final List<UserCertification> certifications;
  final List<UserProject> projects;

  /// Perfil de ejemplo mientras se conecta la app a Supabase.
  static ProfessionalProfile mock() {
    return const ProfessionalProfile(
      fullName: 'Juan Pérez',
      professionalArea: 'Tecnología',
      career: 'Ingeniería en Sistemas Computacionales',
      professionalLevel: 'Junior',
      yearsExperience: 1,
      bio: 'Desarrollador frontend y móvil enfocado en Flutter y React. '
          'Interesado en construir productos con buena experiencia de usuario '
          'y código mantenible.',
      competencies: [
        UserCompetency(name: 'Flutter', level: 'Avanzado'),
        UserCompetency(name: 'React', level: 'Intermedio'),
        UserCompetency(name: 'Dart', level: 'Avanzado'),
        UserCompetency(name: 'Git', level: 'Intermedio'),
        UserCompetency(name: 'PostgreSQL', level: 'Básico'),
      ],
      languages: [
        UserLanguage(flagEmoji: '🇲🇽', language: 'Español', level: 'Nativo'),
        UserLanguage(flagEmoji: '🇺🇸', language: 'English', level: 'B2'),
      ],
      certifications: [
        UserCertification(
          name: 'AWS Cloud Practitioner',
          issuer: 'Amazon Web Services',
          issueDate: '2026-01-15',
        ),
      ],
      projects: [
        UserProject(
          name: 'Sistema de inventario',
          description:
              'Aplicación para administrar ventas, productos e inventario.',
          competencies: ['Flutter', 'PostgreSQL', 'Supabase'],
        ),
      ],
    );
  }
}