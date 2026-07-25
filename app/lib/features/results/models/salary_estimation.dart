import 'package:supabase_flutter/supabase_flutter.dart';

/// Resultado de la estimación salarial retornado por la Edge Function `estimate-salary`
/// (ver API_CONTRACT.md #24 y la tabla `salary_estimations` en DATABASE.md).
class SalaryEstimation {
  const SalaryEstimation({
    required this.estimatedMinSalary,
    required this.estimatedMaxSalary,
    required this.currency,
    required this.professionalLevel,
    required this.summary,
    required this.influentialFactors,
  });

  final int estimatedMinSalary;
  final int estimatedMaxSalary;
  final String currency;
  final String professionalLevel;
  final String summary;
  final List<String> influentialFactors;

  factory SalaryEstimation.fromJson(Map<String, dynamic> json) {
    return SalaryEstimation(
      estimatedMinSalary: (json['estimated_min_salary'] as num?)?.toInt() ?? 0,
      estimatedMaxSalary: (json['estimated_max_salary'] as num?)?.toInt() ?? 0,
      currency: json['currency'] as String? ?? 'MXN',
      professionalLevel: json['professional_level'] as String? ?? '—',
      summary: json['summary'] as String? ?? '',
      influentialFactors: (json['influential_factors'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  /// Llama a la Edge Function `estimate-salary` en Supabase.
  static Future<SalaryEstimation> fetchFromEdgeFunction({String? profileId}) async {
    final client = Supabase.instance.client;
    final res = await client.functions.invoke(
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

  static Future<SalaryEstimation> fetchMock() {
    return Future.delayed(
      const Duration(milliseconds: 1400),
      () => const SalaryEstimation(
        estimatedMinSalary: 25000,
        estimatedMaxSalary: 35000,
        currency: 'MXN',
        professionalLevel: 'Junior',
        summary: 'El perfil muestra buena compatibilidad con roles '
            'iniciales de desarrollo frontend.',
        influentialFactors: [
          'React',
          'Flutter',
          'Inglés B2',
          '1 año de experiencia',
        ],
      ),
    );
  }
}