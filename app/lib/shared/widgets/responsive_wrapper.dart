import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Un wrapper premium que simula un dispositivo físico (tipo iPhone)
/// y un entorno de escritorio inmersivo para presentaciones.
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
      backgroundColor: const Color(0xFF050505), // Fondo aún más oscuro para resaltar la luz
      body: Stack(
        alignment: Alignment.center,
        children: [
          // =================================================================
          // 1. FONDO ATMOSFÉRICO (Efecto Aurora)
          // =================================================================
          
          // Orbe Verde Esmeralda (Principal)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            right: MediaQuery.of(context).size.width * 0.15,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.green.withValues(alpha: 0.15),
              ),
            ),
          ),
          
          // Orbe Azul/Plata (Para dar profundidad y mezcla de color)
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.05,
            left: MediaQuery.of(context).size.width * 0.1,
            child: Container(
              width: 600,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3B82F6).withValues(alpha: 0.10), // Un toque azul tecnológico
              ),
            ),
          ),
          
          // Capa de difuminado gigante (Crea el efecto Aurora Real)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
              child: const SizedBox(),
            ),
          ),

          // =================================================================
          // 2. EL DISPOSITIVO FÍSICO (Simulador Premium)
          // =================================================================
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // -- Botones Físicos (Volumen y Encendido) --
                // Subir Volumen
                Positioned(
                  left: -6,
                  top: 150,
                  child: Container(width: 6, height: 60, decoration: _buttonDeco()),
                ),
                // Bajar Volumen
                Positioned(
                  left: -6,
                  top: 220,
                  child: Container(width: 6, height: 60, decoration: _buttonDeco()),
                ),
                // Botón de Encendido
                Positioned(
                  right: -6,
                  top: 180,
                  child: Container(width: 6, height: 80, decoration: _buttonDeco()),
                ),

                // -- Chasis del Teléfono --
                Container(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  margin: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    color: AppColors.bgBase,
                    borderRadius: BorderRadius.circular(48), // Curvatura más moderna
                    // Bisel metálico fino y elegante (estilo Titanio)
                    border: Border.all(
                      color: const Color(0xFF4A4A4C), // Metal oscuro / titanio
                      width: 6, // Mucho más delgado para un diseño "Edge to Edge"
                    ),
                    boxShadow: [
                      // Sombra pesada hacia abajo
                      BoxShadow(color: Colors.black.withValues(alpha: 0.7), blurRadius: 80, offset: const Offset(0, 40)),
                      // Halo verde sutil que emana del dispositivo
                      BoxShadow(color: AppColors.green.withValues(alpha: 0.1), blurRadius: 100, spreadRadius: 10),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // -- La Pantalla y la App --
                      ClipRRect(
                        borderRadius: BorderRadius.circular(42), // Curvatura interna ajustada
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
                                      Colors.white.withValues(alpha: 0.05),
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
                            color: const Color(0xFF050505), // Agujero negro profundo
                            boxShadow: [
                              BoxShadow(color: Colors.white.withValues(alpha: 0.15), blurRadius: 1, spreadRadius: 0.5),
                            ],
                            border: Border.all(color: Colors.black, width: 1.5),
                          ),
                          // Diminuto lente fotográfico interno
                          child: Center(
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF1E143F), // Reflejo azul/morado de lente de cámara
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
        ],
      ),
    );
  }

  // Estilo para los botones físicos laterales
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
