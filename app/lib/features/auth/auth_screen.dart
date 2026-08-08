import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/animated_app_background.dart';
import '../../shared/widgets/app_header.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/secondary_button.dart';
import '../../shared/widgets/valora_app_bar.dart';

import '../dashboard/dashboard_screen.dart';
import '../onboarding/screens/tutorial_screen.dart';
import 'auth_service.dart';
import 'auth_validators.dart';
import 'widgets/auth_mode_toggle.dart';
import 'widgets/auth_or_divider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _authService = AuthService(Supabase.instance.client);
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    if (_isLoading) return;
    setState(() {
      _isLogin = !_isLogin;
      _errorMessage = null;

      _fullNameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _obscurePassword = true;
      _obscureConfirmPassword = true;
    });

    // Limpia los estados de validación (bordes rojos) del Form.
    _formKey.currentState?.reset();
  }

  /// Ejecuta una acción de auth (email o Google) manejando loading,
  /// navegación al éxito y errores de forma unificada.
  ///
  /// [action] es la llamada al AuthService (signIn, signUp, Google, etc).
  /// [genericErrorMessage] se muestra si ocurre un error no controlado
  /// por Supabase (ej. fallo de red).
  Future<void> _runAuthAction(
    Future<void> Function() action, {
    required String genericErrorMessage,
  }) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await action();
      if (mounted) {
        // Solo navegamos si la sesión realmente se estableció.
        // En Web (signInWithOAuth), esto evita que navegue prematuramente
        // mientras el navegador hace la redirección a Google.
        if (_authService.currentUser != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        }
      }
    } on GoogleSignInCancelledException {
      // Cancelación del usuario: no es un error, no mostramos nada.
    } on AuthException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (e) {
      print('Auth Error: $e');
      setState(() => _errorMessage = '$genericErrorMessage\nDetalle: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submitEmailForm() async {
    if (!_formKey.currentState!.validate()) return;

    await _runAuthAction(
      () => _isLogin
          ? _authService.signInWithEmail(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            )
          : _authService.signUpWithEmail(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              fullName: _fullNameController.text.trim(),
            ),
      genericErrorMessage: 'Ocurrió un error inesperado. Intenta de nuevo.',
    );
  }

  Future<void> _submitGoogle() async {
    await _runAuthAction(
      _authService.signInWithGoogle,
      genericErrorMessage: 'No se pudo iniciar sesión con Google.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: const ValoraAppBar(showBackButton: true),
      body: AnimatedAppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.space24),

                AppHeader(
                  title: _isLogin ? 'Bienvenido de nuevo' : 'Crea tu cuenta',
                  subtitle: _isLogin
                      ? 'Ingresa con tu correo y contraseña.'
                      : 'Regístrate para conocer tu valor profesional.',
                ),

                const SizedBox(height: AppSpacing.space32),

                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_isLogin) ...[
                        AppTextField(
                          controller: _fullNameController,
                          hintText: 'Nombre completo',
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: AuthValidators.fullName,
                        ),
                        const SizedBox(height: AppSpacing.space16),
                      ],
                      AppTextField(
                        controller: _emailController,
                        hintText: 'Correo electrónico',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: AuthValidators.email,
                      ),
                      const SizedBox(height: AppSpacing.space16),
                      AppTextField(
                        controller: _passwordController,
                        hintText: 'Contraseña',
                        obscureText: _obscurePassword,
                        textInputAction: _isLogin
                            ? TextInputAction.done
                            : TextInputAction.next,
                        suffixIcon: IconButton(
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.textMuted,
                            size: 20,
                          ),
                        ),
                        validator: AuthValidators.password,
                      ),
                      if (_isLogin) ...[
                        const SizedBox(height: AppSpacing.space8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _isLoading ? null : () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              '¿Olvidaste tu contraseña?',
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (!_isLogin) ...[
                        const SizedBox(height: AppSpacing.space16),
                        AppTextField(
                          controller: _confirmPasswordController,
                          hintText: 'Confirmar contraseña',
                          obscureText: _obscureConfirmPassword,
                          textInputAction: TextInputAction.done,
                          suffixIcon: IconButton(
                            onPressed: () => setState(
                              () => _obscureConfirmPassword =
                                  !_obscureConfirmPassword,
                            ),
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColors.textMuted,
                              size: 20,
                            ),
                          ),
                          validator: AuthValidators.confirmPassword(
                            _passwordController.text,
                          ),
                        ),
                      ],
                      if (_errorMessage != null) ...[
                        const SizedBox(height: AppSpacing.space16),
                        Text(
                          _errorMessage!,
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.colorError,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.space28),

                PrimaryButton(
                  label: _isLogin ? 'Iniciar sesión' : 'Crear cuenta',
                  isLoading: _isLoading,
                  onPressed: _submitEmailForm,
                ),

                const SizedBox(height: AppSpacing.space24),
                const AuthOrDivider(),
                const SizedBox(height: AppSpacing.space24),

                SecondaryButton(
                  label: _isLogin
                      ? 'Iniciar sesión con Google'
                      : 'Registrarme con Google',
                  isLoading: _isLoading,
                  onPressed: _submitGoogle,
                ),

                const SizedBox(height: AppSpacing.space24),

                AuthModeToggle(
                  isLogin: _isLogin,
                  onToggle: _toggleMode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}