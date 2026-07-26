class ProjectModel {
  final String id;
  final String profileId;
  final String professionalAreaId;
  final String name;
  final String description;
  final String projectType;
  final String complexity;
  final String estimatedTime;
  final String platforms;
  final List<String> competencies; // Names of competencies
  final int? estimatedValueMin;
  final int? estimatedValueMax;
  final String? currency;

  ProjectModel({
    required this.id,
    required this.profileId,
    required this.professionalAreaId,
    required this.name,
    required this.description,
    required this.projectType,
    required this.complexity,
    required this.estimatedTime,
    required this.platforms,
    required this.competencies,
    this.estimatedValueMin,
    this.estimatedValueMax,
    this.currency,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? '',
      profileId: json['profile_id'] ?? '',
      professionalAreaId: json['professional_area_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      projectType: json['project_type'] ?? '',
      complexity: json['complexity'] ?? '',
      estimatedTime: json['estimated_time'] ?? '',
      platforms: json['platforms'] is List ? (json['platforms'] as List).join(', ') : (json['platforms']?.toString() ?? ''),
      competencies: <String>[],
    );
  }
}
