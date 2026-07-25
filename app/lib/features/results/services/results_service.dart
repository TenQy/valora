import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/job_match_model.dart';
import '../models/salary_estimation.dart';

class ResultsService {
  final _client = Supabase.instance.client;

  /// Llama a la Edge Function `estimate-salary` en Supabase.
  Future<SalaryEstimation> fetchSalaryEstimation({String? profileId}) async {
    final res = await _client.functions.invoke(
      'estimate-salary',
      body: profileId != null ? {'profile_id': profileId} : {},
    );

    if (res.status != 200 || res.data == null) {
      final errorMsg = (res.data is Map && res.data['error'] != null)
          ? res.data['error']
          : 'No pudimos calcular tu estimación. Asegúrate de haber guardado tu perfil primero.';
      throw Exception(errorMsg);
    }

    final data = Map<String, dynamic>.from(res.data as Map);
    return SalaryEstimation.fromJson(data);
  }

  /// Llama a la Edge Function `job-match` en Supabase.
  Future<List<JobMatchResult>> fetchJobMatches({String? profileId}) async {
    final res = await _client.functions.invoke(
      'job-match',
      body: profileId != null ? {'profile_id': profileId} : {},
    );

    if (res.status != 200 || res.data == null) {
      final errorMsg = (res.data is Map && res.data['error'] != null)
          ? res.data['error']
          : 'No pudimos calcular tu compatibilidad. Asegúrate de tener perfil.';
      throw Exception(errorMsg);
    }

    final data = List<dynamic>.from(res.data as List);
    return data.map((json) => JobMatchResult.fromJson(json as Map<String, dynamic>)).toList();
  }
}
