import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Chip para representar una competencia, herramienta o tecnología.
/// Ver UI_GUIDELINES.md §6.5.
class SkillChip extends StatelessWidget {
  const SkillChip(this.label, {super.key, this.onRemove});

  final String label;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space12,
        vertical: AppSpacing.space8 - 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.silverSubtle,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTextStyles.skill),
          if (onRemove != null) ...[
            const SizedBox(width: AppSpacing.space8),
            InkWell(
              onTap: onRemove,
              child: const Icon(
                Icons.close,
                size: 12,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}