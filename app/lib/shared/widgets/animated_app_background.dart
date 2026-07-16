import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

/// Fondo animado con glows, círculos y puntos decorativos.
///
/// Envuelve el `body` de cualquier `Scaffold` para reutilizar el mismo
/// fondo animado de [WelcomeScreen] en otras pantallas. El [child] se
/// dibuja encima del fondo dentro de un [Stack].
///
/// Uso:
/// ```dart
/// Scaffold(
///   backgroundColor: AppColors.bgBase,
///   body: AnimatedAppBackground(
///     child: SafeArea(child: ...),
///   ),
/// )
/// ```
class AnimatedAppBackground extends StatefulWidget {
  const AnimatedAppBackground({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<AnimatedAppBackground> createState() => _AnimatedAppBackgroundState();
}

class _AnimatedAppBackgroundState extends State<AnimatedAppBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bgCtrl;

  @override
  void initState() {
    super.initState();
    // Loop infinito lento (8s por ciclo)
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _bgCtrl,
            builder: (context, _) => CustomPaint(
              painter: _BackgroundPainter(progress: _bgCtrl.value),
            ),
          ),
        ),
        widget.child,
      ],
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