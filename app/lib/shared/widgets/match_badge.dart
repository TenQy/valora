import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class MatchBadge extends StatelessWidget {
  final String label;
  final bool hasIt;

  const MatchBadge({super.key, required this.label, required this.hasIt});

  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 64),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: hasIt ? AppColors.colorSuccess.withValues(alpha: 0.1) : AppColors.silver.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasIt ? AppColors.colorSuccess.withValues(alpha: 0.2) : AppColors.silver.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasIt ? Icons.check_circle : Icons.arrow_upward,
            size: 14,
            color: hasIt ? AppColors.colorSuccess : AppColors.silver,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: hasIt ? AppColors.colorSuccess : AppColors.silver,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
