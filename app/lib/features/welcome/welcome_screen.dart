import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/animated_app_background.dart';
import '../../shared/widgets/fade_slide_in.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/secondary_button.dart';

import '../auth/auth_screen.dart';
import '../auth/auth_service.dart';
import '../dashboard/dashboard_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isGoogleLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isGoogleLoading = true);

    try {
      await AuthService(Supabase.instance.client).signInWithGoogle();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
          (route) => false,
        );
      }
    } on GoogleSignInCancelledException {
      // Cancelación del usuario: no mostramos snackbar.
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al iniciar sesión: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const double logoSize = 48.0;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: AnimatedAppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space24,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // ── 1. Logo + Título ─────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'valora-logo',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/logos/app_icon.png',
                          width: logoSize,
                          height: logoSize,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.space12),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 700),
                      offset: const Offset(12, 0),
                      child: Text(
                        'Valora',
                        style: GoogleFonts.dmSans(
                          fontSize: 42,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.1,
                          letterSpacing: -1.5,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.space24),

                // ── 2. Eslogan ───────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 1200),
                  child: Column(
                    children: [
                      Text(
                        'Conoce tu valor en el mercado laboral.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textSecondary,
                          height: 1.4,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space8),
                      Text(
                        'Estima tu salario, descubre puestos\ncompatibles y valora tus proyectos.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: AppColors.textMuted,
                          height: 1.65,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 2),

                // ── 3. Botones ───────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 1700),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppSpacing.space32,
                    ),
                    child: Column(
                      children: [
                        PrimaryButton(
                          label: 'Iniciar sesión',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const AuthScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.space12),
                        SecondaryButton(
                          label: 'Iniciar sesión con Google',
                          isLoading: _isGoogleLoading,
                          onPressed: _signInWithGoogle,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}