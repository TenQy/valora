import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Barra de navegación fija de la app.
///
/// Uso "home": solo logo (`showBackButton: false`, sin `title`).
/// Uso en pantallas internas: back button + título corto opcional + actions.
class ValoraAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ValoraAppBar({
    this.actions,
    this.logoHeight = 72,
    this.showBackButton = false,
    this.title,
    super.key,
  });

  static const double barHeight = 72;

  final List<Widget>? actions;
  final double logoHeight;

  /// Si es true, muestra flecha de regreso en vez del logo.
  final bool showBackButton;

  /// Título corto mostrado junto al back button. Se ignora si
  /// [showBackButton] es false (en ese caso se muestra el logo).
  final String? title;

  @override
  Size get preferredSize => const Size.fromHeight(barHeight);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.bgBase.withValues(alpha: 0.2),
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
                    if (showBackButton) ...[
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (title != null) ...[
                        const SizedBox(width: AppSpacing.space4),
                        Text(
                          title!,
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ] else
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