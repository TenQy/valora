import 'package:flutter/material.dart';

import 'app_badge.dart';

class MatchBadge extends StatelessWidget {
  const MatchBadge({required this.percentage, super.key});

  final int percentage;

  @override
  Widget build(BuildContext context) {
    return AppBadge(
      label: '$percentage% match',
      variant: percentage >= 80
          ? AppBadgeVariant.green
          : AppBadgeVariant.silver,
    );
  }
}
