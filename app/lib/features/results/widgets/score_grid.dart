import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../models/salary_estimation.dart';

/// Grid 2x2 de métricas con alineación y espaciados simétricos
class ScoreGrid extends StatelessWidget {
  const ScoreGrid({super.key, required this.result});

  final SalaryEstimation result;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ScoreItem(
              label: 'NIVEL DETECTADO',
              value: result.professionalLevel,
              valueColor: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.space12),
          Expanded(
            child: ScoreItem(
              label: 'POTENCIAL MÁXIMO',
              value: '\$${Formatters.formatCompact(result.estimatedMaxSalary)}',
              valueColor: AppColors.green,
            ),
          ),
        ],
      ),
    );
  }
}

class ScoreItem extends StatelessWidget {
  const ScoreItem({
    super.key,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space16,
        vertical: AppSpacing.space16,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgInput,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          const SizedBox(height: AppSpacing.space12),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
