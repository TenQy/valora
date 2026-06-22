import 'package:supabase_flutter/supabase_flutter.dart';

/// Centraliza todas las llamadas a Supabase Auth (Email/Password y Google).
///
/// Mantener esta lógica separada de las pantallas permite reutilizarla
/// desde cualquier parte de la app y facilita escribir pruebas en el futuro.
class AuthService {
  AuthService(this._client);

  final SupabaseClient _client;

  /// Usuario actualmente autenticado (null si no hay sesión activa).
  User? get currentUser => _client.auth.currentUser;

  /// Stream que emite cada cambio de estado de autenticación
  /// (signedIn, signedOut, tokenRefreshed, etc.).
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Registra un usuario nuevo con correo y contraseña.
  ///
  /// El `fullName` se guarda en los metadatos del usuario; el trigger SQL
  /// `handle_new_user` lo usa para crear el registro en `profiles`.
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) {
    return _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  /// Inicia sesión con correo y contraseña.
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  /// Inicia sesión con Google usando el flujo nativo (Android/iOS).
  ///
  /// Requiere que el provider de Google esté configurado en el dashboard
  /// de Supabase y que el Client ID de tipo "Web" esté registrado ahí.
  /// En Android/iOS, supabase_flutter abre el flujo nativo de Google
  /// y luego intercambia el token con Supabase.
  Future<bool> signInWithGoogle() {
    return _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.valora://login-callback',
    );
  }

  /// Cierra la sesión actual.
  Future<void> signOut() {
    return _client.auth.signOut();
  }
}