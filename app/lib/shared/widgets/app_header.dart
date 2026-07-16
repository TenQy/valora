import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Título grande + subtítulo opcional, usado como encabezado de
/// contenido dentro del body (no confundir con [ValoraAppBar], que
/// es la barra de navegación fija).
///
/// Reutilizable en cualquier pantalla que necesite este patrón de
/// "hero title": Auth, Results, ProjectValue, etc.
class AppHeader extends StatelessWidget {
  const AppHeader({
    required this.title,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.dmSans(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            height: 1.15,
            letterSpacing: -0.8,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.space8),
          Text(
            subtitle!,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: AppColors.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}