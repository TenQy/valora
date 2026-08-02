import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/widgets/valora_app_bar.dart';
import '../../shared/widgets/animated_app_background.dart';
import '../../shared/widgets/nav_bar.dart';
import '../auth/auth_service.dart';
import '../splash/splash_screen.dart';
import '../onboarding/screens/tutorial_screen.dart';
import '../profile/edit_profile_screen.dart';
import '../profile/profile_tab.dart';
import '../projects/screens/projects_screen.dart';
import '../results/job_match_screen.dart';
import '../results/salary_estimation_screen.dart';
import '../profile/edit_profile_screen.dart';
import '../profile/services/profile_repository.dart';
import '../../core/services/notification_service.dart';
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

class _DashboardScreenState extends State<DashboardScreen> with WidgetsBindingObserver {
  final _authService = AuthService(Supabase.instance.client);
  final _notificationService = NotificationService();

  int _currentIndex = 0;
  bool _isSigningOut = false;
  Key _profileTabKey = UniqueKey();
  Key _homeTabKey = UniqueKey();

  static const _tabs = [
    NavBarItem(icon: Icons.home_outlined, label: 'Inicio'),
    NavBarItem(icon: Icons.person_outline, label: 'Perfil'),
    NavBarItem(icon: Icons.folder_outlined, label: 'Proyectos'),
  ];

  bool _checkingProfile = true;
  bool _isProfileIncomplete = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initNotifications();
    _checkProfileCompletion();
  }

  Future<void> _initNotifications() async {
    await _notificationService.initialize();
    await _notificationService.requestPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      if (_isProfileIncomplete) {
        // Programa la notificación para 3 segundos en el futuro (incluso si se mata la app)
        _notificationService.scheduleProfileReminderNotification(
          delay: const Duration(seconds: 3),
        );
      }
    } else if (state == AppLifecycleState.resumed) {
      // Si el usuario vuelve a entrar antes de que suene o ya sonó, cancelamos pendientes
      _notificationService.cancelAllNotifications();
    }
  }

  Future<void> _checkProfileCompletion() async {
    try {
      final repo = ProfileRepository(Supabase.instance.client);
      final profile = await repo.fetchCurrentProfile();
      
      if (profile != null) {
        // Calculamos empíricamente si está debajo del 70%
        _isProfileIncomplete = profile.competencies.isEmpty || 
                              profile.languages.isEmpty || 
                              profile.professionalArea == 'Sin área';
      }

      if (profile == null || profile.professionalArea == 'Sin área') {
        final prefs = await SharedPreferences.getInstance();
        final hasSeenTutorial = prefs.getBool('has_seen_tutorial') ?? false;

        if (!mounted) return;

        if (!hasSeenTutorial) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const TutorialScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const EditProfileScreen(isInitialSetup: true)),
          );
        }
        return;
      } else {
        // El usuario ya tiene un perfil. Verificamos si hay una prueba de invitado por migrar.
        final prefs = await SharedPreferences.getInstance();
        final guestResultJson = prefs.getString('guest_estimation_result');
        if (guestResultJson != null) {
          final rawProfile = await repo.fetchRawProfileForEditing();
          if (rawProfile != null) {
            final profileId = rawProfile['id'] as String;
            final guestData = jsonDecode(guestResultJson) as Map<String, dynamic>;
            await repo.saveGuestEstimation(profileId, guestData);
            await prefs.remove('guest_estimation_result');
          }
        }
      }
    } catch (_) {}
    
    if (mounted) {
      setState(() {
        _checkingProfile = false;
      });
    }
  }

  Future<void> _signOut() async {
    setState(() => _isSigningOut = true);
    try {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const SplashScreen()),
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