import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/profile_models.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/skill_chip.dart';

/// Card pequeña para un proyecto dentro del perfil: título, descripción
/// breve y stack de competencias utilizadas. Ver UI_GUIDELINES.md §7.5.
class ProjectTile extends StatelessWidget {
  const ProjectTile({super.key, required this.project});

  final UserProject project;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.name,
            style: AppTextStyles.compactBody.copyWith(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          Text(
            project.description,
            style: AppTextStyles.compactBody,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.space12),
          Wrap(
            spacing: AppSpacing.space8,
            runSpacing: AppSpacing.space8,
            children: [
              for (final competency in project.competencies) SkillChip(competency),
            ],
          ),
        ],
      ),
    );
  }
}