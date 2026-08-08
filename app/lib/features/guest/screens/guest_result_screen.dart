import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/animated_app_background.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../auth/auth_screen.dart';
import 'guest_dashboard_screen.dart';

class GuestResultScreen extends StatefulWidget {
  const GuestResultScreen({
    super.key,
    required this.estimatedMinSalary,
    required this.estimatedMaxSalary,
    required this.currency,
    required this.level,
    required this.summary,
  });

  final int estimatedMinSalary;
  final int estimatedMaxSalary;
  final String currency;
  final String level;
  final String summary;

  @override
  State<GuestResultScreen> createState() => _GuestResultScreenState();
}

class _GuestResultScreenState extends State<GuestResultScreen> {
  @override
  void initState() {
    super.initState();
    _markGuestEstimationDone();
  }

  Future<void> _markGuestEstimationDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_done_guest_estimation', true);
    await prefs.setBool('has_seen_tutorial', true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const GuestDashboardScreen()),
          (route) => false,
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.bgBase,
        body: AnimatedAppBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.space24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.space32),
                  const Icon(Icons.check_circle_outline, size: 64, color: AppColors.colorSuccess),
                  const SizedBox(height: AppSpacing.space24),
                  Text(
                    '¡Aquí está tu valor!',
                    style: AppTextStyles.h1.copyWith(fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.space32),
                  
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.space24),
                    decoration: BoxDecoration(
                      color: AppColors.silver.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.silver.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Estimación Mensual',
                          style: TextStyle(color: AppColors.silver.withValues(alpha: 0.8), fontSize: 14),
                        ),
                        const SizedBox(height: AppSpacing.space12),
                        Text(
                          '\$${Formatters.formatThousands(widget.estimatedMinSalary)} - \$${Formatters.formatThousands(widget.estimatedMaxSalary)}',
                          style: AppTextStyles.h1.copyWith(fontSize: 32, color: AppColors.silver),
                        ),
                        const SizedBox(height: AppSpacing.space4),
                        Text(
                          widget.currency,
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.space32),
                  const Text(
                    'Resumen de tu Perfil',
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppSpacing.space12),
                  Text(
                    widget.summary,
                    style: const TextStyle(color: AppColors.textMuted, height: 1.5),
                  ),
                  const SizedBox(height: AppSpacing.space48),

                  Container(
                    padding: const EdgeInsets.all(AppSpacing.space24),
                    decoration: BoxDecoration(
                      color: AppColors.bgSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderDefault),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.lock_open, size: 32, color: AppColors.silver),
                        const SizedBox(height: AppSpacing.space16),
                        const Text(
                          'Desbloquea el análisis completo',
                          style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.space8),
                        const Text(
                          'Crea tu cuenta para guardar este resultado, ver el desglose detallado de por qué vales esto, y usar nuestro motor de Match Laboral.',
                          style: TextStyle(color: AppColors.silverMuted, fontSize: 14, height: 1.4),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.space24),
                        PrimaryButton(
                          label: 'Crear cuenta gratis',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const AuthScreen()),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.space12),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const GuestDashboardScreen()),
                              (route) => false,
                            );
                          },
                          child: const Text('Volver al inicio', style: TextStyle(color: AppColors.textMuted)),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.space32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
