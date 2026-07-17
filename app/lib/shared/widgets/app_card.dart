import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Card base reutilizable. Nunca usar el widget `Card` nativo de Flutter
/// directamente (ver UI_GUIDELINES.md §8.4) — usamos Container con
/// BoxDecoration para tener control total sobre color, radio y borde.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.space20),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderDefault),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 60,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return card;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Material(
        color: Colors.transparent,
        child: InkWell(onTap: onTap, child: card),
      ),
    );
  }
}