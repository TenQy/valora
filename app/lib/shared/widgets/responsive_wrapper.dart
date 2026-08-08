import 'package:flutter/material.dart';

/// Un wrapper para limitar el ancho de la aplicación en pantallas grandes (PC/Web).
/// Mantiene la aplicación centrada y evita que los elementos de UI se estiren demasiado.
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth = 600.0, // Un ancho de 600px es cómodo para leer en PC
  });

  @override
  Widget build(BuildContext context) {
    // Scaffold base para que los bordes sobrantes tengan color de fondo del tema
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
          ),
          child: ClipRect(
            child: child,
          ),
        ),
      ),
    );
  }
}
