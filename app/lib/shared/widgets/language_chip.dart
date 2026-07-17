import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Chip de idioma con bandera (emoji) y nivel, ej. "🇺🇸 English · B2".
/// Variante de SkillChip con borde borderStrong para distinguirse.
/// Ver UI_GUIDELINES.md §6.5 y §7.5.
class LanguageChip extends StatelessWidget {
  const LanguageChip({
    super.key,
    required this.flagEmoji,
    required this.language,
    required this.level,
  });

  final String flagEmoji;
  final String language;
  final String level;

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
        border: Border.all(color: AppColors.borderStrong),
      ),
      child: Text(
        '$flagEmoji $language · $level',
        style: AppTextStyles.skill,
      ),
    );
  }
}