import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppSpacing.space24),
    this.radius = AppRadius.lg,
    this.showShadow = true,
    this.backgroundColor = AppColors.bgSurface,
    this.borderColor = AppColors.borderDefault,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bool showShadow;
  final Color backgroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor),
        boxShadow: showShadow
            ? const [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 60,
                  offset: Offset(0, 20),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
