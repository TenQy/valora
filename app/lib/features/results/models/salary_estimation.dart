
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
      influentialFactors: (json['influential_factors'] as List<dynamic>?)
              ?.map<String>((e) => e.toString())
              .toList() ??
          <String>[],
      topHighlights: (json['top_highlights'] as List<dynamic>?)
              ?.map<HighlightItem>((e) => HighlightItem.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          <HighlightItem>[],
      factorBreakdown: (json['factor_breakdown'] as List<dynamic>?)
              ?.map<BreakdownItem>((e) => BreakdownItem.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          <BreakdownItem>[],
    );
  }

}