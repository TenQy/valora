import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/animated_app_background.dart';
import '../../../shared/widgets/expandable_text.dart';
import '../../../shared/widgets/section_label.dart';
import '../../../shared/widgets/valora_app_bar.dart';
import '../models/project_model.dart';
import '../services/projects_repository.dart';

enum _LoadState { loading, calculating, success, error }

class ProjectEstimationScreen extends StatefulWidget {
  final String projectId;
  
  const ProjectEstimationScreen({super.key, required this.projectId});

  @override
  State<ProjectEstimationScreen> createState() => _ProjectEstimationScreenState();
}

class _ProjectEstimationScreenState extends State<ProjectEstimationScreen> {
  _LoadState _state = _LoadState.loading;
  ProjectModel? _project;
  final ProjectsRepository _repository = ProjectsRepository(Supabase.instance.client);
  String _errorMessage = '';

  ProjectModel get _dummyProject => ProjectModel(
    id: 'dummy',
    profileId: '',
    professionalAreaId: '',
    name: 'Nombre del Proyecto',
    description: 'Descripción de prueba para skeletonizer.',
    projectType: 'Tipo',
    complexity: 'Media',
    estimatedTime: '2 Semanas',
    platforms: 'Web',
    competencies: ['Dart', 'Flutter'],
    estimatedValueMin: 12000,
    estimatedValueMax: 18000,
    currency: 'MXN',
    complexityResult: 'La complejidad técnica de las herramientas usadas indica que...',
    summary: 'La Inteligencia Artificial ha evaluado que este proyecto...',
  );

  @override
  void initState() {
    super.initState();
    _loadOrCalculate();
  }

  Future<void> _loadOrCalculate({bool force = false}) async {
    setState(() => _state = _LoadState.loading);
    try {
      ProjectModel proj = await _repository.fetchProject(widget.projectId);
      
      if (proj.estimatedValueMin == null || force) {
        setState(() => _state = _LoadState.calculating);
        await Supabase.instance.client.functions.invoke(
          'project-value',
          body: {'project_id': widget.projectId},
        );
        proj = await _repository.fetchProject(widget.projectId);
      }

      if (mounted) {
        setState(() {
          _project = proj;
          _state = _LoadState.success;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _state = _LoadState.error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      extendBodyBehindAppBar: true,
      appBar: ValoraAppBar(
        showBackButton: true,
        title: _project?.name ?? 'Valor del Proyecto',
        actions: const [], 
      ),
      body: AnimatedAppBackground(
        child: SafeArea(
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_state == _LoadState.error) {
      return _ErrorView(error: _errorMessage, onRetry: _loadOrCalculate);
    }
    
    final isLoading = _state == _LoadState.loading || _state == _LoadState.calculating;
    final displayProject = _project ?? _dummyProject;

    return Skeletonizer(
      enabled: isLoading,
      effect: ShimmerEffect(
        baseColor: AppColors.bgSurface.withValues(alpha: 0.5),
        highlightColor: AppColors.silverSubtle,
      ),
      child: _ResultView(
        project: displayProject, 
        isCalculating: _state == _LoadState.calculating,
        onRecalculate: () => _loadOrCalculate(force: true),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.colorError, size: 32),
            const SizedBox(height: AppSpacing.space16),
            Text(
              'Ocurrió un error al estimar el proyecto:\n$error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: AppSpacing.space20),
            OutlinedButton(onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  final ProjectModel project;
  final bool isCalculating;
  final VoidCallback onRecalculate;

  const _ResultView({
    required this.project, 
    required this.isCalculating,
    required this.onRecalculate,
  });

  @override
  Widget build(BuildContext context) {
    final isSkeleton = Skeletonizer.of(context).enabled;
    
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space24),
      children: [
        if (isCalculating)
          Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.space20),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.silver.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16, height: 16, 
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.silver)
                ),
                SizedBox(width: 12),
                Text('La IA está calculando la estimación...', style: TextStyle(color: AppColors.silver, fontSize: 13)),
              ],
            ),
          ),
          
        // 1. Tarjeta de Valor Principal
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderDefault),
            boxShadow: const [
              BoxShadow(
                color: Color(0x80000000),
                blurRadius: 60,
                offset: Offset(0, 20),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              children: [
                if (!isSkeleton)
                  Positioned(
                    top: -40,
                    right: -40,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Color(0x1F4ADE80), // greenDim
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.space28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VALOR ESTIMADO DEL PROYECTO',
                        style: AppTextStyles.sectionLabel,
                      ),
                      const SizedBox(height: AppSpacing.space12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text('\$', style: AppTextStyles.currencySymbol),
                          const SizedBox(width: AppSpacing.space4),
                          Flexible(
                            child: Text(
                              '${Formatters.formatThousands(project.estimatedValueMin ?? 0)} – ${Formatters.formatThousands(project.estimatedValueMax ?? 0)}',
                              style: AppTextStyles.salary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.space8),
                      Text(
                        'Divisa de referencia: ${project.currency ?? 'MXN'}',
                        style: AppTextStyles.subtitle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: AppSpacing.space24),

        // 2. Resumen (Expandible)
        if (project.summary != null && project.summary!.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(AppSpacing.space20),
            decoration: BoxDecoration(
              color: AppColors.silver.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ExpandableText(
              text: project.summary!,
              maxLines: 4,
              style: const TextStyle(
                color: AppColors.silver,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.space32),
        ],

        // 3. Complejidad
        if (project.complexityResult != null && project.complexityResult!.isNotEmpty) ...[
          const SectionLabel('ANÁLISIS DE COMPLEJIDAD'),
          const SizedBox(height: AppSpacing.space16),
          Container(
            padding: const EdgeInsets.all(AppSpacing.space20),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.silver.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.analytics_outlined, color: AppColors.silver, size: 20),
                ),
                const SizedBox(width: AppSpacing.space16),
                Expanded(
                  child: Text(
                    project.complexityResult!,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.space32),
        ],

        // 4. Disclaimer
        Container(
          padding: const EdgeInsets.all(AppSpacing.space16),
          decoration: BoxDecoration(
            color: AppColors.bgElevated,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.silverMuted,
              ),
              const SizedBox(width: AppSpacing.space12),
              Expanded(
                child: Text(
                  'Esta estimación es generada por Inteligencia Artificial tomando en cuenta el mercado actual, las tecnologías y el tiempo estimado. Utilízala solo como referencia orientativa.',
                  style: AppTextStyles.hint,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.space32),

        // 5. Botón Recalcular
        if (!isSkeleton)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onRecalculate,
              icon: const Icon(Icons.refresh),
              label: const Text('Recalcular Estimación', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          
        const SizedBox(height: AppSpacing.space24),
      ],
    );
  }
}
