import 'package:flutter/material.dart';

/// Envuelve [child] con una animación de entrada (fade + slide),
/// que arranca automáticamente tras un [delay] opcional.
///
/// Reutilizable en cualquier pantalla con animaciones de entrada
/// escalonadas (splash, onboarding, welcome, etc.) — evita repetir
/// AnimationController + Tween + Future.delayed en cada StatefulWidget.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 400),
    this.offset = const Offset(0, 12),
    super.key,
  });

  final Widget child;

  /// Tiempo de espera antes de iniciar la animación.
  final Duration delay;

  /// Duración de la animación en sí (fade + slide).
  final Duration duration;

  /// Posición inicial relativa desde la que entra el widget.
  /// Ej: `Offset(12, 0)` entra desde la derecha, `Offset(0, 12)` desde abajo.
  final Offset offset;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slide = Tween<Offset>(begin: widget.offset, end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(widget.delay, () {
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Opacity(
        opacity: _opacity.value,
        child: Transform.translate(offset: _slide.value, child: child),
      ),
      child: widget.child,
    );
  }
}