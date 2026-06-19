import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _fadeController.forward();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Mínimo 1.5s de splash aunque la sesión cargue antes
    await Future.wait([
      Future.delayed(const Duration(milliseconds: 1500)),
      _resolveSession(),
    ]);
  }

  Future<void> _resolveSession() async {
    final session = Supabase.instance.client.auth.currentSession;

    if (!mounted) return;

    if (session != null) {
      // Usuario con sesión activa → Dashboard
      Navigator.of(context).pushReplacementNamed('/dashboard');
    } else {
      // Sin sesión → Bienvenida
      Navigator.of(context).pushReplacementNamed('/welcome');
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Logo ──────────────────────────────────────────────
              _ValoraLogo(),

              const SizedBox(height: 48),

              // ── Indicador de carga ────────────────────────────────
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: AppColors.silverMuted,
                  strokeWidth: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Logo de Valora: dot verde + nombre en Cormorant Garamond.
class _ValoraLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Dot verde semántico
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: AppColors.green,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 8),

        // Nombre de la app
        const Text(
          'Valora',
          style: TextStyle(
            fontFamily: AppFonts.display,
            fontSize: 32,
            fontWeight: FontWeight.w300,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
