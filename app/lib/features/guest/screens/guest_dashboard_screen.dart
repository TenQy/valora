import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/animated_app_background.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../../auth/auth_screen.dart';
import 'guest_estimation_screen.dart';

class GuestDashboardScreen extends StatelessWidget {
  const GuestDashboardScreen({super.key});

  Future<void> _checkEstimationAndNavigate(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasDoneGuestEstimation = prefs.getBool('has_done_guest_estimation') ?? false;

    if (hasDoneGuestEstimation) {
      if (!context.mounted) return;
      // Ya usó su estimación, mostrar paywall/modal
      _showRegistrationModal(context);
    } else {
      if (!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const GuestEstimationScreen()),
      );
    }
  }

  void _showRegistrationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(AppSpacing.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.lock_outline, size: 48, color: AppColors.silver),
            const SizedBox(height: AppSpacing.space16),
            Text(
              'Has usado tu estimación gratuita',
              style: AppTextStyles.h1.copyWith(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.space16),
            const Text(
              'Para realizar más estimaciones, ver el desglose detallado y descubrir tu compatibilidad laboral, crea tu cuenta gratis en segundos.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.space32),
            PrimaryButton(
              label: 'Crear cuenta gratis',
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                );
              },
            ),
            const SizedBox(height: AppSpacing.space16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ahora no', style: TextStyle(color: AppColors.textMuted)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: AnimatedAppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.space24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Image.asset(
                  'assets/logos/app_icon.png',
                  height: 80,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: AppSpacing.space32),
                Text(
                  'Descubre tu valor\nen el mercado',
                  style: AppTextStyles.h1.copyWith(fontSize: 32),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.space24),
                const Text(
                  'Usa nuestro modelo de forma gratuita para obtener un estimado salarial basado en tus conocimientos.',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 16, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                PrimaryButton(
                  label: 'Prueba rápida',
                  onPressed: () => _checkEstimationAndNavigate(context),
                ),
                const SizedBox(height: AppSpacing.space16),
                SecondaryButton(
                  label: 'Ya tengo cuenta',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.space16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
