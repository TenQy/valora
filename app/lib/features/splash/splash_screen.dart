import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_colors.dart';
import '../dashboard/dashboard_screen.dart';
import '../guest/screens/guest_dashboard_screen.dart';
import '../auth/screens/lock_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<double> _scaleIn;
  late final Animation<double> _pulse;
  late final Animation<double> _loaderOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.23, curve: Curves.easeOut),
      ),
    );

    _scaleIn = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.23, curve: Curves.easeOutCubic),
      ),
    );

    _pulse = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.06)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.06, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.36, 0.64, curve: Curves.linear),
      ),
    );

    _loaderOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.27, 0.45, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2000), () async {
      if (!mounted) return;

      final session = Supabase.instance.client.auth.currentSession;
      final hasValidSession = session != null && !session.isExpired;

      final prefs = await SharedPreferences.getInstance();
      final savedPin = prefs.getString('app_pin');
      final isLocked = savedPin != null && savedPin.isNotEmpty;

      if (!mounted) return;

      Widget nextScreen;
      if (hasValidSession) {
        nextScreen = const DashboardScreen();
      } else {
        nextScreen = const GuestDashboardScreen();
      }

      if (isLocked) {
        nextScreen = LockScreen(nextScreen: nextScreen);
      }

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, _, _) => nextScreen,
          transitionsBuilder: (_, animation, _, child) {
            // Fade suave mientras el Hero hace su magia
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeIn,
              ),
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Hero — el logo vuela desde aquí hasta WelcomeScreen
            Hero(
              tag: 'valora-logo',
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final double scale = _scaleIn.value * _pulse.value;
                  return Opacity(
                    opacity: _fadeIn.value,
                    child: Transform.scale(scale: scale, child: child),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/logos/app_icon.png',
                    width: 110,
                    height: 110,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 48),

            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => Opacity(
                opacity: _loaderOpacity.value,
                child: child,
              ),
              child: const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: AppColors.silverMuted,
                  strokeWidth: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}