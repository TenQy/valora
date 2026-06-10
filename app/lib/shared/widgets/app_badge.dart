import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

enum AppBadgeVariant { silver, green, warning }

class AppBadge extends StatelessWidget {
  const AppBadge({
    required this.label,
    super.key,
    this.variant = AppBadgeVariant.silver,
  });

  final String label;
  final AppBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = switch (variant) {
      AppBadgeVariant.green => _BadgeColors(
        background: AppColors.greenDim,
        border: AppColors.greenBorder,
        foreground: AppColors.green,
      ),
      AppBadgeVariant.warning => _BadgeColors(
        background: AppColors.bgElevated,
        border: AppColors.colorWarning,
        foreground: AppColors.colorWarning,
      ),
      AppBadgeVariant.silver => _BadgeColors(
        background: AppColors.silverSubtle,
        border: AppColors.borderDefault,
        foreground: AppColors.silverMuted,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space12,
        vertical: AppSpacing.space4,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(
          variant == AppBadgeVariant.silver ? AppRadius.xl : AppRadius.xs,
        ),
        border: Border.all(color: colors.border),
      ),
      child: Text(
        label,
        style: AppTextStyles.match.copyWith(color: colors.foreground),
      ),
    );
  }
}

class _BadgeColors {
  const _BadgeColors({
    required this.background,
    required this.border,
    required this.foreground,
  });

  final Color background;
  final Color border;
  final Color foreground;
}
