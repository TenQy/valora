/// Resultado de la estimación salarial, con la misma forma que la
/// respuesta de la Edge Function `estimate-salary` (ver API_CONTRACT.md #24
/// y la tabla `salary_estimations` en DATABASE.md).
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

  /// Simula la llamada a la Edge Function mientras se conecta con Supabase.
  ///
  /// Al integrar el backend real, reemplazar esta llamada por algo como:
  /// ```dart
  /// final res = await Supabase.instance.client.functions.invoke(
  ///   'estimate-salary',
  ///   body: {'profile_id': profileId},
  /// );
  /// ```
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