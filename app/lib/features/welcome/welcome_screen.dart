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
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _topOpacity;
  late final Animation<double> _topSlide;
  late final Animation<double> _bottomOpacity;
  late final Animation<double> _bottomSlide;

  @override
  void initState() {
    super.initState();

    // El texto y botones aparecen DESPUÉS de que el Hero termina (~700ms)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _topOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );
    _topSlide = Tween<double>(begin: -14, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );
    _bottomOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );
    _bottomSlide = Tween<double>(begin: 14, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    // Espera que el Hero termine antes de animar texto/botones
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Logo al 50% del alto
    final double logoSize = size.height * 0.50;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Stack(
        children: [
          // ── Hero logo — recibe la transición del splash ──────
          Positioned(
            left: AppSpacing.space20,
            right: AppSpacing.space20,
            top: (size.height - logoSize) / 2,
            height: logoSize,
            child: Hero(
              tag: 'valora-logo',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Image.asset(
                  'assets/logos/app_icon.png',
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),

          // ── Gradiente superior ───────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.50,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.bgBase,
                    AppColors.bgBase.withOpacity(0.80),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),

          // ── Gradiente inferior ───────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: size.height * 0.50,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.bgBase,
                    AppColors.bgBase.withOpacity(0.88),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // ── Contenido ────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Texto superior ──────────────────────────
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) => Opacity(
                      opacity: _topOpacity.value,
                      child: Transform.translate(
                        offset: Offset(0, _topSlide.value),
                        child: child,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.space32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Valora',
                            style: GoogleFonts.dmSans(
                              fontSize: 52,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              height: 1.1,
                              letterSpacing: -1.5,
                            ),
                          ),

                          const SizedBox(height: AppSpacing.space8),

                          Text(
                            'Conoce tu valor\nen el mercado laboral.',
                            style: GoogleFonts.dmSans(
                              fontSize: 22,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic,
                              color: AppColors.textSecondary,
                              height: 1.4,
                              letterSpacing: -0.3,
                            ),
                          ),

                          const SizedBox(height: AppSpacing.space12),

                          Text(
                            'Estima tu salario, descubre puestos\ncompatibles y valora tus proyectos.',
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
                  ),

                  const Spacer(),

                  // ── Botones inferiores ──────────────────────
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) => Opacity(
                      opacity: _bottomOpacity.value,
                      child: Transform.translate(
                        offset: Offset(0, _bottomSlide.value),
                        child: child,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppSpacing.space32,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: navegar a registro
                              },
                              child: Text(
                                'Crear cuenta',
                                style: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: AppSpacing.space12),

                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                // TODO: navegar a login
                              },
                              child: Text(
                                'Iniciar sesión',
                                style: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.silverMuted,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: AppSpacing.space12),

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
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.xs),
                                ),
                              ),
                              child: Text(
                                'Continuar con Google',
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
        ],
      ),
    );
  }
}