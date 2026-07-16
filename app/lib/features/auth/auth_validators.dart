// features/auth/auth_validators.dart

/// Validaciones reutilizadas por los campos del formulario de AuthScreen.
///
/// Se centralizan aquí para no repetir lógica inline en cada TextFormField
/// y para poder testearlas de forma aislada.
class AuthValidators {
  const AuthValidators._();

  static String? email(String? value) {
    if (value == null || !value.contains('@')) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa tu nombre completo';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.length < 6) {
      return 'Mínimo 6 caracteres';
    }
    return null;
  }

  /// Requiere el valor de la contraseña original para comparar.
  static String? Function(String?) confirmPassword(String originalPassword) {
    return (String? value) {
      if (value != originalPassword) {
        return 'Las contraseñas no coinciden';
      }
      return null;
    };
  }
}