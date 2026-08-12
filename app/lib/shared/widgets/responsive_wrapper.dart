import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Un wrapper premium que simula un dispositivo físico moderno (tipo Titanio)
/// con un fondo animado geométrico muy sutil para escritorio.
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth = 430.0,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    if (!isDesktop) {
      return child; 
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C10), // Fondo ligeramente más claro que el negro puro
      body: Stack(
        alignment: Alignment.center,
        children: [
          // =================================================================
          // 1. FONDO ANIMADO (Figuras Geométricas Sutiles)
          // =================================================================
          const Positioned.fill(
            child: _GeometricAnimatedBackground(),
          ),

          // =================================================================
          // 2. EL DISPOSITIVO FÍSICO (Simulador Premium Edge-to-Edge)
          // =================================================================
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20), // Margen para que respire
              child: FittedBox(
                fit: BoxFit.contain, // Escala el teléfono proporcionalmente para que quepa en la pantalla
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                // -- Botones Físicos (Volumen y Encendido) --
                Positioned(
                  left: -6,
                  top: 150,
                  child: Container(width: 6, height: 60, decoration: _buttonDeco()),
                ),
                Positioned(
                  left: -6,
                  top: 220,
                  child: Container(width: 6, height: 60, decoration: _buttonDeco()),
                ),
                Positioned(
                  right: -6,
                  top: 180,
                  child: Container(width: 6, height: 80, decoration: _buttonDeco()),
                ),

                // -- Chasis del Teléfono --
                Container(
                  width: maxWidth,
                  height: 860, // Altura física estática (proporción 1:2 de un celular real)
                  decoration: BoxDecoration(
                    color: AppColors.bgBase,
                    borderRadius: BorderRadius.circular(48), 
                    border: Border.all(
                      color: const Color(0xFF4A4A4C), // Titanio
                      width: 6, 
                    ),
                    boxShadow: [
                      // Sombra principal del dispositivo
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.8), 
                        blurRadius: 80, 
                        offset: const Offset(0, 40)
                      ),
                      // Destello verde (restaurado) para efecto de flotación
                      BoxShadow(
                        color: AppColors.green.withValues(alpha: 0.12), // Brillo restaurado y mejorado
                        blurRadius: 100, 
                        spreadRadius: 15
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // -- La Pantalla y la App --
                      ClipRRect(
                        borderRadius: BorderRadius.circular(42), 
                        child: Stack(
                          children: [
                            // 1. La aplicación real corriendo
                            child,
                            
                            // 2. Reflejo de Cristal (Glass Glare Overlay)
                            IgnorePointer(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    stops: const [0.0, 0.3, 0.3, 1.0],
                                    colors: [
                                      Colors.white.withValues(alpha: 0.03), // Reflejo más sutil
                                      Colors.white.withValues(alpha: 0.0),
                                      Colors.transparent,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // -- Cámara Frontal Sutil (Hole-Punch) --
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF050505), 
                            boxShadow: [
                              BoxShadow(color: Colors.white.withValues(alpha: 0.15), blurRadius: 1, spreadRadius: 0.5),
                            ],
                            border: Border.all(color: Colors.black, width: 1.5),
                          ),
                          child: Center(
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF1E143F),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buttonDeco() {
    return const BoxDecoration(
      color: Color(0xFF222222),
      borderRadius: BorderRadius.horizontal(
        left: Radius.circular(4),
        right: Radius.circular(4),
      ),
    );
  }
}

// =========================================================================
// WIDGET Y PAINTER PARA EL FONDO ANIMADO
// =========================================================================
class _GeometricAnimatedBackground extends StatefulWidget {
  const _GeometricAnimatedBackground();

  @override
  State<_GeometricAnimatedBackground> createState() => _GeometricAnimatedBackgroundState();
}

class _GeometricAnimatedBackgroundState extends State<_GeometricAnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Animación lenta (ciclo de 20 segundos)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _GeometricPainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _GeometricPainter extends CustomPainter {
  final double animationValue;

  _GeometricPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // Fases de oscilación para hacer que aparezcan/desaparezcan en distintos tiempos
    final sine1 = (math.sin(animationValue * math.pi * 2) + 1) / 2;
    final sine2 = (math.sin((animationValue + 0.33) * math.pi * 2) + 1) / 2;
    final sine3 = (math.sin((animationValue + 0.66) * math.pi * 2) + 1) / 2;
    final sine4 = (math.sin((animationValue + 0.15) * math.pi * 2) + 1) / 2;
    final sine5 = (math.sin((animationValue + 0.8) * math.pi * 2) + 1) / 2;

    // Función auxiliar para dibujar contornos con opacidad variante (Picos ocasionales)
    void drawFadingShape(void Function(Paint) drawFunc, double sinePhase) {
      // Usamos una potencia alta (pow) para que la figura esté tenue la mayor parte del tiempo,
      // pero ocasionalmente haga un "pico" de brillo de hasta 35% de opacidad.
      final spike = math.pow(sinePhase, 10).toDouble();
      final alpha = 0.01 + (spike * 0.35); 
      
      final paint = Paint()
        ..color = AppColors.green.withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      drawFunc(paint);
    }

    // 1. Cuadrado rotando a la izquierda
    drawFadingShape((paint) {
      canvas.save();
      canvas.translate(size.width * 0.2, size.height * 0.3);
      canvas.rotate(animationValue * math.pi); // Rotación completa en 30s (ida y vuelta)
      canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: 140, height: 140), paint);
      canvas.restore();
    }, sine1);

    // 2. Círculos concéntricos gigantes (como un radar) a la derecha
    drawFadingShape((paint) {
      canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.7), 250, paint);
      canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.7), 350, paint);
      canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.7), 450, paint);
    }, sine2);

    // 3. Triángulo flotando abajo a la izquierda
    drawFadingShape((paint) {
      canvas.save();
      canvas.translate(size.width * 0.25, size.height * 0.75);
      canvas.rotate(-animationValue * math.pi * 0.5);
      final path = Path();
      path.moveTo(0, -40);
      path.lineTo(35, 20);
      path.lineTo(-35, 20);
      path.close();
      canvas.drawPath(path, paint);
      canvas.restore();
    }, sine3);
    
    // 4. Cruz/Mira pequeña arriba a la derecha
    drawFadingShape((paint) {
      canvas.save();
      canvas.translate(size.width * 0.75, size.height * 0.2);
      canvas.rotate(animationValue * math.pi);
      canvas.drawLine(const Offset(-20, 0), const Offset(20, 0), paint);
      canvas.drawLine(const Offset(0, -20), const Offset(0, 20), paint);
      canvas.restore();
    }, sine1);

    // 5. Hexágono arriba a la izquierda
    drawFadingShape((paint) {
      canvas.save();
      canvas.translate(size.width * 0.1, size.height * 0.15);
      canvas.rotate(animationValue * math.pi * 1.5);
      final path = Path();
      for (int i = 0; i < 6; i++) {
        final angle = (math.pi / 3) * i;
        final x = 45 * math.cos(angle);
        final y = 45 * math.sin(angle);
        if (i == 0) path.moveTo(x, y);
        else path.lineTo(x, y);
      }
      path.close();
      canvas.drawPath(path, paint);
      canvas.restore();
    }, sine4);

    // 6. Grupo de puntos (grid de datos) en el centro derecha
    drawFadingShape((paint) {
      paint.style = PaintingStyle.fill;
      canvas.save();
      canvas.translate(size.width * 0.9, size.height * 0.4);
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          canvas.drawCircle(Offset(i * 15.0, j * 15.0), 2.5, paint);
        }
      }
      canvas.restore();
    }, sine5);

    // 7. Línea diagonal de "medición/gráfico" abajo a la derecha
    drawFadingShape((paint) {
      canvas.save();
      canvas.translate(size.width * 0.8, size.height * 0.9);
      canvas.drawLine(const Offset(-40, 40), const Offset(40, -40), paint);
      // Pequeñas marcas en la línea
      canvas.drawLine(const Offset(-30, 30), const Offset(-25, 35), paint);
      canvas.drawLine(const Offset(0, 0), const Offset(5, 5), paint);
      canvas.drawLine(const Offset(30, -30), const Offset(35, -25), paint);
      canvas.restore();
    }, sine4);
    
    // 8. Barras verticales (código de barras) centro izquierda
    drawFadingShape((paint) {
      paint.style = PaintingStyle.fill;
      canvas.save();
      canvas.translate(size.width * 0.05, size.height * 0.55);
      canvas.drawRect(const Rect.fromLTWH(0, 0, 4, 60), paint);
      canvas.drawRect(const Rect.fromLTWH(10, 10, 2, 40), paint);
      canvas.drawRect(const Rect.fromLTWH(18, 0, 6, 60), paint);
      canvas.restore();
    }, sine2);
  }

  @override
  bool shouldRepaint(covariant _GeometricPainter oldDelegate) {
    // Repintar constantemente mientras cambie el valor
    return oldDelegate.animationValue != animationValue;
  }
}
