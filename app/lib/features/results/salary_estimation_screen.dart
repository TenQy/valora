import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/section_label.dart';
import '../../../shared/widgets/skill_chip.dart';
import 'models/salary_estimation.dart';

enum _LoadState { loading, success, error }

/// Pantalla de Resultados — Estimación salarial (§7 de FEATURES.md,
/// §7.7 de UI_GUIDELINES.md).
///
/// Al entrar, muestra una pantalla de carga mientras se calcula la
/// estimación. El valor central usa Cormorant Garamond en `green`, ya que
/// es la única pantalla (junto con Valor de Proyecto) donde el CTA/valor
/// principal puede llevar el accent verde — ver UI_GUIDELINES.md §3 y §6.1.
class SalaryEstimationScreen extends StatefulWidget {
  const SalaryEstimationScreen({super.key});

  @override
  State<SalaryEstimationScreen> createState() =>
      _SalaryEstimationScreenState();
}

class _SalaryEstimationScreenState extends State<SalaryEstimationScreen> {
  _LoadState _state = _LoadState.loading;
  SalaryEstimation? _result;

  @override
  void initState() {
    super.initState();
    _fetchEstimation();
  }

  Future<void> _fetchEstimation() async {
    setState(() => _state = _LoadState.loading);
    try {
      // TODO: sustituir por la llamada real a la Edge Function
      // `estimate-salary` (ver API_CONTRACT.md #24) cuando esté disponible.
      final result = await SalaryEstimation.fetchMock();
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
      appBar: AppBar(title: const Text('Estimación salarial')),
      body: SafeArea(child: _buildBody()),
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
          CircularProgressIndicator(strokeWidth: 2),
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
            const Icon(Icons.error_outline, color: AppColors.colorError, size: 32),
            const SizedBox(height: AppSpacing.space16),
            const Text(
              'No pudimos calcular tu estimación. Intenta de nuevo.',
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
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.space28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'VALOR CENTRAL ESTIMADO · ${result.currency}',
                style: AppTextStyles.sectionLabel,
              ),
              const SizedBox(height: AppSpacing.space12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('\$', style: AppTextStyles.currencySymbol),
                  Flexible(
                    child: Text(
                      '${_formatThousands(result.estimatedMinSalary)} – '
                      '${_formatThousands(result.estimatedMaxSalary)}',
                      style: AppTextStyles.salary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.space8),
              Text(
                'Nivel profesional detectado: ${result.professionalLevel}',
                style: AppTextStyles.compactBody,
              ),
              const SizedBox(height: AppSpacing.space20),
              Text(result.summary, style: AppTextStyles.body),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.space32),
        SectionLabel('Factores influyentes'),
        const SizedBox(height: AppSpacing.space16),
        Wrap(
          spacing: AppSpacing.space8,
          runSpacing: AppSpacing.space8,
          children: [
            for (final factor in result.influentialFactors) SkillChip(factor),
          ],
        ),
        const SizedBox(height: AppSpacing.space24),
        Text(
          'Este resultado es orientativo, no definitivo.',
          style: AppTextStyles.hint,
        ),
      ],
    );
  }

  String _formatThousands(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final remaining = digits.length - i;
      buffer.write(digits[i]);
      if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
    }
    return buffer.toString();
  }
}