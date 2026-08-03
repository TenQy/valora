import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';

/// Label uppercase usado como encabezado de sección
/// (ej. "COMPETENCIAS", "IDIOMAS"). Ver UI_GUIDELINES.md §7.5.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(text.toUpperCase(), style: AppTextStyles.sectionLabel),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}