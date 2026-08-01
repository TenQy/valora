import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../dashboard/dashboard_screen.dart';

class LockScreen extends StatefulWidget {
  final Widget nextScreen;
  const LockScreen({super.key, required this.nextScreen});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final _pinController = TextEditingController();
  final _localAuth = LocalAuthentication();
  
  String _savedPin = '';
  bool _useBiometrics = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _savedPin = prefs.getString('app_pin') ?? '';
    _useBiometrics = prefs.getBool('use_biometrics') ?? false;

    if (_useBiometrics) {
      _tryBiometricAuth();
    }
  }

  Future<void> _tryBiometricAuth() async {
    try {
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Desbloquea Valora con tu biometría',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
      if (didAuthenticate) {
        _unlock();
      }
    } catch (e) {
      debugPrint('Biometric error: $e');
    }
  }

  void _verifyPin() {
    if (_pinController.text == _savedPin) {
      _unlock();
    } else {
      setState(() {
        _errorMessage = 'PIN incorrecto';
        _pinController.clear();
      });
    }
  }

  void _unlock() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => widget.nextScreen,
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.space32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.lock_outline, size: 64, color: Colors.white),
              const SizedBox(height: AppSpacing.space24),
              const Text(
                'Valora está bloqueado',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.space12),
              const Text(
                'Ingresa tu PIN de seguridad para continuar',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 16),
              ),
              const SizedBox(height: AppSpacing.space48),
              TextFormField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 32, letterSpacing: 8, fontWeight: FontWeight.bold),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                onChanged: (v) {
                  if (_errorMessage != null) setState(() => _errorMessage = null);
                },
                decoration: InputDecoration(
                  hintText: '••••',
                  errorText: _errorMessage,
                ),
              ),
              const SizedBox(height: AppSpacing.space48),
              ElevatedButton(
                onPressed: _verifyPin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.space16),
                ),
                child: const Text('Desbloquear', style: TextStyle(fontSize: 16)),
              ),
              if (_useBiometrics) ...[
                const SizedBox(height: AppSpacing.space16),
                TextButton.icon(
                  onPressed: _tryBiometricAuth,
                  icon: const Icon(Icons.fingerprint, size: 24),
                  label: const Text('Usar Biometría', style: TextStyle(fontSize: 16)),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
