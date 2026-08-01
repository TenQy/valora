class ProfessionalAreaItem {
  const ProfessionalAreaItem({required this.id, required this.name});

  final String id;
  final String name;

  factory ProfessionalAreaItem.fromJson(Map<String, dynamic> json) {
    return ProfessionalAreaItem(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

class CompetencyItem {
  const CompetencyItem({
    required this.id,
    required this.name,
    this.category,
    this.relatedAreaIds = const [],
    this.requiresLevel = true,
  });

  final String id;
  final String name;
  final String? category;
  final List<String> relatedAreaIds;
  final bool requiresLevel;

  factory CompetencyItem.fromJson(Map<String, dynamic> json) {
    final areaIds = <String>[];
    if (json['competency_areas'] != null) {
      final list = json['competency_areas'] as List<dynamic>;
      for (final a in list) {
        areaIds.add(a['professional_area_id'] as String);
      }
    }
    return CompetencyItem(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String?,
      relatedAreaIds: areaIds,
      requiresLevel: json['requires_level'] as bool? ?? true,
    );
  }
}

class LanguageItem {
  const LanguageItem({required this.id, required this.name});

  final String id;
  final String name;

  factory LanguageItem.fromJson(Map<String, dynamic> json) {
    return LanguageItem(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

class LanguageLevelItem {
  const LanguageLevelItem({
    required this.id,
    required this.name,
    this.description,
  });

  final String id;
  final String name;
  final String? description;

  factory LanguageLevelItem.fromJson(Map<String, dynamic> json) {
    return LanguageLevelItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }
}

class JobRoleItem {
  const JobRoleItem({
    required this.id,
    required this.name,
    this.professionalAreaId,
  });

  final String id;
  final String name;
  final String? professionalAreaId;

  factory JobRoleItem.fromJson(Map<String, dynamic> json) {
    return JobRoleItem(
      id: json['id'] as String,
      name: json['name'] as String,
      professionalAreaId: json['professional_area_id'] as String?,
    );
  }
}

class CertificationIssuerItem {
  const CertificationIssuerItem({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory CertificationIssuerItem.fromJson(Map<String, dynamic> json) {
    return CertificationIssuerItem(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

class EditableUserCompetency {
  EditableUserCompetency({
    required this.competencyId,
    required this.name,
    required this.level,
    this.requiresLevel = true,
  });

  final String competencyId;
  final String name;
  String level; // Básico | Intermedio | Avanzado
  bool requiresLevel;
}

class EditableUserLanguage {
  EditableUserLanguage({
    required this.languageId,
    required this.languageName,
    required this.languageLevelId,
    required this.levelName,
  });

  final String languageId;
  final String languageName;
  String languageLevelId;
  String levelName;
}

class EditableUserCertification {
  EditableUserCertification({
    this.id,
    required this.name,
    required this.issuer,
    required this.issueDate,
  });

  String? id;
  String name;
  String issuer;
  String issueDate;
}
