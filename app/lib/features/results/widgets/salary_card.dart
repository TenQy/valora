import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../models/salary_estimation.dart';

/// Card Salarial principal con gradiente verde en la esquina superior derecha
class SalaryCard extends StatelessWidget {
  const SalaryCard({super.key, required this.result});

  final SalaryEstimation result;

  @override
  Widget build(BuildContext context) {
    final isSkeleton = Skeletonizer.of(context).enabled;
    
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
                    'VALOR CENTRAL ESTIMADO MENSUAL · ${result.currency} / MES',
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
                          '${Formatters.formatThousands(result.estimatedMinSalary)} – ${Formatters.formatThousands(result.estimatedMaxSalary)}',
                          style: AppTextStyles.salary,
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
                  SalaryRangeBar(
                    minSalary: result.estimatedMinSalary,
                    maxSalary: result.estimatedMaxSalary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalaryRangeBar extends StatelessWidget {
  const SalaryRangeBar({
    super.key,
    required this.minSalary,
    required this.maxSalary,
  });

  final int minSalary;
  final int maxSalary;

  @override
  Widget build(BuildContext context) {
    final isSkeleton = Skeletonizer.of(context).enabled;
    
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
                gradient: isSkeleton
                    ? null
                    : const LinearGradient(
                        colors: [
                          AppColors.greenDim,
                          AppColors.green,
                        ],
                      ),
                color: isSkeleton ? AppColors.borderDefault : null,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: isSkeleton ? AppColors.silver : AppColors.green,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.bgSurface, width: 2),
                boxShadow: isSkeleton
                    ? null
                    : const [
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
              'MÍN: \$${Formatters.formatCompact(minSalary)}',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                color: AppColors.textMuted,
              ),
            ),
            Text(
              'MÁX: \$${Formatters.formatCompact(maxSalary)}',
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
}
