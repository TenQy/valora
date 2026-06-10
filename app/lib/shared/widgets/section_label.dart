import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label.toUpperCase(), style: AppTextStyles.sectionLabel);
  }
}
