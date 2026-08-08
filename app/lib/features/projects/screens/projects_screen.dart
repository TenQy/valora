import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_animate/flutter_animate.dart' hide ShimmerEffect;
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/expandable_text.dart';
import '../models/project_model.dart';
import '../services/projects_repository.dart';
import 'add_project_screen.dart';
import 'project_estimation_screen.dart';

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

  List<ProjectModel> get _fakeProjects => List.generate(
    3,
    (index) => ProjectModel(
      id: 'fake_$index',
      profileId: '',
      professionalAreaId: '',
      name: 'Cargando Proyecto...',
      description: 'Esta es una descripción de prueba muy larga que se usa para mostrar el skeleton loader mientras el proyecto carga los datos reales desde la base de datos.',
      projectType: 'Desarrollo Web',
      complexity: '',
      estimatedTime: '1 mes',
      platforms: 'Web, Móvil',
      competencies: ['Flutter', 'Dart', 'Supabase'],
    ),
  );

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
      final cached = await _repository.getCachedProjects(_profileId!);
      if (cached != null && mounted) {
        setState(() {
          _projects = cached;
          _isLoading = false;
        });
      }
      
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

  void _openEstimation(String projectId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProjectEstimationScreen(projectId: projectId),
      ),
    ).then((_) => _loadProjects()); // Recargar proyectos al volver
  }

  Future<void> _navigateToAddProject({ProjectModel? projectToEdit}) async {
    if (_profileId == null) return;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddProjectScreen(
          profileId: _profileId!,
          professionalAreaId: _professionalAreaId ?? '',
          projectToEdit: projectToEdit,
        ),
      ),
    );
    if (result == true) {
      _loadProjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayProjects = (_isLoading && (_projects == null || _projects!.isEmpty))
        ? _fakeProjects
        : _projects;

    return Skeletonizer(
      enabled: _isLoading,
      effect: ShimmerEffect(
        baseColor: AppColors.bgSurface.withValues(alpha: 0.5),
        highlightColor: AppColors.silverSubtle,
      ),
      child: Column(
        children: [
          if (_profileId != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.space24, AppSpacing.space24, AppSpacing.space24, AppSpacing.space8),
              child: Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: () => _navigateToAddProject(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Agregar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.silver,
                    side: const BorderSide(color: AppColors.borderDefault),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ),
        Expanded(
          child: (!_isLoading && (displayProjects == null || displayProjects.isEmpty))
              ? const Center(
                  child: Text(
                    'No has agregado proyectos aún.',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.space24),
            itemCount: displayProjects?.length ?? 0,
            itemBuilder: (context, index) {
              final project = displayProjects![index];
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
                                  GestureDetector(
                                    onTap: () => _openEstimation(project.id),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.monetization_on_rounded, color: AppColors.green, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${project.estimatedValueMin} - ${project.estimatedValueMax} ${project.currency}',
                                            style: const TextStyle(
                                              color: AppColors.green,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: -0.3,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Icon(Icons.info_outline, color: AppColors.green.withValues(alpha: 0.5), size: 14),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  OutlinedButton.icon(
                                    onPressed: () => _openEstimation(project.id),
                                    icon: const Icon(Icons.auto_awesome, size: 14),
                                    label: const Text('Calcular Valor'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.silver,
                                      side: const BorderSide(color: AppColors.borderSubtle),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                      minimumSize: const Size(0, 28),
                                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, color: AppColors.silver, size: 20),
                                  onPressed: () => _navigateToAddProject(projectToEdit: project),
                                  tooltip: 'Editar',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: AppColors.colorError, size: 20),
                                  onPressed: () => _deleteProject(project.id),
                                  tooltip: 'Eliminar',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ExpandableText(
                        text: project.description,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, height: 1.5),
                        maxLines: 3,
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
                              .map<Widget>((c) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.silver.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AppColors.silver.withValues(alpha: 0.2)),
                                ),
                                child: Text(c, style: const TextStyle(color: AppColors.silver, fontSize: 12, fontWeight: FontWeight.w500)),
                              ))
                              .toList(),
                        )
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
}
