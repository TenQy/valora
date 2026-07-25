import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/valora_searchable_dropdown.dart';
import '../models/catalog_models.dart';

class AddLanguageDialog extends StatefulWidget {
  const AddLanguageDialog({
    super.key,
    required this.availableLanguages,
    required this.levelsCatalog,
  });

  final List<LanguageItem> availableLanguages;
  final List<LanguageLevelItem> levelsCatalog;

  @override
  State<AddLanguageDialog> createState() => _AddLanguageDialogState();
}

class _AddLanguageDialogState extends State<AddLanguageDialog> {
  LanguageItem? selectedLang;
  LanguageLevelItem? selectedLevel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.bgSurface,
      title: const Text('Agregar Idioma', style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValoraSearchableDropdown<LanguageItem>(
              label: 'Idioma',
              value: selectedLang,
              items: widget.availableLanguages,
              itemLabel: (lang) => lang.name,
              onChanged: (val) => setState(() => selectedLang = val),
            ),
            const SizedBox(height: AppSpacing.space16),
            ValoraSearchableDropdown<LanguageLevelItem>(
              label: 'Nivel',
              value: selectedLevel,
              items: widget.levelsCatalog,
              itemLabel: (lvl) => lvl.name,
              itemSubLabel: (lvl) => lvl.description ?? '',
              onChanged: (val) => setState(() => selectedLevel = val),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: (selectedLang == null || selectedLevel == null)
              ? null
              : () {
                  final result = EditableUserLanguage(
                    languageId: selectedLang!.id,
                    languageName: selectedLang!.name,
                    languageLevelId: selectedLevel!.id,
                    levelName: selectedLevel!.name,
                  );
                  Navigator.of(context).pop(result);
                },
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}
