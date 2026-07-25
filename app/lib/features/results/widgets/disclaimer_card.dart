import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class DisclaimerCard extends StatelessWidget {
  const DisclaimerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space16),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            size: 16,
            color: AppColors.silverMuted,
          ),
          const SizedBox(width: AppSpacing.space12),
          Expanded(
            child: Text(
              'Este resultado es orientativo, calculado mediante el análisis de tu perfil, competencias e idiomas registrados en el mercado laboral.',
              style: AppTextStyles.hint,
            ),
          ),
        ],
      ),
    );
  }
}
