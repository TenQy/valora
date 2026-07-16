import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Separador "o" entre el formulario y el login alternativo (Google).
///
/// Específico del flujo de auth, no se reutiliza en otras pantallas.
class AuthOrDivider extends StatelessWidget {
  const AuthOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.borderDefault)),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space12,
          ),
          child: Text(
            'o',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.borderDefault)),
      ],
    );
  }
}