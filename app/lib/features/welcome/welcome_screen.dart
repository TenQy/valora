import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  // Controlador del título (aparece junto al Hero al terminar)
  late final AnimationController _titleCtrl;
  late final Animation<double> _titleOpacity;
  late final Animation<double> _titleSlide;

  // Controlador del eslogan
  late final AnimationController _taglineCtrl;
  late final Animation<double> _taglineOpacity;
  late final Animation<double> _taglineSlide;

  // Controlador de botones
  late final AnimationController _buttonsCtrl;
  late final Animation<double> _buttonsOpacity;
  late final Animation<double> _buttonsSlide;

  @override
  void initState() {
    super.initState();

    // ── Título ───────────────────────────────────────────────
    _titleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _titleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _titleCtrl, curve: Curves.easeOut),
    );
    _titleSlide = Tween<double>(begin: 12, end: 0).animate(
      CurvedAnimation(parent: _titleCtrl, curve: Curves.easeOut),
    );

    // ── Eslogan ──────────────────────────────────────────────
    _taglineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _taglineOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _taglineCtrl, curve: Curves.easeOut),
    );
    _taglineSlide = Tween<double>(begin: 12, end: 0).animate(
      CurvedAnimation(parent: _taglineCtrl, curve: Curves.easeOut),
    );

    // ── Botones ──────────────────────────────────────────────
    _buttonsCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _buttonsOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _buttonsCtrl, curve: Curves.easeOut),
    );
    _buttonsSlide = Tween<double>(begin: 12, end: 0).animate(
      CurvedAnimation(parent: _buttonsCtrl, curve: Curves.easeOut),
    );

    // Secuencia: Hero tarda ~700ms en llegar
    // 1. Logo llega + título aparece: 700ms
    // 2. Eslogan: 700 + 500 = 1200ms
    // 3. Botones: 1200 + 500 = 1700ms
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) _titleCtrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _taglineCtrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 1700), () {
      if (mounted) _buttonsCtrl.forward();
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _taglineCtrl.dispose();
    _buttonsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Logo pequeño al lado del título
    const double logoSize = 48.0;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // ── 1. Logo + Título ───────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Hero — el logo encoge desde la splash hasta aquí
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

                  // Título aparece junto al logo
                  AnimatedBuilder(
                    animation: _titleCtrl,
                    builder: (context, child) => Opacity(
                      opacity: _titleOpacity.value,
                      child: Transform.translate(
                        offset: Offset(_titleSlide.value, 0),
                        child: child,
                      ),
                    ),
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

              // ── 2. Eslogan ─────────────────────────────────────
              AnimatedBuilder(
                animation: _taglineCtrl,
                builder: (context, child) => Opacity(
                  opacity: _taglineOpacity.value,
                  child: Transform.translate(
                    offset: Offset(0, _taglineSlide.value),
                    child: child,
                  ),
                ),
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

              // ── 3. Botones ─────────────────────────────────────
              AnimatedBuilder(
                animation: _buttonsCtrl,
                builder: (context, child) => Opacity(
                  opacity: _buttonsOpacity.value,
                  child: Transform.translate(
                    offset: Offset(0, _buttonsSlide.value),
                    child: child,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.space32),
                  child: Column(
                    children: [
                      // Iniciar sesión
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: navegar a login
                          },
                          child: Text(
                            'Iniciar sesión',
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.space12),

                      // Iniciar sesión con Google
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: login con Google
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textSecondary,
                            side: const BorderSide(
                              color: AppColors.borderDefault,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.space24,
                              vertical: AppSpacing.space16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.xs),
                            ),
                          ),
                          child: Text(
                            'Iniciar sesión con Google',
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}