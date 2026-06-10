import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class LanguageChip extends StatelessWidget {
  const LanguageChip({
    required this.language,
    required this.level,
    required this.flag,
    super.key,
  });

  final String language;
  final String level;
  final String flag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space12,
        vertical: AppSpacing.space8,
      ),
      decoration: BoxDecoration(
        color: AppColors.silverSubtle,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.borderStrong),
      ),
      child: Text(
        '$flag $language - $level',
        style: AppTextStyles.compactBody.copyWith(color: AppColors.silverMuted),
      ),
    );
  }
}
