import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

import '../auth/auth_screen.dart';
import '../auth/auth_service.dart';
import '../dashboard/dashboard_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  // ── Fondo animado ─────────────────────────────────────────
  late final AnimationController _bgCtrl;

  // ── Contenido ─────────────────────────────────────────────
  late final AnimationController _titleCtrl;
  late final Animation<double> _titleOpacity;
  late final Animation<double> _titleSlide;

  late final AnimationController _taglineCtrl;
  late final Animation<double> _taglineOpacity;
  late final Animation<double> _taglineSlide;

  late final AnimationController _buttonsCtrl;
  late final Animation<double> _buttonsOpacity;
  late final Animation<double> _buttonsSlide;

  @override
  void initState() {
    super.initState();

    // Fondo: loop infinito lento (8s por ciclo)
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

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
    _bgCtrl.dispose();
    _titleCtrl.dispose();
    _taglineCtrl.dispose();
    _buttonsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double logoSize = 48.0;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Stack(
        children: [
          // ── Fondo animado ──────────────────────────────────
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgCtrl,
              builder: (context, _) => CustomPaint(
                painter: _BackgroundPainter(progress: _bgCtrl.value),
              ),
            ),
          ),

          // ── Contenido ──────────────────────────────────────
          SafeArea(
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

                  // ── 2. Eslogan ───────────────────────────
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

                  // ── 3. Botones ───────────────────────────
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
                      padding: const EdgeInsets.only(
                        bottom: AppSpacing.space32,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                                );
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
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () async {
                                try {
                                  await AuthService(Supabase.instance.client).signInWithGoogle();
                                  if (context.mounted) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (_) => const DashboardScreen()),
                                      (route) => false,
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error al iniciar sesión: $e')),
                                    );
                                  }
                                }
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
        ],
      ),
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final double progress; // 0.0 → 1.0 loop

  const _BackgroundPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final double t = progress;
    final double sin1 = math.sin(t * math.pi * 2);
    final double cos1 = math.cos(t * math.pi * 2);
    final double sin2 = math.sin(t * math.pi * 2 + 1.2);

    // ── Glow verde animado (esquina superior derecha) ────────
    final double greenX = size.width * (0.78 + 0.08 * sin1);
    final double greenY = size.height * (0.10 + 0.05 * cos1);
    canvas.drawCircle(
      Offset(greenX, greenY),
      size.width * 0.6,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF4ADE80).withOpacity(0.09),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(
            center: Offset(greenX, greenY),
            radius: size.width * 0.6,
          ),
        ),
    );

    // ── Glow plateado animado (esquina inferior izquierda) ───
    final double grayX = size.width * (0.18 + 0.06 * sin2);
    final double grayY = size.height * (0.85 + 0.04 * cos1);
    canvas.drawCircle(
      Offset(grayX, grayY),
      size.width * 0.55,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF9A9A9A).withOpacity(0.07),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(
            center: Offset(grayX, grayY),
            radius: size.width * 0.55,
          ),
        ),
    );

    // ── Glow blanco sutil en centro ──────────────────────────
    final double whiteY = size.height * (0.48 + 0.03 * sin1);
    canvas.drawCircle(
      Offset(size.width * 0.5, whiteY),
      size.width * 0.45,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFE8E8E8).withOpacity(0.03),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(
            center: Offset(size.width * 0.5, whiteY),
            radius: size.width * 0.45,
          ),
        ),
    );

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    // ── Círculo grande derecha — rota lentamente ─────────────
    final double r1 = size.width * 0.38;
    final double c1x = size.width * (0.88 + 0.03 * sin1);
    final double c1y = size.height * (0.35 + 0.03 * cos1);
    strokePaint.color = const Color(0xFF2A2A2A);
    canvas.drawCircle(Offset(c1x, c1y), r1, strokePaint);

    // ── Círculo mediano izquierda ─────────────────────────────
    final double r2 = size.width * 0.24;
    final double c2x = size.width * (0.10 + 0.03 * cos1);
    final double c2y = size.height * (0.65 + 0.03 * sin2);
    strokePaint.color = const Color(0xFF222222);
    canvas.drawCircle(Offset(c2x, c2y), r2, strokePaint);

    // ── Círculo pequeño verde outline (arriba centro) ────────
    final double r3 = size.width * 0.12;
    final double c3x = size.width * (0.62 + 0.04 * cos1);
    final double c3y = size.height * (0.08 + 0.03 * sin1);
    strokePaint
      ..color = const Color(0xFF4ADE80).withOpacity(0.12)
      ..strokeWidth = 0.8;
    canvas.drawCircle(Offset(c3x, c3y), r3, strokePaint);

    // ── Líneas diagonales ────────────────────────────────────
    final linePaint = Paint()
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Superior izquierda
    linePaint.color = const Color(0xFF242424);
    canvas.drawLine(
      Offset(0, size.height * 0.25),
      Offset(size.width * 0.42, 0),
      linePaint,
    );

    // Inferior derecha
    canvas.drawLine(
      Offset(size.width, size.height * 0.75),
      Offset(size.width * 0.58, size.height),
      linePaint,
    );

    // ── Líneas horizontales cortas ────────────────────────────
    linePaint.color = const Color(0xFF1E1E1E);
    canvas.drawLine(
      Offset(AppSpacing.space24, size.height * 0.70),
      Offset(size.width * 0.32, size.height * 0.70),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.68, size.height * 0.30),
      Offset(size.width - AppSpacing.space24, size.height * 0.30),
      linePaint,
    );

    // ── Grid de puntos grises (esquina inferior derecha) ─────
    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF2A2A2A);
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        canvas.drawCircle(
          Offset(
            size.width * 0.72 + col * 14.0,
            size.height * 0.78 + row * 14.0,
          ),
          1.5,
          dotPaint,
        );
      }
    }

    // ── Grid de puntos grises (esquina superior izquierda) ───
    dotPaint.color = const Color(0xFF222222);
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        canvas.drawCircle(
          Offset(
            size.width * 0.06 + col * 14.0,
            size.height * 0.08 + row * 14.0,
          ),
          1.5,
          dotPaint,
        );
      }
    }

    // ── Punto verde semántico animado ─────────────────────────
    final double dotGreenOpacity = 0.25 + 0.2 * sin1;
    canvas.drawCircle(
      Offset(size.width * 0.80, size.height * 0.13),
      3.5,
      Paint()
        ..color = const Color(0xFF4ADE80).withOpacity(dotGreenOpacity)
        ..style = PaintingStyle.fill,
    );

    // ── Punto plateado animado ────────────────────────────────
    final double dotSilverOpacity = 0.15 + 0.12 * cos1;
    canvas.drawCircle(
      Offset(size.width * 0.20, size.height * 0.87),
      3,
      Paint()
        ..color = const Color(0xFFE8E8E8).withOpacity(dotSilverOpacity)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter old) =>
      old.progress != progress;
}