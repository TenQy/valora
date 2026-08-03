import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/expandable_text.dart';
import '../models/profile_models.dart';

/// Header de la pantalla de Perfil: nombre, área profesional, badges de
/// nivel/experiencia, bio (máx. 3 líneas con "ver más") y botón de editar.
/// Ver UI_GUIDELINES.md §7.5.
class ProfileHeader extends StatefulWidget {
  const ProfileHeader({
    super.key,
    required this.profile,
    required this.onEditPressed,
  });

  final ProfessionalProfile profile;
  final VoidCallback onEditPressed;

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(profile.fullName, style: AppTextStyles.userName.copyWith(
                    fontSize: 18,
                    color: AppColors.textPrimary,
                  )),
                  const SizedBox(height: AppSpacing.space4),
                  Text(
                    profile.professionalArea,
                    style: AppTextStyles.compactBody.copyWith(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: widget.onEditPressed,
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Editar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.silver,
                side: const BorderSide(color: AppColors.borderDefault),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.space16),
        Wrap(
          spacing: AppSpacing.space8,
          runSpacing: AppSpacing.space8,
          children: [
            _SilverBadge(profile.professionalLevel),
            if (profile.yearsExperience != null)
              _SilverBadge(
                profile.yearsExperience == 1
                    ? '1 año de experiencia'
                    : '${profile.yearsExperience} años de experiencia',
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.space16),
        ExpandableText(
          text: profile.bio,
          maxLines: 3,
          style: AppTextStyles.body.copyWith(fontSize: 13),
        ),
      ],
    );
  }
}

class _SilverBadge extends StatelessWidget {
  const _SilverBadge(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space12,
        vertical: AppSpacing.space4,
      ),
      decoration: BoxDecoration(
        color: AppColors.silverSubtle,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Text(
        label,
        style: AppTextStyles.compactBody.copyWith(
          fontSize: 11,
          color: AppColors.silverMuted,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}