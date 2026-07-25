import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import 'models/profile_models.dart';
import 'services/profile_repository.dart';
import 'profile_screen.dart';

/// Tab "Perfil" del Dashboard: carga el perfil real desde Supabase
/// (vía [ProfileRepository]) y maneja los estados de carga / error /
/// perfil inexistente antes de mostrar [ProfileContent].
class ProfileTab extends StatefulWidget {
  const ProfileTab({
    super.key,
    required this.onEditPressed,
    required this.onSignOut,
    this.isSigningOut = false,
  });

  final VoidCallback onEditPressed;
  final VoidCallback onSignOut;
  final bool isSigningOut;

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final _repository = ProfileRepository(Supabase.instance.client);
  late Future<ProfessionalProfile?> _future;

  @override
  void initState() {
    super.initState();
    _future = _repository.fetchCurrentProfile();
  }

  void _reload() {
    setState(() => _future = _repository.fetchCurrentProfile());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfessionalProfile?>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }

        if (snapshot.hasError) {
          return _ProfileTabMessage(
            icon: Icons.error_outline,
            iconColor: AppColors.colorError,
            message: 'No pudimos cargar tu perfil. Intenta de nuevo.',
            onRetry: _reload,
            onSignOut: widget.onSignOut,
            isSigningOut: widget.isSigningOut,
          );
        }

        final profile = snapshot.data;
        if (profile == null) {
          return _ProfileTabMessage(
            icon: Icons.person_outline,
            iconColor: AppColors.silverMuted,
            message: 'Aún no tienes un perfil profesional creado.',
            onRetry: _reload,
            onSignOut: widget.onSignOut,
            isSigningOut: widget.isSigningOut,
            onCreateProfile: widget.onEditPressed,
          );
        }

        return ProfileContent(
          profile: profile,
          onEditPressed: widget.onEditPressed,
          onSignOut: widget.onSignOut,
          isSigningOut: widget.isSigningOut,
        );
      },
    );
  }
}

class _ProfileTabMessage extends StatelessWidget {
  const _ProfileTabMessage({
    required this.icon,
    required this.iconColor,
    required this.message,
    required this.onRetry,
    this.onSignOut,
    this.isSigningOut = false,
    this.onCreateProfile,
  });

  final IconData icon;
  final Color iconColor;
  final String message;
  final VoidCallback onRetry;
  final VoidCallback? onSignOut;
  final bool isSigningOut;
  final VoidCallback? onCreateProfile;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 32),
            const SizedBox(height: AppSpacing.space16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: AppSpacing.space20),
            if (onCreateProfile != null) ...[
              ElevatedButton(
                onPressed: onCreateProfile,
                child: const Text('Crear mi perfil ahora'),
              ),
              const SizedBox(height: AppSpacing.space16),
            ],
            Wrap(
              alignment: WrapAlignment.center,
              spacing: AppSpacing.space12,
              runSpacing: AppSpacing.space12,
              children: [
                OutlinedButton(onPressed: onRetry, child: const Text('Reintentar')),
                if (onSignOut != null)
                  TextButton(
                    onPressed: isSigningOut ? null : onSignOut,
                    child: isSigningOut
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.textMuted,
                            ),
                          )
                        : const Text('Cerrar sesión'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}