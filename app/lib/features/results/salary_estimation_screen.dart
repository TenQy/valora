import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/animated_app_background.dart';
import '../../../shared/widgets/expandable_text.dart';
import '../../../shared/widgets/section_label.dart';
import '../../../shared/widgets/valora_app_bar.dart';
import 'models/salary_estimation.dart';
import 'services/results_service.dart';
import 'widgets/disclaimer_card.dart';
import 'widgets/factor_breakdown_section.dart';
import 'widgets/salary_card.dart';
import 'widgets/top_highlights_section.dart';
import 'job_match_screen.dart';

enum _LoadState { loading, success, error }

/// Pantalla de Resultados — Estimación salarial (§7 de FEATURES.md,
/// §7.7 de UI_GUIDELINES.md).
class SalaryEstimationScreen extends StatefulWidget {
  const SalaryEstimationScreen({super.key});

  @override
  State<SalaryEstimationScreen> createState() =>
      _SalaryEstimationScreenState();
}

class _SalaryEstimationScreenState extends State<SalaryEstimationScreen> {
  _LoadState _state = _LoadState.loading;
  SalaryEstimation? _result;
  final ResultsService _resultsService = ResultsService();

  SalaryEstimation get _dummyEstimation => const SalaryEstimation(
        estimatedMinSalary: 30000,
        estimatedMaxSalary: 50000,
        currency: 'MXN',
        professionalLevel: 'Analizando Nivel',
        summary: 'Calculando el valor exacto de tu perfil basándonos en tus conocimientos técnicos y la demanda actual del mercado...',
        influentialFactors: [],
        topHighlights: [
          HighlightItem(label: 'Habilidad Destacada', boost: 'Alto Impacto'),
          HighlightItem(label: 'Idioma', boost: 'Bono'),
        ],
        factorBreakdown: [
          BreakdownItem(category: 'Conocimientos', percentage: 70),
          BreakdownItem(category: 'Experiencia', percentage: 30),
        ],
      );

  @override
  void initState() {
    super.initState();
    _fetchEstimation();
  }

  Future<void> _fetchEstimation() async {
    setState(() => _state = _LoadState.loading);
    try {
      final result = await _resultsService.fetchSalaryEstimation();
      if (!mounted) return;
      setState(() {
        _result = result;
        _state = _LoadState.success;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _state = _LoadState.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      extendBodyBehindAppBar: true,
      appBar: const ValoraAppBar(
        showBackButton: true,
        title: 'Estimación salarial',
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
      return _ErrorView(onRetry: _fetchEstimation);
    }
    
    final isLoading = _state == _LoadState.loading;
    final result = isLoading ? _dummyEstimation : _result!;
    
    return Skeletonizer(
      enabled: isLoading,
      effect: ShimmerEffect(
        baseColor: AppColors.bgSurface,
        highlightColor: AppColors.silver.withValues(alpha: 0.1),
      ),
      child: _ResultView(result: result),
    );
  }
}


class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.colorError,
              size: 32,
            ),
            const SizedBox(height: AppSpacing.space16),
            const Text(
              'No pudimos calcular tu estimación. Asegúrate de haber completado tu perfil primero.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
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
  const _ResultView({required this.result});

  final SalaryEstimation result;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space24),
      children: [
        // 1. Card Principal Salarial
        SalaryCard(result: result),

        const SizedBox(height: AppSpacing.space24),

        // 2. Resumen (Expandible)
        Container(
          padding: const EdgeInsets.all(AppSpacing.space20),
          decoration: BoxDecoration(
            color: AppColors.silver.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ExpandableText(
            text: result.summary,
            maxLines: 4,
            style: const TextStyle(
              color: AppColors.silver,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.space32),

        // 3. Destacados
        if (result.topHighlights.isNotEmpty) ...[
          SectionLabel('FACTORES QUE MÁS AÑADEN VALOR'),
          const SizedBox(height: AppSpacing.space16),
          TopHighlightsSection(highlights: result.topHighlights),
          const SizedBox(height: AppSpacing.space32),
        ],

        // 4. Tabla de barras de impacto
        if (result.factorBreakdown.isNotEmpty) ...[
          SectionLabel('DESGLOSE DE IMPACTO EN TU VALOR'),
          const SizedBox(height: AppSpacing.space16),
          FactorBreakdownSection(breakdown: result.factorBreakdown),
          const SizedBox(height: AppSpacing.space32),
        ],

        // 5. Nota orientativa
        const DisclaimerCard(),

        const SizedBox(height: AppSpacing.space24),
        
        // 6. Botón de Match Laboral
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const JobMatchScreen()),
              );
            },
            icon: const Icon(Icons.work_outline),
            label: const Text('Descubrir Match Laboral', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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