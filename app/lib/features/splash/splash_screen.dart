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
  late final AnimationController _controller;

  // Fade del logo
  late final Animation<double> _logoOpacity;
  // Scale del logo
  late final Animation<double> _logoScale;
  // Fade del indicador de carga (aparece después del logo)
  late final Animation<double> _loaderOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Logo: fade-in de 0 → 1 en los primeros ~800ms
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    // Logo: scale de 0.88 → 1.0 (sutil, no exagerado)
    _logoScale = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
      ),
    );

    // Loader: fade-in después del logo, entre ~800ms y ~1200ms
    _loaderOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.65, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
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
      Navigator.of(context).pushReplacementNamed('/dashboard');
    } else {
      Navigator.of(context).pushReplacementNamed('/welcome');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Logo ──────────────────────────────────────────────
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _logoOpacity.value,
                  child: Transform.scale(scale: _logoScale.value, child: child),
                );
              },
              child: const Text(
                'Valora',
                style: TextStyle(
                  fontFamily: AppFonts.display,
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 48),

            // ── Indicador de carga ────────────────────────────────
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(opacity: _loaderOpacity.value, child: child);
              },
              child: const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: AppColors.silverMuted,
                  strokeWidth: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
