import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/valora_app_bar.dart';
import '../../shared/widgets/animated_app_background.dart';
import '../../shared/widgets/nav_bar.dart';
import '../auth/auth_service.dart';
import '../welcome/welcome_screen.dart';
import '../profile/profile_screen.dart';
import '../results/salary_estimation_screen.dart';

/// Dashboard con navegación inferior (ver ROADMAP.md Fase 7).
///
/// Cada tab del `NavBar` corresponde a un contenido dentro de un
/// `IndexedStack`, así el AppBar y el BottomNavigationBar (definidos según
/// UI_GUIDELINES.md §6.8) se mantienen fijos mientras cambia el body.
///
/// Orden de tabs: **Inicio (0) → Perfil (1) → Proyectos (2)**.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _authService = AuthService(Supabase.instance.client);

  int _currentIndex = 0;
  bool _isSigningOut = false;

  static const _tabs = [
    NavBarItem(icon: Icons.home_outlined, label: 'Inicio'),
    NavBarItem(icon: Icons.person_outline, label: 'Perfil'),
    NavBarItem(icon: Icons.folder_outlined, label: 'Proyectos'),
  ];

  Future<void> _signOut() async {
    setState(() => _isSigningOut = true);
    try {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
          (route) => false,
        );
      }
    } finally {
      if (mounted) setState(() => _isSigningOut = false);
    }
  }

  void _openSalaryEstimation() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SalaryEstimationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      extendBodyBehindAppBar: true,
      appBar: ValoraAppBar(),
      body: AnimatedAppBackground(
        child: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: _currentIndex,
            children: [
              _HomeTab(onEstimateSalaryPressed: _openSalaryEstimation),
              ProfileContent(
                onEditPressed: () {
                  // TODO: navegar a Editar Perfil.
                },
                onSignOut: _signOut,
                isSigningOut: _isSigningOut,
              ),
              const _ComingSoonTab(
                icon: Icons.folder_outlined,
                message: 'Próximamente podrás registrar tus proyectos aquí.',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        items: _tabs,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

/// Tab "Inicio" del Dashboard. Placeholder mientras se construye el
/// resumen completo (valor estimado, compatibilidad, historial — ver
/// ARCHITECTURE.md "dashboard/"). Ya incluye el acceso a la estimación
/// salarial.
class _HomeTab extends StatelessWidget {
  const _HomeTab({required this.onEstimateSalaryPressed});

  final VoidCallback onEstimateSalaryPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Descubre tu valor profesional',
              textAlign: TextAlign.center,
              style: AppTextStyles.h1,
            ),
            const SizedBox(height: AppSpacing.space12),
            Text(
              'Calcula un rango salarial aproximado con base en tu perfil.',
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitle,
            ),
            const SizedBox(height: AppSpacing.space24),
            ElevatedButton(
              onPressed: onEstimateSalaryPressed,
              child: const Text('Estimar salario'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder genérico para tabs aún no construidos (ej. Proyectos, ver
/// ROADMAP.md Fase 9 — funcionalidad posterior al MVP).
class _ComingSoonTab extends StatelessWidget {
  const _ComingSoonTab({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: AppColors.silverMuted),
            const SizedBox(height: AppSpacing.space16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}