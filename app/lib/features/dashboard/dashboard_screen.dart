import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/widgets/valora_app_bar.dart';
import '../../shared/widgets/animated_app_background.dart';
import '../../shared/widgets/nav_bar.dart';
import '../auth/auth_service.dart';
import '../welcome/welcome_screen.dart';
import '../profile/edit_profile_screen.dart';
import '../profile/profile_tab.dart';
import '../projects/screens/projects_screen.dart';
import '../results/job_match_screen.dart';
import '../results/salary_estimation_screen.dart';
import 'home_tab.dart';

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
  Key _profileTabKey = UniqueKey();
  Key _homeTabKey = UniqueKey();

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

  Future<void> _openSalaryEstimation() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SalaryEstimationScreen()),
    );
    if (mounted) {
      setState(() {
        _homeTabKey = UniqueKey();
      });
    }
  }

  Future<void> _openEditProfile() async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );

    if (updated == true && mounted) {
      setState(() {
        _profileTabKey = UniqueKey();
        _homeTabKey = UniqueKey();
      });
    }
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
              HomeTab(
                key: _homeTabKey,
                onEstimateSalaryPressed: _openSalaryEstimation,
                onJobMatchPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const JobMatchScreen()),
                  );
                  if (mounted) {
                    setState(() {
                      _homeTabKey = UniqueKey();
                    });
                  }
                },
              ),
              ProfileTab(
                key: _profileTabKey,
                onEditPressed: _openEditProfile,
                onSignOut: _signOut,
                isSigningOut: _isSigningOut,
              ),
              const ProjectsTab(),
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