import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile_models.dart';
import 'language_flags.dart';

/// Acceso a Supabase para el perfil profesional del usuario autenticado.
///
/// Corresponde a `GET /profiles/me` en API_CONTRACT.md, junto con las
/// consultas relacionadas de competencias, idiomas, certificaciones y
/// proyectos (DATABASE.md). Se resuelve todo en un solo `select` anidado
/// usando los joins que Supabase infiere a partir de las foreign keys.
class ProfileRepository {
  ProfileRepository(this._client);

  final SupabaseClient _client;

  static const _profileSelect = '''
    id,
    full_name,
    career,
    professional_level,
    years_experience,
    bio,
    professional_areas ( name ),
    user_competencies ( level, competencies ( name ) ),
    user_languages ( language_levels ( name ), languages ( name ) ),
    certifications ( name, issuer, issue_date ),
    projects ( name, description, project_competencies ( competencies ( name ) ) )
  ''';

  /// Devuelve el perfil del usuario autenticado, o `null` si aún no ha
  /// creado uno (ej. justo después de registrarse, antes de llenar datos).
  ///
  /// Lanza si no hay sesión activa — el llamador debería garantizar que
  /// solo se invoque con un usuario logueado.
  Future<ProfessionalProfile?> fetchCurrentProfile() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final row = await _client
        .from('profiles')
        .select(_profileSelect)
        .eq('user_id', userId)
        .maybeSingle();

    if (row == null) return null;

    return _mapProfile(row);
  }

  ProfessionalProfile _mapProfile(Map<String, dynamic> row) {
    final professionalArea = row['professional_areas'] as Map<String, dynamic>?;

    final competencies = _asList(row['user_competencies']).map((raw) {
      final competency = raw['competencies'] as Map<String, dynamic>?;
      return UserCompetency(
        name: competency?['name'] as String? ?? '—',
        level: raw['level'] as String? ?? 'Básico',
      );
    }).toList();

    final languages = _asList(row['user_languages']).map((raw) {
      final language = raw['languages'] as Map<String, dynamic>?;
      final level = raw['language_levels'] as Map<String, dynamic>?;
      final name = language?['name'] as String? ?? '—';
      return UserLanguage(
        flagEmoji: flagForLanguage(name),
        language: name,
        level: level?['name'] as String? ?? '—',
      );
    }).toList();

    final certifications = _asList(row['certifications']).map((raw) {
      return UserCertification(
        name: raw['name'] as String? ?? '—',
        issuer: raw['issuer'] as String? ?? '—',
        issueDate: raw['issue_date'] as String? ?? '',
      );
    }).toList();

    final projects = _asList(row['projects']).map((raw) {
      final projectCompetencies = _asList(raw['project_competencies'])
          .map((pc) {
            final competency = pc['competencies'] as Map<String, dynamic>?;
            return competency?['name'] as String? ?? '—';
          })
          .toList();
      return UserProject(
        name: raw['name'] as String? ?? '—',
        description: raw['description'] as String? ?? '',
        competencies: projectCompetencies,
      );
    }).toList();

    return ProfessionalProfile(
      fullName: row['full_name'] as String? ?? '—',
      professionalArea: professionalArea?['name'] as String? ?? 'Sin área',
      career: row['career'] as String? ?? '',
      professionalLevel: row['professional_level'] as String? ?? 'Estudiante',
      yearsExperience: (row['years_experience'] as num?)?.toInt(),
      bio: row['bio'] as String? ?? '',
      competencies: competencies,
      languages: languages,
      certifications: certifications,
      projects: projects,
    );
  }

  List<Map<String, dynamic>> _asList(dynamic value) {
    if (value is! List) return const [];
    return value.cast<Map<String, dynamic>>();
  }
}