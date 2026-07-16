import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_bar.dart';
import '../../shared/widgets/nav_bar.dart';
import '../auth/auth_service.dart';
import '../welcome/welcome_screen.dart';

/// Pantalla placeholder mostrada cuando hay una sesión activa.
///
/// Sirve como destino temporal post-login mientras se construyen las
/// pantallas reales de cada sección (ver ROADMAP.md Fase 7). Ya incluye
/// el AppBar y el BottomNavigationBar definitivos según
/// UI_GUIDELINES.md §6.8, para que el resto de features solo tengan
/// que llenar el body.
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
    NavBarItem(icon: Icons.person_outline, label: 'Perfil'),
    NavBarItem(icon: Icons.home_outlined, label: 'Inicio'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: ValoraAppBar(),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.space24),
            child: OutlinedButton(
              onPressed: _isSigningOut ? null : _signOut,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: const BorderSide(color: AppColors.borderDefault),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space24,
                  vertical: AppSpacing.space16,
                ),
              ),
              child: _isSigningOut
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.textSecondary,
                      ),
                    )
                  : const Text('Cerrar sesión'),
            ),
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