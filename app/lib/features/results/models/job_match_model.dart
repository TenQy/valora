class JobMatchResult {
  final String jobRoleId;
  final String jobRoleName;
  final int matchPercentage;
  final int estimatedMinSalary;
  final int estimatedMaxSalary;
  final String currency;
  final String searchQuery;
  final List<String> matchedCompetencies;
  final List<String> missingCompetencies;
  final String summary;

  JobMatchResult({
    required this.jobRoleId,
    required this.jobRoleName,
    required this.matchPercentage,
    required this.estimatedMinSalary,
    required this.estimatedMaxSalary,
    required this.currency,
    required this.searchQuery,
    required this.matchedCompetencies,
    required this.missingCompetencies,
    required this.summary,
  });

  factory JobMatchResult.fromJson(Map<String, dynamic> json) {
    return JobMatchResult(
      jobRoleId: json['job_role_id'] ?? '',
      jobRoleName: json['job_role_name'] ?? 'Rol Profesional',
      matchPercentage: (json['match_percentage'] as num?)?.toInt() ?? 0,
      estimatedMinSalary: (json['estimated_min_salary'] as num?)?.toInt() ?? 0,
      estimatedMaxSalary: (json['estimated_max_salary'] as num?)?.toInt() ?? 0,
      currency: json['currency'] ?? 'MXN',
      searchQuery: json['search_query'] ?? json['job_role_name'] ?? 'Rol Profesional',
      matchedCompetencies: List<String>.from(json['matched_competencies'] ?? []),
      missingCompetencies: List<String>.from(json['missing_competencies'] ?? []),
      summary: json['summary'] ?? '',
    );
  }
}
