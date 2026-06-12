import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class ValoraAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ValoraAppBar({
    this.actions,
    this.logoHeight = 72,
    super.key,
  });

  static const double barHeight = 72;

  final List<Widget>? actions;
  final double logoHeight;

  @override
  Size get preferredSize => const Size.fromHeight(barHeight);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.bgBase.withValues(alpha: 0.68),
            border: const Border(
              bottom: BorderSide(color: AppColors.borderSubtle),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: barHeight,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.space20,
                  right: AppSpacing.space8,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/logos/appBar_logo.png',
                      height: logoHeight,
                      fit: BoxFit.contain,
                    ),
                    const Spacer(),
                    if (actions != null)
                      IconTheme.merge(
                        data: const IconThemeData(
                          color: AppColors.silverMuted,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: actions!,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
