import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/animated_app_background.dart';
import '../../../shared/widgets/section_label.dart';
import '../../../shared/widgets/skill_chip.dart';
import '../../../shared/widgets/valora_app_bar.dart';
import 'models/salary_estimation.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchEstimation();
  }

  Future<void> _fetchEstimation() async {
    setState(() => _state = _LoadState.loading);
    try {
      final result = await SalaryEstimation.fetchFromEdgeFunction();
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
        // 1. Card Principal Salarial (§7.7 UI_GUIDELINES.md)
        _SalaryCard(result: result),

        const SizedBox(height: AppSpacing.space24),

        // 2. Grid 2x2 de métricas (Mismo alto con IntrinsicHeight) (§6.7 / §7.7 UI_GUIDELINES.md)
        _ScoreGrid(result: result),

        const SizedBox(height: AppSpacing.space32),

        // 3. Destacados que más suman a tu valor (2 a 4 factores principales)
        if (result.topHighlights.isNotEmpty) ...[
          SectionLabel('FACTORES QUE MÁS AÑADEN VALOR'),
          const SizedBox(height: AppSpacing.space16),
          _TopHighlightsSection(highlights: result.topHighlights),
          const SizedBox(height: AppSpacing.space32),
        ],

        // 4. Tabla de barras hacia abajo con % de impacto de cada categoría
        if (result.factorBreakdown.isNotEmpty) ...[
          SectionLabel('DESGLOSE DE IMPACTO EN TU VALOR'),
          const SizedBox(height: AppSpacing.space16),
          _FactorBreakdownSection(breakdown: result.factorBreakdown),
          const SizedBox(height: AppSpacing.space32),
        ],

        // 5. Todos los factores evaluados
        SectionLabel('COMPETENCIAS Y FACTORES EVALUADOS'),
        const SizedBox(height: AppSpacing.space16),

        if (result.influentialFactors.isEmpty)
          const Text(
            'Agrega competencias o idiomas a tu perfil para incrementar tu estimación.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          )
        else
          Wrap(
            spacing: AppSpacing.space8,
            runSpacing: AppSpacing.space8,
            children: [
              for (final factor in result.influentialFactors) SkillChip(factor),
            ],
          ),

        const SizedBox(height: AppSpacing.space32),

        // Nota orientativa estilizada
        const _DisclaimerCard(),

        const SizedBox(height: AppSpacing.space24),
      ],
    );
  }
}

/// Card Salarial principal con gradiente verde en la esquina superior derecha (§6.3, §7.7)
class _SalaryCard extends StatelessWidget {
  const _SalaryCard({required this.result});

  final SalaryEstimation result;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    'VALOR CENTRAL ESTIMADO · ${result.currency}',
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
                          '${_formatThousands(result.estimatedMinSalary)} – ${_formatThousands(result.estimatedMaxSalary)}',
                          style: AppTextStyles.salary.copyWith(fontSize: 34),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.space8),

                  Text(
                    'Nivel profesional: ${result.professionalLevel}',
                    style: AppTextStyles.subtitle,
                  ),
                  const SizedBox(height: AppSpacing.space24),

                  _SalaryRangeBar(
                    minSalary: result.estimatedMinSalary,
                    maxSalary: result.estimatedMaxSalary,
                  ),
                  const SizedBox(height: AppSpacing.space20),

                  Text(
                    result.summary,
                    style: AppTextStyles.body,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

class _SalaryRangeBar extends StatelessWidget {
  const _SalaryRangeBar({
    required this.minSalary,
    required this.maxSalary,
  });

  final int minSalary;
  final int maxSalary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderDefault,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.greenDim,
                    AppColors.green,
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x594ADE80),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.space8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'MÍN: \$${_formatCompact(minSalary)}',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                color: AppColors.textMuted,
              ),
            ),
            Text(
              'MÁX: \$${_formatCompact(maxSalary)}',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatCompact(int val) {
    if (val >= 1000) {
      final k = (val / 1000).toStringAsFixed(1).replaceAll('.0', '');
      return '${k}k';
    }
    return val.toString();
  }
}

/// Grid de métricas con IntrinsicHeight para asegurar mismo alto en ambas cards
class _ScoreGrid extends StatelessWidget {
  const _ScoreGrid({required this.result});

  final SalaryEstimation result;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _ScoreItem(
              label: 'NIVEL DETECTADO',
              value: result.professionalLevel,
              valueColor: AppColors.textPrimary,
              subtitle: 'Basado en tu perfil',
            ),
          ),
          const SizedBox(width: AppSpacing.space12),
          Expanded(
            child: _ScoreItem(
              label: 'POTENCIAL MÁXIMO',
              value: '\$${_formatCompact(result.estimatedMaxSalary)}',
              valueColor: AppColors.green,
              subtitle: 'Rango superior',
            ),
          ),
        ],
      ),
    );
  }

  String _formatCompact(int val) {
    if (val >= 1000) {
      final k = (val / 1000).toStringAsFixed(1).replaceAll('.0', '');
      return '${k}k';
    }
    return val.toString();
  }
}

class _ScoreItem extends StatelessWidget {
  const _ScoreItem({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.subtitle,
  });

  final String label;
  final String value;
  final Color valueColor;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space16),
      decoration: BoxDecoration(
        color: AppColors.bgInput,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: AppSpacing.space8),
          Text(
            value,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 24,
              fontWeight: FontWeight.w300,
              color: valueColor,
            ),
          ),
          const SizedBox(height: AppSpacing.space8),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w300,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// Sección con los 2 a 4 factores que más valor aportan (+ $X MXN)
class _TopHighlightsSection extends StatelessWidget {
  const _TopHighlightsSection({required this.highlights});

  final List<HighlightItem> highlights;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in highlights) ...[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space16,
              vertical: AppSpacing.space12,
            ),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.trending_up,
                  color: AppColors.green,
                  size: 18,
                ),
                const SizedBox(width: AppSpacing.space12),
                Expanded(
                  child: Text(
                    item.label,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space8,
                    vertical: AppSpacing.space4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.greenDim,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.greenBorder),
                  ),
                  child: Text(
                    item.boost,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.space8),
        ],
      ],
    );
  }
}

/// Desglose de impacto en barras verticales descendentes (% de aporte) (§6.7 UI_GUIDELINES.md)
class _FactorBreakdownSection extends StatelessWidget {
  const _FactorBreakdownSection({required this.breakdown});

  final List<BreakdownItem> breakdown;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space20),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        children: [
          for (final item in breakdown) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.category,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${item.percentage}%',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.silverMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space8),
                // Barra con gradiente plata según §6.7 (skills/desglose neutro)
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: item.percentage / 100,
                    minHeight: 6,
                    backgroundColor: AppColors.borderSubtle,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.silverMuted,
                    ),
                  ),
                ),
              ],
            ),
            if (item != breakdown.last)
              const SizedBox(height: AppSpacing.space16),
          ],
        ],
      ),
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
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
              'Este resultado es orientativo, calculado mediante el análisis de tu perfil, competencias e idiomas registrados en el mercado laboral.',
              style: AppTextStyles.hint,
            ),
          ),
        ],
      ),
    );
  }
}