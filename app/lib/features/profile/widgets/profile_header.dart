import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
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
  bool _bioExpanded = false;

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
            OutlinedButton(
              onPressed: widget.onEditPressed,
              child: const Text('Editar perfil'),
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
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.topLeft,
          child: Text(
            profile.bio,
            style: AppTextStyles.body.copyWith(fontSize: 13),
            maxLines: _bioExpanded ? null : 3,
            overflow: _bioExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _bioExpanded = !_bioExpanded),
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.space4),
            child: Text(
              _bioExpanded ? 'ver menos' : 'ver más',
              style: AppTextStyles.hint.copyWith(
                color: AppColors.textMuted,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
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