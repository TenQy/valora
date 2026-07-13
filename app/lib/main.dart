import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ValoraApp());
}

class ValoraApp extends StatelessWidget {
  const ValoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const SplashScreen(),
      routes: {
        '/dashboard': (_) => const Scaffold(
              backgroundColor: Color(0xFF0D0D0D),
              body: Center(
                child: Text(
                  'Dashboard',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
      },
    );
  }
}