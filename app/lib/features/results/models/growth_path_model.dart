import 'dart:convert';

class GrowthPathMilestone {
  final String title;
  final String description;
  final String type; // skill, certification, experience, language, soft_skill

  GrowthPathMilestone({
    required this.title,
    required this.description,
    required this.type,
  });

  factory GrowthPathMilestone.fromJson(Map<String, dynamic> json) {
    return GrowthPathMilestone(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? 'skill',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type,
    };
  }
}

class GrowthPathModel {
  final String currentLevel;
  final String nextLevel;
  final String estimatedTime;
  final String summary;
  final List<GrowthPathMilestone> milestones;

  GrowthPathModel({
    required this.currentLevel,
    required this.nextLevel,
    required this.estimatedTime,
    required this.summary,
    required this.milestones,
  });

  factory GrowthPathModel.fromJson(Map<String, dynamic> json) {
    return GrowthPathModel(
      currentLevel: json['current_level'] ?? '',
      nextLevel: json['next_level'] ?? '',
      estimatedTime: json['estimated_time'] ?? '',
      summary: json['summary'] ?? '',
      milestones: (json['milestones'] as List<dynamic>?)
              ?.map((e) => GrowthPathMilestone.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_level': currentLevel,
      'next_level': nextLevel,
      'estimated_time': estimatedTime,
      'summary': summary,
      'milestones': milestones.map((e) => e.toJson()).toList(),
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory GrowthPathModel.fromJsonString(String source) =>
      GrowthPathModel.fromJson(jsonDecode(source));
}
