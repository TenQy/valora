import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/valora_searchable_dropdown.dart';
import '../models/catalog_models.dart';

class AddCompetencyDialog extends StatefulWidget {
  const AddCompetencyDialog({
    super.key,
    required this.availableCompetencies,
    this.selectedAreaId,
  });

  final List<CompetencyItem> availableCompetencies;
  final String? selectedAreaId;

  @override
  State<AddCompetencyDialog> createState() => _AddCompetencyDialogState();
}

class _AddCompetencyDialogState extends State<AddCompetencyDialog> {
  CompetencyItem? selectedComp;
  String selectedLevel = 'Básico';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.bgSurface,
      title: const Text('Agregar Competencia', style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValoraSearchableDropdown<CompetencyItem>(
              label: 'Competencia',
              value: selectedComp,
              items: widget.availableCompetencies,
              itemLabel: (comp) => comp.name,
              itemSubLabel: (comp) => comp.category ?? '',
              onChanged: (val) => setState(() => selectedComp = val),
              defaultFilter: widget.selectedAreaId != null
                  ? (comp) => comp.relatedAreaIds.contains(widget.selectedAreaId)
                  : null,
            ),
            if (selectedComp == null || selectedComp!.requiresLevel) ...[
              const SizedBox(height: AppSpacing.space16),
              ValoraSearchableDropdown<String>(
                label: 'Nivel de dominio',
                value: selectedLevel,
                items: const ['Básico', 'Intermedio', 'Avanzado'],
                itemLabel: (lvl) => lvl,
                onChanged: (val) => setState(() => selectedLevel = val ?? 'Básico'),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: selectedComp == null
              ? null
              : () {
                  final result = EditableUserCompetency(
                    competencyId: selectedComp!.id,
                    name: selectedComp!.name,
                    level: selectedComp!.requiresLevel ? selectedLevel : 'N/A',
                    requiresLevel: selectedComp!.requiresLevel,
                  );
                  Navigator.of(context).pop(result);
                },
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}
