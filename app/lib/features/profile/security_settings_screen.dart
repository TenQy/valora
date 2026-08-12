import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/valora_app_bar.dart';
import '../../shared/widgets/animated_app_background.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final _pinController = TextEditingController();
  final _localAuth = LocalAuthentication();
  
  bool _isLoading = true;
  bool _useBiometrics = false;
  bool _canCheckBiometrics = false;
  List<BiometricType> _availableBiometrics = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final pin = prefs.getString('app_pin') ?? '';
    final useBio = prefs.getBool('use_biometrics') ?? false;

    bool canCheck = false;
    List<BiometricType> availableBio = [];
    try {
      canCheck = await _localAuth.canCheckBiometrics;
      if (canCheck) {
        availableBio = await _localAuth.getAvailableBiometrics();
      }
    } catch (e) {
      debugPrint('Error checking biometrics: $e');
    }

    if (!mounted) return;
    setState(() {
      _pinController.text = pin;
      _useBiometrics = useBio;
      _canCheckBiometrics = canCheck;
      _availableBiometrics = availableBio;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final pin = _pinController.text.trim();
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('app_pin', pin);
    await prefs.setBool('use_biometrics', _useBiometrics);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuración de seguridad guardada.'),
        backgroundColor: AppColors.colorSuccess,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      extendBodyBehindAppBar: true,
      appBar: const ValoraAppBar(
        title: 'Seguridad y Privacidad',
        showBackButton: true,
      ),
      body: AnimatedAppBackground(
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.space24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Protege el acceso a tus datos financieros estableciendo un PIN. Opcionalmente, puedes usar tu huella dactilar o rostro para iniciar sesión más rápido.',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                      ),
                      const SizedBox(height: AppSpacing.space32),
                      TextFormField(
                        controller: _pinController,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'PIN de acceso (4-6 dígitos)',
                          hintText: 'Ej. 1234',
                          prefixIcon: Icon(Icons.lock_outline, color: AppColors.textMuted),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space32),
                      if (_canCheckBiometrics)
                        SwitchListTile(
                          title: const Text('Usar Biometría (Huella/Rostro)', style: TextStyle(color: Colors.white)),
                          subtitle: Text(
                            _availableBiometrics.contains(BiometricType.face) 
                              ? 'FaceID o Reconocimiento Facial' 
                              : 'Lector de Huella Dactilar',
                            style: const TextStyle(color: AppColors.textMuted),
                          ),
                          activeColor: Colors.white,
                          value: _useBiometrics,
                          onChanged: (val) async {
                            if (val) {
                              // Intentar autenticar antes de habilitar
                              try {
                                final didAuthenticate = await _localAuth.authenticate(
                                  localizedReason: 'Autentícate para habilitar la biometría en Valora',
                                  biometricOnly: true,
                                  persistAcrossBackgrounding: true,
                                );
                                if (didAuthenticate) {
                                  setState(() => _useBiometrics = true);
                                }
                              } catch (e) {
                                debugPrint('Error al autenticar: $e');
                              }
                            } else {
                              setState(() => _useBiometrics = false);
                            }
                          },
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Tu dispositivo no soporta biometría o no está configurada.',
                            style: TextStyle(color: AppColors.colorWarning, fontSize: 13),
                          ),
                        ),
                      const SizedBox(height: AppSpacing.space48),
                      ElevatedButton(
                        onPressed: _saveSettings,
                        child: const Text('Guardar Seguridad'),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
