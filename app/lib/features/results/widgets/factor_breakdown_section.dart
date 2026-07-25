import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../models/salary_estimation.dart';

/// Desglose de impacto con barra de progreso estilizada en gradiente verde y % en gris
class FactorBreakdownSection extends StatelessWidget {
  const FactorBreakdownSection({super.key, required this.breakdown});

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
                        fontWeight: FontWeight.w400,
                        color: AppColors.silverMuted, // Texto del % en gris
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space8),
                // Barra estilizada con gradiente greenDim -> green y sutil resplandor
                Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.borderSubtle,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (item.percentage / 100).clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.greenDim,
                            AppColors.green,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x334ADE80),
                            blurRadius: 6,
                          ),
                        ],
                      ),
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
