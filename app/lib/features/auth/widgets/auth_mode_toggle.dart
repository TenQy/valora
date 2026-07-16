import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Texto interactivo "¿No tienes cuenta? Regístrate" / viceversa.
///
/// Específico del flujo de auth: alterna entre modo login y registro.
class AuthModeToggle extends StatelessWidget {
  const AuthModeToggle({
    required this.isLogin,
    required this.onToggle,
    super.key,
  });

  final bool isLogin;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.space24),
        child: RichText(
          text: TextSpan(
            text: isLogin ? '¿No tienes cuenta? ' : '¿Ya tienes cuenta? ',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: AppColors.textMuted,
            ),
            children: [
              TextSpan(
                text: isLogin ? 'Regístrate' : 'Inicia sesión',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.silver,
                ),
                recognizer: TapGestureRecognizer()..onTap = onToggle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}