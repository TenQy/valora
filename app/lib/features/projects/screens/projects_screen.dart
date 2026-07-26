import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../models/project_model.dart';
import '../services/projects_repository.dart';
import 'add_project_screen.dart';

class ProjectsTab extends StatefulWidget {
  const ProjectsTab({super.key});

  @override
  State<ProjectsTab> createState() => _ProjectsTabState();
}

class _ProjectsTabState extends State<ProjectsTab> {
  final _repository = ProjectsRepository(Supabase.instance.client);
  List<ProjectModel>? _projects;
  bool _isLoading = true;
  String? _profileId;
  String? _professionalAreaId;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('No session');
      
      final profileRes = await Supabase.instance.client
          .from('profiles')
          .select('id, professional_area_id')
          .eq('user_id', user.id)
          .single();
          
      _profileId = profileRes['id'] as String;
      _professionalAreaId = profileRes['professional_area_id'] as String?;
      
      await _loadProjects();
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.colorError),
        );
      }
    }
  }

  Future<void> _loadProjects() async {
    if (_profileId == null) return;
    setState(() => _isLoading = true);
    try {
      final projects = await _repository.fetchProjects(_profileId!);
      if (mounted) {
        setState(() {
          _projects = projects;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.colorError),
        );
      }
    }
  }

  Future<void> _deleteProject(String id) async {
    try {
      await _repository.deleteProject(id);
      _loadProjects();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.colorError),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        if (_projects == null || _projects!.isEmpty)
          const Center(
            child: Text(
              'No has agregado proyectos aún.',
              style: TextStyle(color: AppColors.textMuted),
            ),
          )
        else
          ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.space24),
            itemCount: _projects!.length,
            itemBuilder: (context, index) {
              final project = _projects![index];
              return Card(
                color: AppColors.bgSurface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  project.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (project.estimatedValueMin != null && project.estimatedValueMax != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      'Valor AI: \$${project.estimatedValueMin} - \$${project.estimatedValueMax} ${project.currency}',
                                      style: const TextStyle(
                                        color: AppColors.green,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.colorError),
                            onPressed: () => _deleteProject(project.id),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        project.description,
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(
                            backgroundColor: AppColors.silver.withValues(alpha: 0.2),
                            label: Text(project.projectType, style: const TextStyle(color: AppColors.silver, fontSize: 11)),
                          ),
                          Chip(
                            backgroundColor: AppColors.bgPage,
                            label: Text(project.complexity, style: const TextStyle(color: AppColors.silver, fontSize: 11)),
                          ),
                        ],
                      ),
                      if (project.competencies.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: project.competencies
                              .map<Widget>((c) => Text('#$c', style: const TextStyle(color: AppColors.silverMuted, fontSize: 11)))
                              .toList(),
                        )
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        Positioned(
          bottom: AppSpacing.space24,
          right: AppSpacing.space24,
          child: FloatingActionButton(
            backgroundColor: AppColors.silver,
            onPressed: _profileId == null
                ? null
                : () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddProjectScreen(
                          profileId: _profileId!,
                          professionalAreaId: _professionalAreaId ?? '',
                        ),
                      ),
                    );
                    if (result == true) {
                      _loadProjects();
                    }
                  },
            child: const Icon(Icons.add, color: AppColors.bgBase),
          ),
        ),
      ],
    );
  }
}
