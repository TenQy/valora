import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_card.dart';
import 'auth_service.dart';

/// Pantalla de prueba para validar la conexión de Auth con Supabase.
///
/// Permite alternar entre "Iniciar sesión" y "Registrarse", además de
/// ofrecer un botón de "Continuar con Google". Al autenticar con éxito,
/// muestra los datos del usuario y un botón para cerrar sesión, lo que
/// sirve como verificación visual rápida desde el celular.
class AuthTestScreen extends StatefulWidget {
  const AuthTestScreen({super.key});

  @override
  State<AuthTestScreen> createState() => _AuthTestScreenState();
}

class _AuthTestScreenState extends State<AuthTestScreen> {
  final _authService = AuthService(Supabase.instance.client);

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isRegisterMode = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitEmailForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_isRegisterMode) {
        await _authService.signUpWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          fullName: _fullNameController.text.trim(),
        );
      } else {
        await _authService.signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }
    } on AuthException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (e) {
      setState(() => _errorMessage = 'Ocurrió un error inesperado: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submitGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.signInWithGoogle();
    } on AuthException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (e) {
      setState(() => _errorMessage = 'Ocurrió un error inesperado: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    setState(() => _isLoading = true);
    await _authService.signOut();
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba de Auth')),
      body: StreamBuilder<AuthState>(
        stream: _authService.authStateChanges,
        builder: (context, snapshot) {
          final user = _authService.currentUser;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.space24),
              child: user != null
                  ? _SignedInView(user: user, onSignOut: _signOut, isLoading: _isLoading)
                  : _buildAuthForm(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAuthForm() {
    return AppCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isRegisterMode ? 'Crear cuenta' : 'Iniciar sesión',
              style: AppTextStyles.title,
            ),
            const SizedBox(height: AppSpacing.space8),
            Text(
              _isRegisterMode
                  ? 'Regístrate para empezar a usar Valora.'
                  : 'Ingresa con tu correo y contraseña.',
              style: AppTextStyles.subtitle,
            ),
            const SizedBox(height: AppSpacing.space24),
            if (_isRegisterMode) ...[
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Nombre completo'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa tu nombre completo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.space16),
            ],
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Correo'),
              validator: (value) {
                if (value == null || !value.contains('@')) {
                  return 'Ingresa un correo válido';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.space16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Mínimo 6 caracteres';
                }
                return null;
              },
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: AppSpacing.space16),
              Text(
                _errorMessage!,
                style: AppTextStyles.compactBody.copyWith(
                  color: AppColors.colorError,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.space24),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitEmailForm,
              child: _isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_isRegisterMode ? 'Registrarme' : 'Entrar'),
            ),
            const SizedBox(height: AppSpacing.space12),
            OutlinedButton.icon(
              onPressed: _isLoading ? null : _submitGoogle,
              icon: const Icon(Icons.g_mobiledata, size: 24),
              label: const Text('Continuar con Google'),
            ),
            const SizedBox(height: AppSpacing.space16),
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () => setState(() {
                        _isRegisterMode = !_isRegisterMode;
                        _errorMessage = null;
                      }),
              child: Text(
                _isRegisterMode
                    ? '¿Ya tienes cuenta? Inicia sesión'
                    : '¿No tienes cuenta? Regístrate',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignedInView extends StatelessWidget {
  const _SignedInView({
    required this.user,
    required this.onSignOut,
    required this.isLoading,
  });

  final User user;
  final VoidCallback onSignOut;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.check_circle, color: AppColors.colorSuccess, size: 40),
          const SizedBox(height: AppSpacing.space16),
          Text('Sesión activa', style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.space8),
          Text('ID: ${user.id}', style: AppTextStyles.compactBody),
          const SizedBox(height: AppSpacing.space8),
          Text(
            'Correo: ${user.email ?? 'No disponible'}',
            style: AppTextStyles.compactBody,
          ),
          const SizedBox(height: AppSpacing.space24),
          OutlinedButton(
            onPressed: isLoading ? null : onSignOut,
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}