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
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        title: const Text('Eliminar Proyecto', style: TextStyle(color: Colors.white)),
        content: const Text('¿Estás seguro de que deseas eliminar este proyecto? Esta acción no se puede deshacer.', style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.colorError),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

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

  Future<void> _calculateValue(String projectId) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Calculando valor...'), backgroundColor: AppColors.silver),
      );
      await Supabase.instance.client.functions.invoke(
        'project-value',
        body: {'project_id': projectId},
      );
      _loadProjects(); // Recargar para ver la estimación
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error calculando: $e'), backgroundColor: AppColors.colorError),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: AppColors.silver.withValues(alpha: 0.1), width: 1),
                ),
                elevation: 8,
                shadowColor: Colors.black.withValues(alpha: 0.2),
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  project.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (project.estimatedValueMin != null && project.estimatedValueMax != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.green.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.attach_money, color: AppColors.green, size: 14),
                                        Text(
                                          '${project.estimatedValueMin} - ${project.estimatedValueMax} ${project.currency}',
                                          style: const TextStyle(
                                            color: AppColors.green,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  GestureDetector(
                                    onTap: () => _calculateValue(project.id),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(colors: [AppColors.silver, AppColors.silverMuted]),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.auto_awesome, color: AppColors.bgBase, size: 14),
                                          SizedBox(width: 4),
                                          Text('Calcular Valor', style: TextStyle(color: AppColors.bgBase, fontSize: 12, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.bgPage,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppColors.colorError, size: 20),
                              onPressed: () => _deleteProject(project.id),
                              tooltip: 'Eliminar',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        project.description,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, height: 1.5),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.silver.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.silver.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.category_outlined, color: AppColors.silver, size: 12),
                                const SizedBox(width: 4),
                                Text(project.projectType, style: const TextStyle(color: AppColors.silver, fontSize: 12, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.bgPage,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.silver.withValues(alpha: 0.1)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.bar_chart, color: AppColors.textMuted, size: 12),
                                const SizedBox(width: 4),
                                Text(project.complexity, style: const TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (project.platforms.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text('Entregables:', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: project.platforms.split(',').map((p) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.silver.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(4)),
                            child: Text(p.trim(), style: const TextStyle(color: Colors.white, fontSize: 11)),
                          )).toList(),
                        ),
                      ],
                      if (project.competencies.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text('Herramientas:', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: project.competencies
                              .map<Widget>((c) => Text('#$c', style: const TextStyle(color: AppColors.silver, fontSize: 12, fontWeight: FontWeight.w500)))
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
