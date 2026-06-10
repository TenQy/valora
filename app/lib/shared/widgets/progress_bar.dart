import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

enum ProgressBarVariant { silver, green }

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    required this.value,
    super.key,
    this.variant = ProgressBarVariant.silver,
    this.height = 4,
  });

  final double value;
  final ProgressBarVariant variant;
  final double height;

  @override
  Widget build(BuildContext context) {
    final safeValue = value.clamp(0, 1).toDouble();
    final colors = variant == ProgressBarVariant.green
        ? const [AppColors.greenDim, AppColors.green]
        : const [AppColors.silverSubtle, AppColors.silverMuted];

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xs),
      child: Container(
        height: height,
        color: AppColors.borderSubtle,
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: safeValue,
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
          ),
        ),
      ),
    );
  }
}
