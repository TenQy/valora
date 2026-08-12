import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/database/local_db_helper.dart';
import '../models/job_match_model.dart';
import '../models/salary_estimation.dart';
import '../models/growth_path_model.dart';

class ResultsService {
  final _client = Supabase.instance.client;

  /// Llama a la Edge Function `estimate-salary` en Supabase (con soporte offline SQLite).
  Future<SalaryEstimation> fetchSalaryEstimation({String? profileId}) async {
    final effectiveProfileId = profileId ?? _client.auth.currentUser?.id ?? 'guest';

    // 1. Intentar cargar desde la base de datos local
    final cachedData = await LocalDbHelper.instance.getSalaryEstimation(effectiveProfileId);
    if (cachedData != null) {
      try {
        return SalaryEstimation.fromJson(jsonDecode(cachedData));
      } catch (_) {
        // Si el JSON falla, seguimos a la red
      }
    }

    // 2. Si no hay datos locales, ir a la red
    final res = await _client.functions.invoke(
      'estimate-salary',
      body: profileId != null ? {'profile_id': profileId} : {},
    ).timeout(const Duration(seconds: 15), onTimeout: () {
      throw Exception('Tiempo de espera agotado. El servidor tardó demasiado.');
    });

    if (res.status != 200 || res.data == null) {
      final errorMsg = (res.data is Map && res.data['error'] != null)
          ? res.data['error']
          : 'No pudimos calcular tu estimación. Asegúrate de haber guardado tu perfil primero.';
      throw Exception(errorMsg);
    }

    final data = Map<String, dynamic>.from(res.data as Map);
    final result = SalaryEstimation.fromJson(data);

    // 3. Guardar el nuevo resultado en caché local SQLite
    await LocalDbHelper.instance.saveSalaryEstimation(effectiveProfileId, jsonEncode(data));

    return result;
  }

  /// Llama a la Edge Function `job-match` en Supabase (con soporte offline SQLite).
  Future<List<JobMatchResult>> fetchJobMatches({String? profileId}) async {
    final effectiveProfileId = profileId ?? _client.auth.currentUser?.id ?? 'guest';

    // 1. Intentar cargar desde la base de datos local
    final cachedData = await LocalDbHelper.instance.getJobMatches(effectiveProfileId);
    if (cachedData != null) {
      try {
        final decodedList = jsonDecode(cachedData) as List;
        return decodedList.map((json) => JobMatchResult.fromJson(json as Map<String, dynamic>)).toList();
      } catch (_) {
        // Si el JSON falla, seguimos a la red
      }
    }

    // 2. Si no hay datos locales, ir a la red
    final res = await _client.functions.invoke(
      'job-match',
      body: profileId != null ? {'profile_id': profileId} : {},
    ).timeout(const Duration(seconds: 15), onTimeout: () {
      throw Exception('Tiempo de espera agotado. El servidor tardó demasiado.');
    });

    if (res.status != 200 || res.data == null) {
      final errorMsg = (res.data is Map && res.data['error'] != null)
          ? res.data['error']
          : 'No pudimos calcular tu compatibilidad. Asegúrate de tener perfil.';
      throw Exception(errorMsg);
    }

    final data = List<dynamic>.from(res.data as List);
    final results = data.map((json) => JobMatchResult.fromJson(json as Map<String, dynamic>)).toList();

    // 3. Guardar el nuevo resultado en caché local SQLite
    await LocalDbHelper.instance.saveJobMatches(effectiveProfileId, jsonEncode(data));

    return results;
  }

  /// Llama a la Edge Function `growth-path` en Supabase o lee de la base de datos de Supabase.
  Future<GrowthPathModel> fetchGrowthPath({String? profileId, bool forceRefresh = false}) async {
    final effectiveProfileId = profileId ?? _client.auth.currentUser?.id;

    if (effectiveProfileId == null || effectiveProfileId == 'guest') {
      throw Exception('Debes iniciar sesión para generar una ruta de crecimiento.');
    }

    // 1. Intentar cargar desde Supabase si no es forceRefresh
    if (!forceRefresh) {
      final cachedRes = await _client
          .from('growth_paths')
          .select()
          .eq('profile_id', effectiveProfileId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (cachedRes != null) {
        return GrowthPathModel.fromJson(cachedRes);
      }
    }

    // 2. Si no hay datos, o es forceRefresh, ir a la red (Edge Function)
    final res = await _client.functions.invoke(
      'growth-path',
      body: profileId != null ? {'profile_id': profileId} : {},
    ).timeout(const Duration(seconds: 15), onTimeout: () {
      throw Exception('Tiempo de espera agotado. El servidor tardó demasiado.');
    });

    if (res.status != 200 || res.data == null) {
      final errorMsg = (res.data is Map && res.data['error'] != null)
          ? res.data['error']
          : 'No pudimos generar tu ruta de crecimiento. Asegúrate de tener perfil.';
      throw Exception(errorMsg);
    }

    final data = Map<String, dynamic>.from(res.data as Map);
    return GrowthPathModel.fromJson(data);
  }
}
