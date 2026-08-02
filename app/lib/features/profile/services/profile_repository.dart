import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/database/local_db_helper.dart';
import '../models/catalog_models.dart';
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
    user_competencies ( level, competencies ( name, requires_level ) ),
    user_languages ( language_levels ( name ), languages ( name ) ),
    certifications ( name, issuer, issue_date ),
    projects ( name, description, project_competencies ( competencies ( name ) ) )
  ''';

  /// Devuelve el perfil del usuario autenticado, o `null` si aún no ha
  /// creado uno (ej. justo después de registrarse, antes de llenar datos).
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

  /// Consulta el perfil crudo con IDs para pre-poblar el formulario de edición.
  Future<Map<String, dynamic>?> fetchRawProfileForEditing() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    const select = '''
      id,
      full_name,
      professional_area_id,
      career,
      professional_level,
      years_experience,
      bio,
      user_competencies ( competency_id, level, competencies ( name, requires_level ) ),
      user_languages ( language_id, language_level_id, languages ( name ), language_levels ( name ) ),
      certifications ( id, name, issuer, issue_date )
    ''';

    return _client
        .from('profiles')
        .select(select)
        .eq('user_id', userId)
        .maybeSingle();
  }

  /// Catálogos
  Future<List<ProfessionalAreaItem>> fetchProfessionalAreas() async {
    final data = await _client
        .from('professional_areas')
        .select('id, name')
        .eq('is_active', true)
        .order('name');
    return _asList(data).map((e) => ProfessionalAreaItem.fromJson(e)).toList();
  }

  Future<List<CompetencyItem>> fetchCompetencies() async {
    final data = await _client
        .from('competencies')
        .select('id, name, category, requires_level, competency_areas(professional_area_id)')
        .eq('is_active', true)
        .order('name', ascending: true);
    return _asList(data).map((e) => CompetencyItem.fromJson(e)).toList();
  }

  Future<List<LanguageItem>> fetchLanguages() async {
    final data = await _client
        .from('languages')
        .select('id, name')
        .eq('is_active', true)
        .order('name');
    return _asList(data).map((e) => LanguageItem.fromJson(e)).toList();
  }

  Future<List<LanguageLevelItem>> fetchLanguageLevels() async {
    final data = await _client
        .from('language_levels')
        .select('id, name, description')
        .order('created_at');
    return _asList(data).map((e) => LanguageLevelItem.fromJson(e)).toList();
  }

  Future<List<JobRoleItem>> fetchJobRoles() async {
    final data = await _client
        .from('job_roles')
        .select('id, name, professional_area_id')
        .eq('is_active', true)
        .order('name', ascending: true);
    return _asList(data).map((e) => JobRoleItem.fromJson(e)).toList();
  }

  Future<List<CertificationIssuerItem>> fetchCertificationIssuers() async {
    final data = await _client
        .from('certification_issuers')
        .select('id, name')
        .eq('is_active', true)
        .order('name');
    return _asList(data).map((e) => CertificationIssuerItem.fromJson(e)).toList();
  }

  /// Valida mediante IA si un texto ingresado por el usuario es razonable.
  Future<bool> validateText(String text, String type) async {
    final res = await _client.functions.invoke(
      'validate-text',
      body: {'text': text, 'type': type},
    );
    
    if (res.status != 200 || res.data == null) {
      throw Exception('Fallo en el servicio de validación');
    }
    
    return res.data['isValid'] as bool? ?? true;
  }

  /// Guarda / Actualiza el perfil completo del usuario y sus relaciones.
  /// Retorna el ID del perfil creado o actualizado.
  Future<String> saveProfile({
    required String fullName,
    required String? professionalAreaId,
    required String career,
    required String professionalLevel,
    required int? yearsExperience,
    required String bio,
    required List<EditableUserCompetency> competencies,
    required List<EditableUserLanguage> languages,
    required List<EditableUserCertification> certifications,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('No hay sesión activa para guardar el perfil.');

    final userFullName = fullName.trim().isNotEmpty
        ? fullName.trim()
        : (user.userMetadata?['full_name'] as String? ?? 'Usuario');

    // 1. Upsert en profiles
    final profileRow = await _client.from('profiles').upsert({
      'user_id': user.id,
      'full_name': userFullName,
      'professional_area_id': professionalAreaId,
      'career': career.trim(),
      'professional_level': professionalLevel,
      'years_experience': yearsExperience,
      'bio': bio.trim(),
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }, onConflict: 'user_id').select('id').single();

    final profileId = profileRow['id'] as String;

    // 2. Actualizar competencias
    await _client.from('user_competencies').delete().eq('profile_id', profileId);
    if (competencies.isNotEmpty) {
      await _client.from('user_competencies').insert(
        competencies.map((c) => {
          'profile_id': profileId,
          'competency_id': c.competencyId,
          'level': c.requiresLevel ? c.level : null,
        }).toList(),
      );
    }

    // 3. Actualizar idiomas
    await _client.from('user_languages').delete().eq('profile_id', profileId);
    if (languages.isNotEmpty) {
      await _client.from('user_languages').insert(
        languages.map((l) => {
          'profile_id': profileId,
          'language_id': l.languageId,
          'language_level_id': l.languageLevelId,
        }).toList(),
      );
    }

    // 4. Actualizar certificaciones
    await _client.from('certifications').delete().eq('profile_id', profileId);
    if (certifications.isNotEmpty) {
      await _client.from('certifications').insert(
        certifications.map((cert) => {
          'profile_id': profileId,
          'name': cert.name.trim(),
          'issuer': cert.issuer.trim(),
          'issue_date': cert.issueDate.isNotEmpty ? cert.issueDate : null,
        }).toList(),
      );
    }

    // 5. Limpiar caché en SQLite para forzar recalculación con IA
    await LocalDbHelper.instance.clearSalaryEstimation(profileId);
    await LocalDbHelper.instance.clearSalaryEstimation(user.id);
    await LocalDbHelper.instance.clearSalaryEstimation('guest');

    await LocalDbHelper.instance.clearJobMatches(profileId);
    await LocalDbHelper.instance.clearJobMatches(user.id);
    await LocalDbHelper.instance.clearJobMatches('guest');

    return profileId;
  }

  /// Migra los datos de estimación del invitado a su nuevo perfil
  Future<void> saveGuestEstimation(String profileId, Map<String, dynamic> guestData) async {
    await _client.from('salary_estimations').insert({
      'profile_id': profileId,
      'professional_area_id': guestData['professional_area_id'],
      'estimated_min_salary': guestData['estimated_min_salary'],
      'estimated_max_salary': guestData['estimated_max_salary'],
      'currency': guestData['currency'],
      'professional_level': guestData['professional_level'],
      'summary': guestData['summary'],
    });
  }

  ProfessionalProfile _mapProfile(Map<String, dynamic> row) {
    final professionalArea = row['professional_areas'] as Map<String, dynamic>?;

    final competencies = _asList(row['user_competencies']).map<UserCompetency>((raw) {
      final competency = raw['competencies'] as Map<String, dynamic>?;
      return UserCompetency(
        name: competency?['name'] as String? ?? '—',
        level: raw['level'] as String? ?? 'Básico',
        requiresLevel: competency?['requires_level'] as bool? ?? true,
      );
    }).toList();

    final languages = _asList(row['user_languages']).map<UserLanguage>((raw) {
      final language = raw['languages'] as Map<String, dynamic>?;
      final level = raw['language_levels'] as Map<String, dynamic>?;
      final name = language?['name'] as String? ?? '—';
      return UserLanguage(
        flagEmoji: flagForLanguage(name),
        language: name,
        level: level?['name'] as String? ?? '—',
      );
    }).toList();

    final certifications = _asList(row['certifications']).map<UserCertification>((raw) {
      return UserCertification(
        name: raw['name'] as String? ?? '—',
        issuer: raw['issuer'] as String? ?? '—',
        issueDate: raw['issue_date'] as String? ?? '',
      );
    }).toList();

    final projects = _asList(row['projects']).map<UserProject>((raw) {
      final projectCompetencies = _asList(raw['project_competencies'])
          .map<String>((pc) {
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
    if (value == null) return <Map<String, dynamic>>[];
    if (value is List) return value.cast<Map<String, dynamic>>().toList();
    return <Map<String, dynamic>>[];
  }
}