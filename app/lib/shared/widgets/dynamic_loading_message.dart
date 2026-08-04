import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class DynamicLoadingMessage extends StatefulWidget {
  final List<String> messages;
  final Duration interval;

  const DynamicLoadingMessage({
    super.key,
    this.messages = const [
      'Analizando tu perfil...',
      'Consultando el mercado laboral actual...',
      'Calculando estimaciones...',
      'Generando reporte final...',
    ],
    this.interval = const Duration(seconds: 3),
  });

  @override
  State<DynamicLoadingMessage> createState() => _DynamicLoadingMessageState();
}

class _DynamicLoadingMessageState extends State<DynamicLoadingMessage> {
  late Timer _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.interval, (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % widget.messages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.silver.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.silver),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                widget.messages[_currentIndex],
                key: ValueKey<int>(_currentIndex),
                style: const TextStyle(color: AppColors.silver, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
