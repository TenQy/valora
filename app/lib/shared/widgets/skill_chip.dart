import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class SkillChip extends StatelessWidget {
  const SkillChip({required this.label, super.key, this.onDeleted});

  final String label;
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.space12,
        right: onDeleted == null ? AppSpacing.space12 : AppSpacing.space8,
        top: AppSpacing.space8,
        bottom: AppSpacing.space8,
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
          if (onDeleted != null) ...[
            const SizedBox(width: AppSpacing.space8),
            GestureDetector(
              onTap: onDeleted,
              child: const Icon(
                Icons.close,
                size: 14,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
