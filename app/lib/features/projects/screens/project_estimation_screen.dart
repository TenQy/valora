import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/animated_app_background.dart';
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

  @override
  void initState() {
    super.initState();
    _loadOrCalculate();
  }

  Future<void> _loadOrCalculate({bool force = false}) async {
    setState(() => _state = _LoadState.loading);
    try {
      // 1. Fetch project from DB
      ProjectModel proj = await _repository.fetchProject(widget.projectId);
      
      // 2. If not calculated or forced, invoke edge function
      if (proj.estimatedValueMin == null || force) {
        setState(() => _state = _LoadState.calculating);
        await Supabase.instance.client.functions.invoke(
          'project-value',
          body: {'project_id': widget.projectId},
        );
        // Fetch again with the new estimation
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
        actions: [
          if (_state == _LoadState.success)
            IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.silver),
              tooltip: 'Recalcular valor',
              onPressed: () => _loadOrCalculate(force: true),
            ),
        ],
      ),
      body: AnimatedAppBackground(
        child: SafeArea(
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case _LoadState.loading:
        return const _LoadingView(message: 'Cargando detalles del proyecto...');
      case _LoadState.calculating:
        return const _LoadingView(message: 'La IA está calculando el valor económico basado en la complejidad y herramientas...');
      case _LoadState.error:
        return _ErrorView(error: _errorMessage, onRetry: _loadOrCalculate);
      case _LoadState.success:
        return _ResultView(project: _project!);
    }
  }
}

class _LoadingView extends StatelessWidget {
  final String message;
  const _LoadingView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(strokeWidth: 2, color: AppColors.silverMuted),
            const SizedBox(height: AppSpacing.space20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13, height: 1.5),
            ),
          ],
        ),
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

  const _ResultView({required this.project});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space24),
      children: [
        // 1. Tarjeta de Valor Principal
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: AppColors.green.withValues(alpha: 0.05),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'VALOR ESTIMADO',
                style: TextStyle(color: AppColors.green, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('\$', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(
                    '${project.estimatedValueMin} - ${project.estimatedValueMax}',
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, height: 1),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.bgPage,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  project.currency ?? 'MXN',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 32),

        // 2. Complejidad
        if (project.complexityResult != null && project.complexityResult!.isNotEmpty) ...[
          const SectionLabel('ANÁLISIS DE COMPLEJIDAD'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.silver.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.silver.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.analytics_outlined, color: AppColors.silver),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    project.complexityResult!,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],

        // 3. Resumen y Desglose
        if (project.summary != null && project.summary!.isNotEmpty) ...[
          const SectionLabel('DESGLOSE DE LA IA'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.silver.withValues(alpha: 0.1)),
            ),
            child: Text(
              project.summary!,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.6),
            ),
          ),
          const SizedBox(height: 32),
        ],

        // 4. Disclaimer
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.colorError.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: AppColors.colorError, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Esta estimación es generada por Inteligencia Artificial tomando en cuenta el mercado actual, la complejidad de tus herramientas y tiempo estimado. Utilízala como referencia, el valor final de tu trabajo siempre dependerá del contexto del cliente.',
                  style: TextStyle(color: AppColors.colorError, fontSize: 12, height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
