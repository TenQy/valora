import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/animated_app_background.dart';
import '../../../shared/widgets/section_label.dart';
import '../../../shared/widgets/valora_app_bar.dart';
import 'models/salary_estimation.dart';
import 'services/results_service.dart';
import 'widgets/disclaimer_card.dart';
import 'widgets/factor_breakdown_section.dart';
import 'widgets/salary_card.dart';
import 'widgets/score_grid.dart';
import 'widgets/top_highlights_section.dart';

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
    switch (_state) {
      case _LoadState.loading:
        return const _LoadingView();
      case _LoadState.error:
        return _ErrorView(onRetry: _fetchEstimation);
      case _LoadState.success:
        return _ResultView(result: _result!);
    }
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.silverMuted,
          ),
          SizedBox(height: AppSpacing.space20),
          Text(
            'Calculando tu estimación salarial...',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ],
      ),
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

        // 2. Grid 2x2 de métricas
        ScoreGrid(result: result),

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
      ],
    );
  }
}