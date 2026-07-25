import 'package:supabase_flutter/supabase_flutter.dart';
import '../../results/models/job_match_model.dart';
import '../../results/models/salary_estimation.dart';

class DashboardData {
  final String userName;
  final String professionalLevel;
  final SalaryEstimation? latestEstimation;
  final List<JobMatchResult> latestMatches;
  final int profileCompleteness;

  DashboardData({
    required this.userName,
    required this.professionalLevel,
    required this.latestEstimation,
    required this.latestMatches,
    required this.profileCompleteness,
  });
}

class DashboardService {
  final _client = Supabase.instance.client;

  Future<DashboardData> fetchDashboardData() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('No user logged in');

    // 1. Fetch profile basics
    final profileRes = await _client
        .from('profiles')
        .select('id, full_name, professional_level, years_experience, professional_area_id')
        .eq('user_id', userId)
        .maybeSingle();

    if (profileRes == null) {
      return DashboardData(
        userName: 'Usuario',
        professionalLevel: '—',
        latestEstimation: null,
        latestMatches: [],
        profileCompleteness: 0,
      );
    }

    final profileId = profileRes['id'] as String;

    // Calcular un "perfil completado" real
    int completeness = 20; // Base por tener cuenta
    if (profileRes['full_name'] != null && profileRes['full_name'].toString().trim().isNotEmpty) completeness += 10;
    if (profileRes['professional_level'] != null) completeness += 10;
    if (profileRes['years_experience'] != null) completeness += 10;
    if (profileRes['professional_area_id'] != null) completeness += 10;

    // Verificar si tiene competencias
    final comps = await _client.from('user_competencies').select('id').eq('profile_id', profileId).limit(1);
    if (comps.isNotEmpty) completeness += 20;

    // Verificar si tiene idiomas
    final langs = await _client.from('user_languages').select('id').eq('profile_id', profileId).limit(1);
    if (langs.isNotEmpty) completeness += 10;

    // Verificar si tiene certificaciones
    final certs = await _client.from('certifications').select('id').eq('profile_id', profileId).limit(1);
    if (certs.isNotEmpty) completeness += 10;

    // 2. Fetch latest salary estimation
    final salaryRes = await _client
        .from('salary_estimations')
        .select()
        .eq('profile_id', profileId)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    SalaryEstimation? estimation;
    if (salaryRes != null) {
      estimation = SalaryEstimation(
        estimatedMinSalary: (salaryRes['estimated_min_salary'] as num?)?.toInt() ?? 0,
        estimatedMaxSalary: (salaryRes['estimated_max_salary'] as num?)?.toInt() ?? 0,
        currency: salaryRes['currency'] ?? 'MXN',
        professionalLevel: salaryRes['professional_level'] ?? '',
        summary: salaryRes['summary'] ?? '',
        influentialFactors: [], // No guardados en BD, solo en memoria
        topHighlights: [],
        factorBreakdown: [],
      );
    }

    // 3. Fetch latest job matches
    final matchesRes = await _client
        .from('job_matches')
        .select('*, job_roles(name)')
        .eq('profile_id', profileId)
        .order('created_at', ascending: false)
        .limit(3);

    final List<JobMatchResult> matches = [];
    for (final matchRow in matchesRes) {
      // En job_matches no guardamos el nombre directo, pero sí el id
      // Supabase join con job_roles(name)
      final roleName = matchRow['job_roles'] != null ? matchRow['job_roles']['name'] : 'Rol';
      matches.add(JobMatchResult.fromJson({
        ...matchRow,
        'job_role_name': roleName,
        // matched_competencies y missing_competencies ya vienen en el row
      }));
    }

    return DashboardData(
      userName: profileRes['full_name'] ?? 'Usuario',
      professionalLevel: profileRes['professional_level'] ?? '—',
      latestEstimation: estimation,
      latestMatches: matches,
      profileCompleteness: completeness,
    );
  }
}
