import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/profile_models.dart';
import '../../../shared/widgets/app_card.dart';

/// Card pequeña para una certificación dentro del perfil.
class CertificationTile extends StatelessWidget {
  const CertificationTile({super.key, required this.certification});

  final UserCertification certification;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.space16),
      child: Row(
        children: [
          const Icon(Icons.verified_outlined, size: 18, color: AppColors.silverMuted),
          const SizedBox(width: AppSpacing.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  certification.name,
                  style: AppTextStyles.compactBody.copyWith(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.space4),
                Text(
                  '${certification.issuer} · ${certification.issueDate}',
                  style: AppTextStyles.hint,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}