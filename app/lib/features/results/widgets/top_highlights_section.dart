import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../models/salary_estimation.dart';

/// Sección con los 2 a 4 factores destacados con íconos en gris apagado
class TopHighlightsSection extends StatelessWidget {
  const TopHighlightsSection({super.key, required this.highlights});

  final List<HighlightItem> highlights;

  @override
  Widget build(BuildContext context) {
    final isSkeleton = Skeletonizer.of(context).enabled;

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
                  color: AppColors.silverMuted, // Ícono gris más apagado
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
                    color: isSkeleton ? AppColors.borderDefault : AppColors.greenDim,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: isSkeleton ? AppColors.borderDefault : AppColors.greenBorder),
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
