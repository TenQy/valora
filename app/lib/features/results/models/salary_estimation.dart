import 'package:supabase_flutter/supabase_flutter.dart';

class HighlightItem {
  const HighlightItem({required this.label, required this.boost});

  final String label;
  final String boost;

  factory HighlightItem.fromJson(Map<String, dynamic> json) {
    return HighlightItem(
      label: json['label'] as String? ?? '',
      boost: json['boost'] as String? ?? '',
    );
  }
}

class BreakdownItem {
  const BreakdownItem({required this.category, required this.percentage});

  final String category;
  final int percentage;

  factory BreakdownItem.fromJson(Map<String, dynamic> json) {
    return BreakdownItem(
      category: json['category'] as String? ?? '',
      percentage: (json['percentage'] as num?)?.toInt() ?? 0,
    );
  }
}

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
    required this.topHighlights,
    required this.factorBreakdown,
  });

  final int estimatedMinSalary;
  final int estimatedMaxSalary;
  final String currency;
  final String professionalLevel;
  final String summary;
  final List<String> influentialFactors;
  final List<HighlightItem> topHighlights;
  final List<BreakdownItem> factorBreakdown;

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
      topHighlights: (json['top_highlights'] as List?)
              ?.map((e) => HighlightItem.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
      factorBreakdown: (json['factor_breakdown'] as List?)
              ?.map((e) => BreakdownItem.fromJson(Map<String, dynamic>.from(e as Map)))
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
}