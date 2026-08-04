import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/project_model.dart';
import '../../profile/models/catalog_models.dart';

class ProjectsRepository {
  final SupabaseClient _client;

  ProjectsRepository(this._client);

  Future<List<ProjectModel>?> getCachedProjects(String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'projects_cache_$profileId';
    final cachedStr = prefs.getString(cacheKey);
    if (cachedStr != null) {
      try {
        final List<dynamic> cachedData = jsonDecode(cachedStr);
        return cachedData.map((e) => ProjectModel.fromJson(e)).toList();
      } catch (e) {
        // Ignore cache error
      }
    }
    return null;
  }

  Future<List<ProjectModel>> fetchProjects(String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'projects_cache_$profileId';

    final res = await _client
        .from('projects')
        .select('*, project_competencies(competencies(name)), project_estimations(estimated_min_value, estimated_max_value, currency, complexity_result, summary)')
        .eq('profile_id', profileId)
        .order('created_at', ascending: false);
    
    final projects = (res as List<dynamic>).map<ProjectModel>((p) {
      final estimations = p['project_estimations'] as List?;
      final est = estimations != null && estimations.isNotEmpty ? estimations.first : null;
      
      return ProjectModel(
        id: p['id'] ?? '',
        profileId: p['profile_id'] ?? '',
        professionalAreaId: p['professional_area_id'] ?? '',
        name: p['name'] ?? '',
        description: p['description'] ?? '',
        projectType: p['project_type'] ?? '',
        complexity: p['complexity'] ?? '',
        estimatedTime: p['estimated_time'] ?? '',
        platforms: (p['platforms'] as List<dynamic>?)?.join(', ') ?? '',
        competencies: (p['project_competencies'] as List<dynamic>?)
            ?.map<String>((c) => (c['competencies']?['name'] as String?) ?? '')
            .where((name) => name.isNotEmpty)
            .toList() ?? <String>[],
        estimatedValueMin: (est?['estimated_min_value'] as num?)?.toInt(),
        estimatedValueMax: (est?['estimated_max_value'] as num?)?.toInt(),
        currency: est?['currency'],
        complexityResult: est?['complexity_result'],
        summary: est?['summary'],
      );
    }).toList();

    // Guardar en caché
    prefs.setString(cacheKey, jsonEncode(projects.map((p) => p.toJson()).toList()));

    return projects;
  }

  Future<ProjectModel> fetchProject(String projectId) async {
    final res = await _client
        .from('projects')
        .select('*, project_competencies(competencies(name)), project_estimations(estimated_min_value, estimated_max_value, currency, complexity_result, summary)')
        .eq('id', projectId)
        .single();
    
    final estimations = res['project_estimations'] as List?;
    final est = estimations != null && estimations.isNotEmpty ? estimations.first : null;
    
    return ProjectModel(
      id: res['id'] ?? '',
      profileId: res['profile_id'] ?? '',
      professionalAreaId: res['professional_area_id'] ?? '',
      name: res['name'] ?? '',
      description: res['description'] ?? '',
      projectType: res['project_type'] ?? '',
      complexity: res['complexity'] ?? '',
      estimatedTime: res['estimated_time'] ?? '',
      platforms: (res['platforms'] as List<dynamic>?)?.join(', ') ?? '',
      competencies: (res['project_competencies'] as List<dynamic>?)
          ?.map<String>((c) => (c['competencies']?['name'] as String?) ?? '')
          .where((name) => name.isNotEmpty)
          .toList() ?? <String>[],
      estimatedValueMin: (est?['estimated_min_value'] as num?)?.toInt(),
      estimatedValueMax: (est?['estimated_max_value'] as num?)?.toInt(),
      currency: est?['currency'],
      complexityResult: est?['complexity_result'],
      summary: est?['summary'],
    );
  }

  Future<String> addProject({
    required String profileId,
    required String professionalAreaId,
    required String name,
    required String description,
    required String projectType,
    String complexity = '',
    required String estimatedTime,
    required String platforms,
    required List<CompetencyItem> selectedCompetencies,
  }) async {
    // Insert project
    final projectRes = await _client.from('projects').insert({
      'profile_id': profileId,
      'professional_area_id': professionalAreaId,
      'name': name,
      'description': description,
      'project_type': projectType,
      'complexity': complexity,
      'estimated_time': estimatedTime,
      'platforms': platforms.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
    }).select('id').single();

    final projectId = projectRes['id'] as String;

    // Insert competencies
    if (selectedCompetencies.isNotEmpty) {
      final compData = selectedCompetencies.map((c) => {
        'project_id': projectId,
        'competency_id': c.id,
      }).toList();
      
      await _client.from('project_competencies').insert(compData);
    }
    
    return projectId;
  }

  Future<void> updateProject({
    required String projectId,
    required String name,
    required String description,
    required String projectType,
    String complexity = '',
    required String estimatedTime,
    required String platforms,
    required List<CompetencyItem> selectedCompetencies,
  }) async {
    // Update project
    await _client.from('projects').update({
      'name': name,
      'description': description,
      'project_type': projectType,
      'estimated_time': estimatedTime,
      'platforms': platforms.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
    }).eq('id', projectId);

    // Delete existing competencies
    await _client.from('project_competencies').delete().eq('project_id', projectId);

    // Insert new competencies
    if (selectedCompetencies.isNotEmpty) {
      final compData = selectedCompetencies.map((c) => {
        'project_id': projectId,
        'competency_id': c.id,
      }).toList();
      
      await _client.from('project_competencies').insert(compData);
    }
  }

  Future<void> deleteProject(String projectId) async {
    await _client.from('projects').delete().eq('id', projectId);
  }
}
