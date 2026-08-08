import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Se lanza cuando el usuario cierra el selector de cuentas de Google
/// sin completar el login. No es un error real — es una cancelación
/// intencional del usuario, y las pantallas deben tratarla en silencio.
class GoogleSignInCancelledException implements Exception {
  const GoogleSignInCancelledException();
}

/// Centraliza todas las llamadas a Supabase Auth (Email/Password y Google).
///
/// Mantener esta lógica separada de las pantallas permite reutilizarla
/// desde cualquier parte de la app y facilita escribir pruebas en el futuro.
class AuthService {
  AuthService(this._client);

  final SupabaseClient _client;

  /// Client ID de tipo "Web" registrado en Google Cloud Console.
  /// Supabase lo necesita para validar el ID token del usuario.
  static const _webClientId =
      '668166580258-52kloamq5fk6vh9fajsr61i30sodq8m5.apps.googleusercontent.com';

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
      emailRedirectTo: 'io.supabase.valora://login-callback',
    );
  }

  /// Inicia sesión con correo y contraseña.
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  /// Inicia sesión con Google usando el SDK nativo de Android.
  ///
  /// Muestra el selector de cuentas de Google directamente dentro de la
  /// app (sin abrir un navegador externo), obtiene el ID token y lo
  /// intercambia con Supabase para crear la sesión.
  Future<AuthResponse> signInWithGoogle() async {
    if (kIsWeb) {
      // En Web, los navegadores modernos bloquean las cookies de terceros, lo que rompe el plugin
      // nativo de google_sign_in. La forma oficial y robusta recomendada por Supabase para Web
      // es usar el flujo OAuth con redirección.
      final success = await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        // Supabase interceptará el token al regresar y restaurará la sesión automáticamente.
      );
      
      if (!success) {
        throw const AuthException('No se pudo iniciar sesión con Google en la Web.');
      }
      
      // Como signInWithOAuth redirige la página completa, el código normalmente no llega aquí.
      // Retornamos una respuesta vacía para cumplir con la firma de la función.
      return AuthResponse(session: _client.auth.currentSession, user: _client.auth.currentUser);
    }

    // Flujo para Android/iOS (Mantiene la ventana nativa sin redirigir el navegador)
    final googleSignIn = GoogleSignIn(
      clientId: null,
      serverClientId: _webClientId,
    );

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw const GoogleSignInCancelledException();
    }

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;

    if (idToken == null) {
      throw const AuthException(
        'No se pudo obtener el token de Google. Intenta de nuevo.',
      );
    }

    return _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: googleAuth.accessToken,
    );
  }

  /// Cierra la sesión actual.
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _client.auth.signOut();
  }
}