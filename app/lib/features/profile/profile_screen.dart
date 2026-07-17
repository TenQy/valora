import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import 'models/profile_models.dart';
import 'widgets/certification_tile.dart';
import 'widgets/profile_header.dart';
import 'widgets/project_tile.dart';
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
        Wrap(
          spacing: AppSpacing.space8,
          runSpacing: AppSpacing.space8,
          children: [
            for (final competency in profile.competencies)
              SkillChip(competency.name),
          ],
        ),
        const SizedBox(height: AppSpacing.space32),
        _Divider(),
        const SizedBox(height: AppSpacing.space32),

        SectionLabel('Idiomas'),
        const SizedBox(height: AppSpacing.space16),
        Wrap(
          spacing: AppSpacing.space8,
          runSpacing: AppSpacing.space8,
          children: [
            for (final language in profile.languages)
              LanguageChip(
                flagEmoji: language.flagEmoji,
                language: language.language,
                level: language.level,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.space32),
        _Divider(),
        const SizedBox(height: AppSpacing.space32),

        SectionLabel('Certificaciones'),
        const SizedBox(height: AppSpacing.space16),
        if (profile.certifications.isEmpty)
          _EmptyState(text: 'Aún no has agregado certificaciones.')
        else
          Column(
            children: [
              for (final certification in profile.certifications) ...[
                CertificationTile(certification: certification),
                const SizedBox(height: AppSpacing.space12),
              ],
            ],
          ),
        const SizedBox(height: AppSpacing.space20),
        _Divider(),
        const SizedBox(height: AppSpacing.space32),

        SectionLabel('Proyectos'),
        const SizedBox(height: AppSpacing.space16),
        if (profile.projects.isEmpty)
          _EmptyState(text: 'Aún no has agregado proyectos.')
        else
          Column(
            children: [
              for (final project in profile.projects) ...[
                ProjectTile(project: project),
                const SizedBox(height: AppSpacing.space12),
              ],
            ],
          ),
        const SizedBox(height: AppSpacing.space32),

        Center(
          child: TextButton(
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
        ),
        const SizedBox(height: AppSpacing.space24),
      ],
    );
  }
}

/// Pantalla de Perfil standalone, con `Scaffold` y `AppBar` propios.
/// Útil si en el futuro se navega directo a Perfil fuera del bottom nav
/// del Dashboard (ej. desde un deep link o desde otra pantalla).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(title: const Text('Perfil')),
      body: SafeArea(
        child: ProfileContent(
          onEditPressed: () {
            // TODO: navegar a Editar Perfil.
          },
          onSignOut: () {
            // TODO: cerrar sesión (Supabase Auth signOut).
          },
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