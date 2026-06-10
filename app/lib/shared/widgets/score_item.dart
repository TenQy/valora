import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import 'section_label.dart';

class ScoreItem extends StatelessWidget {
  const ScoreItem({
    required this.label,
    required this.value,
    required this.caption,
    super.key,
    this.isMonetary = false,
  });

  final String label;
  final String value;
  final String caption;
  final bool isMonetary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space16),
      decoration: BoxDecoration(
        color: AppColors.bgInput,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(label),
          const SizedBox(height: AppSpacing.space8),
          Text(
            value,
            style: AppTextStyles.score.copyWith(
              color: isMonetary ? AppColors.green : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          Text(caption, style: AppTextStyles.hint),
        ],
      ),
    );
  }
}
