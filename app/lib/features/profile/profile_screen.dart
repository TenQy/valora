import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'edit_profile_screen.dart';
import 'profile_tab.dart';
import 'security_settings_screen.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import 'models/profile_models.dart';
import 'widgets/certification_tile.dart';
import 'widgets/profile_header.dart';

import '../../../shared/widgets/language_chip.dart';
import '../../../shared/widgets/section_label.dart';
import '../../../shared/widgets/skill_chip.dart';

/// Contenido de la pantalla de Perfil (§5 de FEATURES.md): nombre, área,
/// nivel, experiencia, bio, competencias, idiomas, certificaciones,
/// proyectos y cierre de sesión.
///
/// Deliberadamente NO tiene `Scaffold` ni `AppBar` propios, para poder
/// embeberse como tab dentro de `DashboardScreen` (que ya provee su propio
/// AppBar y BottomNavigationBar, ver UI_GUIDELINES.md §6.8) sin duplicarlos.
/// Para navegación standalone (fuera del bottom nav) usar [ProfileScreen].
///
/// Por ahora usa `ProfessionalProfile.mock()` si no se provee `profile`.
/// Al conectar con Supabase, este dato debe venir de `GET /profiles/me`
/// (API_CONTRACT.md) junto con las consultas relacionadas.
class ProfileContent extends StatelessWidget {
  ProfileContent({
    super.key,
    ProfessionalProfile? profile,
    required this.onEditPressed,
    required this.onSignOut,
    this.isSigningOut = false,
  }) : profile = profile ?? ProfessionalProfile.mock();

  final ProfessionalProfile profile;
  final VoidCallback onEditPressed;
  final VoidCallback onSignOut;
  final bool isSigningOut;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space24,
        vertical: AppSpacing.space24,
      ),
      children: [
        ProfileHeader(profile: profile, onEditPressed: onEditPressed),
        const SizedBox(height: AppSpacing.space32),
        _Divider(),
        const SizedBox(height: AppSpacing.space32),

        SectionLabel('Competencias'),
        const SizedBox(height: AppSpacing.space16),
        _buildLimitedWrap(
          context: context,
          items: profile.competencies,
          title: 'competencias',
          builder: (c) => SkillChip(c.name),
        ),
        const SizedBox(height: AppSpacing.space32),
        _Divider(),
        const SizedBox(height: AppSpacing.space32),

        SectionLabel('Idiomas'),
        const SizedBox(height: AppSpacing.space16),
        _buildLimitedWrap(
          context: context,
          items: profile.languages,
          title: 'idiomas',
          builder: (l) => LanguageChip(
            flagEmoji: l.flagEmoji,
            language: l.language,
            level: l.level,
          ),
        ),
        const SizedBox(height: AppSpacing.space32),
        _Divider(),
        const SizedBox(height: AppSpacing.space32),

        SectionLabel('Certificaciones'),
        const SizedBox(height: AppSpacing.space16),
        _buildLimitedColumn(
          context: context,
          items: profile.certifications,
          title: 'certificaciones',
          builder: (c) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.space12),
            child: CertificationTile(certification: c),
          ),
        ),
        const SizedBox(height: AppSpacing.space20),
        _Divider(),
        const SizedBox(height: AppSpacing.space32),

        Center(
          child: TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecuritySettingsScreen()),
              );
            },
            icon: const Icon(Icons.security, size: 18),
            label: const Text('Seguridad y Privacidad'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.silverMuted,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.space16),

        Center(
          child: TextButton.icon(
            onPressed: isSigningOut ? null : onSignOut,
            icon: isSigningOut
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.silverMuted,
                    ),
                  )
                : const Icon(Icons.logout, size: 18),
            label: Text(
              isSigningOut ? 'Cerrando sesión...' : 'Cerrar sesión',
            ),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.colorError.withValues(alpha: 0.8),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.space24),
      ].animate(interval: 50.ms).fade(duration: 400.ms).slideY(begin: 0.05, curve: Curves.easeOut),
    );
  }

  Widget _buildLimitedWrap<T>({
    required BuildContext context,
    required List<T> items,
    required String title,
    required Widget Function(T) builder,
    int limit = 10,
  }) {
    if (items.isEmpty) return _EmptyState(text: 'Aún no has agregado $title.');
    final displayedItems = items.take(limit).toList();
    final hasMore = items.length > limit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.space8,
          runSpacing: AppSpacing.space8,
          children: displayedItems.map(builder).toList(),
        ),
        if (hasMore)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.space12),
            child: TextButton(
              onPressed: () => _showFullListModal(
                context: context,
                title: 'Todas las $title',
                child: Wrap(
                  spacing: AppSpacing.space8,
                  runSpacing: AppSpacing.space8,
                  children: items.map(builder).toList(),
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text('Ver todas (${items.length})', style: const TextStyle(fontSize: 13)),
            ),
          ),
      ],
    );
  }

  Widget _buildLimitedColumn<T>({
    required BuildContext context,
    required List<T> items,
    required String title,
    required Widget Function(T) builder,
    int limit = 10,
  }) {
    if (items.isEmpty) return _EmptyState(text: 'Aún no has agregado $title.');
    final displayedItems = items.take(limit).toList();
    final hasMore = items.length > limit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: displayedItems.map(builder).toList(),
        ),
        if (hasMore)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.space8),
            child: TextButton(
              onPressed: () => _showFullListModal(
                context: context,
                title: 'Todas las $title',
                child: Column(
                  children: items.map(builder).toList(),
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text('Ver todas (${items.length})', style: const TextStyle(fontSize: 13)),
            ),
          ),
      ],
    );
  }

  void _showFullListModal({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.space24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textMuted),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space16),
                Flexible(
                  child: SingleChildScrollView(
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Pantalla de Perfil standalone, con `Scaffold` y `AppBar` propios.
/// Útil si en el futuro se navega directo a Perfil fuera del bottom nav
/// del Dashboard (ej. desde un deep link o desde otra pantalla).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isSigningOut = false;
  Key _tabKey = UniqueKey();

  Future<void> _signOut() async {
    setState(() => _isSigningOut = true);
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (_) {}
    if (mounted) setState(() => _isSigningOut = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(title: const Text('Perfil')),
      body: SafeArea(
        child: ProfileTab(
          key: _tabKey,
          onEditPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const EditProfileScreen(),
              ),
            ).then((_) {
              if (mounted) {
                setState(() => _tabKey = UniqueKey());
              }
            });
          },
          onSignOut: _signOut,
          isSigningOut: _isSigningOut,
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(color: AppColors.borderSubtle, height: 1, thickness: 1);
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
    );
  }
}