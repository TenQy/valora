import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/valora_app_bar.dart';
import '../../../shared/widgets/animated_app_background.dart';
import '../../../shared/widgets/section_label.dart';
import '../../profile/models/catalog_models.dart';
import '../../profile/services/profile_repository.dart';
import '../services/projects_repository.dart';

class AddProjectScreen extends StatefulWidget {
  final String profileId;
  final String professionalAreaId;

  const AddProjectScreen({
    super.key,
    required this.profileId,
    required this.professionalAreaId,
  });

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _repository = ProjectsRepository(Supabase.instance.client);
  final _profileRepo = ProfileRepository(Supabase.instance.client);
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeController = TextEditingController();

  String _projectType = 'Personal';
  String _complexity = 'Media';

  final List<String> _availablePlatforms = [
    'App Móvil', 'Sitio Web', 'API / Backend', 'Dashboard',
    'Identidad Visual', 'Diseño UI/UX', 'Campaña', 'Reporte', 'Plano / 3D', 'Otro'
  ];
  final List<String> _selectedPlatforms = [];

  bool _isLoading = true;
  bool _isSaving = false;

  List<CompetencyItem> _availableCompetencies = [];
  final List<CompetencyItem> _selectedCompetencies = [];

  @override
  void initState() {
    super.initState();
    _loadCompetencies();
  }

  Future<void> _loadCompetencies() async {
    try {
      final comps = await _profileRepo.fetchCompetencies();
      if (mounted) {
        setState(() {
          _availableCompetencies = comps;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProject() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      final projectId = await _repository.addProject(
        profileId: widget.profileId,
        professionalAreaId: widget.professionalAreaId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        projectType: _projectType,
        complexity: _complexity,
        estimatedTime: _timeController.text.trim(),
        platforms: _selectedPlatforms.join(', '),
        selectedCompetencies: _selectedCompetencies,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Proyecto guardado. ¡Ahora calcula su valor!'), backgroundColor: AppColors.colorSuccess),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.colorError),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showCompetenciesPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgSurface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) {
        return _CompetenciesPickerModal(
          available: _availableCompetencies,
          selected: _selectedCompetencies,
          professionalAreaId: widget.professionalAreaId,
          onSelectionChanged: (comp, isSelected) {
            setState(() {
              if (isSelected) {
                // Prevenir duplicados
                if (!_selectedCompetencies.any((c) => c.id == comp.id)) {
                  _selectedCompetencies.add(comp);
                }
              } else {
                _selectedCompetencies.removeWhere((c) => c.id == comp.id);
              }
            });
          },
        );
      },
    );
  }

  void _showPlatformsPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgSurface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) {
        return _PlatformsPickerModal(
          available: _availablePlatforms,
          selected: _selectedPlatforms,
          onSelectionChanged: (plat, isSelected) {
            setState(() {
              if (isSelected) {
                if (!_selectedPlatforms.contains(plat)) {
                  _selectedPlatforms.add(plat);
                }
              } else {
                _selectedPlatforms.remove(plat);
              }
            });
          },
        );
      },
    );
  }

  void _showProjectTypePicker() {
    final types = ['Personal', 'Académico', 'Empresa', 'Freelance', 'Open Source'];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) {
        return _SingleSelectModal(
          title: 'Seleccionar Tipo',
          options: types,
          selectedValue: _projectType,
          onSelected: (val) {
            setState(() => _projectType = val);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showComplexityPicker() {
    final complexities = ['Baja', 'Media', 'Alta'];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) {
        return _SingleSelectModal(
          title: 'Nivel de Complejidad',
          options: complexities,
          selectedValue: _complexity,
          onSelected: (val) {
            setState(() => _complexity = val);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> _confirmDelete(String title, String message, VoidCallback onConfirm) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            style: TextButton.styleFrom(foregroundColor: AppColors.colorError),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      onConfirm();
    }
  }

  void _showAllItemsModal<T>({
    required String title,
    required List<T> items,
    required Widget Function(T item, StateSetter setModalState) builder,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgSurface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setModalState) {
                return SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.space16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                            IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.borderSubtle),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(AppSpacing.space16),
                          itemCount: items.length,
                          itemBuilder: (context, index) => builder(items[index], setModalState),
                        ),
                      ),
                    ],
                  ),
                );
              }
            );
          },
        );
      },
    );
  }

  Widget _buildEditableList<T>({
    required List<T> items,
    required String emptyMessage,
    required String modalTitle,
    required Widget Function(T item, StateSetter? setModalState) builder,
  }) {
    if (items.isEmpty) {
      return Text(emptyMessage, style: const TextStyle(color: AppColors.textMuted, fontSize: 13));
    }
    const limit = 5;
    final visibleItems = items.take(limit).toList();
    return Column(
      children: [
        ...visibleItems.map((i) => builder(i, null)),
        if (items.length > limit)
          TextButton(
            onPressed: () => _showAllItemsModal(
              title: modalTitle,
              items: items,
              builder: (item, setModalState) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.space8),
                child: builder(item, setModalState),
              ),
            ),
            child: Text('Ver todas (${items.length})'),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
      extendBodyBehindAppBar: true,
      appBar: const ValoraAppBar(
        title: 'Agregar Proyecto',
        showBackButton: true,
      ),
      body: AnimatedAppBackground(
        child: SafeArea(
          child: Skeletonizer(
            enabled: _isLoading,
            effect: ShimmerEffect(
              baseColor: AppColors.bgSurface.withValues(alpha: 0.5),
              highlightColor: AppColors.silverSubtle,
            ),
            child: Form(
              key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.space24),
                    children: [
                      SectionLabel('Detalles Principales'),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Nombre del Proyecto (ej. Valora App)'),
                        validator: (v) => v!.isEmpty ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(labelText: 'Descripción corta'),
                        validator: (v) => v!.isEmpty ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        readOnly: true,
                        controller: TextEditingController(text: _projectType),
                        decoration: const InputDecoration(
                          labelText: 'Tipo de Proyecto',
                          suffixIcon: Icon(Icons.arrow_drop_down, color: AppColors.textMuted),
                        ),
                        onTap: _showProjectTypePicker,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        readOnly: true,
                        controller: TextEditingController(text: _complexity),
                        decoration: const InputDecoration(
                          labelText: 'Nivel de Complejidad',
                          suffixIcon: Icon(Icons.arrow_drop_down, color: AppColors.textMuted),
                        ),
                        onTap: _showComplexityPicker,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _timeController,
                        decoration: const InputDecoration(labelText: 'Tiempo Estimado (ej. 3 meses)'),
                      ),
                      const SizedBox(height: 32),
                      SectionLabel(
                        'Entregables o Plataformas',
                        trailing: _selectedPlatforms.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.delete_sweep, color: AppColors.colorError, size: 20),
                                onPressed: () => _confirmDelete(
                                  'Borrar todas',
                                  '¿Estás seguro de que quieres borrar todas las plataformas/entregables?',
                                  () => setState(() => _selectedPlatforms.clear()),
                                ),
                                tooltip: 'Borrar todas',
                              )
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildEditableList<String>(
                        items: _selectedPlatforms,
                        emptyMessage: 'No has agregado plataformas aún.',
                        modalTitle: 'Todas las Plataformas',
                        builder: (plat, setModalState) {
                          return Card(
                            color: AppColors.bgSurface,
                            margin: const EdgeInsets.only(bottom: AppSpacing.space8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                              side: const BorderSide(color: AppColors.borderSubtle),
                            ),
                            child: ListTile(
                              dense: true,
                              title: Text(plat, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.colorError),
                                onPressed: () => _confirmDelete(
                                  'Borrar entregable',
                                  '¿Deseas eliminar $plat?',
                                  () {
                                    setState(() => _selectedPlatforms.remove(plat));
                                    if (setModalState != null) setModalState(() {});
                                  }
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _showPlatformsPicker,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Agregar Entregable / Plataforma'),
                      ),
                      const SizedBox(height: 32),
                      SectionLabel(
                        'Competencias / Herramientas Aplicadas',
                        trailing: _selectedCompetencies.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.delete_sweep, color: AppColors.colorError, size: 20),
                                onPressed: () => _confirmDelete(
                                  'Borrar todas',
                                  '¿Estás seguro de que quieres borrar todas las competencias?',
                                  () => setState(() => _selectedCompetencies.clear()),
                                ),
                                tooltip: 'Borrar todas',
                              )
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildEditableList<CompetencyItem>(
                        items: _selectedCompetencies,
                        emptyMessage: 'No has agregado competencias aún.',
                        modalTitle: 'Todas tus Competencias',
                        builder: (comp, setModalState) {
                          return Card(
                            color: AppColors.bgSurface,
                            margin: const EdgeInsets.only(bottom: AppSpacing.space8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                              side: const BorderSide(color: AppColors.borderSubtle),
                            ),
                            child: ListTile(
                              dense: true,
                              title: Text(comp.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.colorError),
                                onPressed: () => _confirmDelete(
                                  'Borrar competencia',
                                  '¿Deseas eliminar ${comp.name}?',
                                  () {
                                    setState(() => _selectedCompetencies.remove(comp));
                                    if (setModalState != null) setModalState(() {});
                                  }
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _showCompetenciesPicker,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Agregar Competencia'),
                      ),
                      const SizedBox(height: 48),
                      ElevatedButton(
                        onPressed: _isSaving ? null : _saveProject,
                        child: _isSaving
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Guardar Proyecto'),
                      ),
                    ],
                  ),
                ),
              ),
        ),
      ),
    ),
    );
  }
}

class _CompetenciesPickerModal extends StatefulWidget {
  final List<CompetencyItem> available;
  final List<CompetencyItem> selected;
  final String professionalAreaId;
  final Function(CompetencyItem, bool) onSelectionChanged;

  const _CompetenciesPickerModal({
    required this.available,
    required this.selected,
    required this.professionalAreaId,
    required this.onSelectionChanged,
  });

  @override
  State<_CompetenciesPickerModal> createState() => _CompetenciesPickerModalState();
}

class _CompetenciesPickerModalState extends State<_CompetenciesPickerModal> {
  final _searchController = TextEditingController();
  List<CompetencyItem> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filter();
    _searchController.addListener(_filter);
  }

  String _removeDiacritics(String str) {
    const withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    const withoutDia = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';
    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }
    return str;
  }

  void _filter() {
    final query = _removeDiacritics(_searchController.text.toLowerCase());
    setState(() {
      if (query.isEmpty) {
        _filtered = widget.available
            .where((c) => c.relatedAreaIds.contains(widget.professionalAreaId))
            .toList();
      } else {
        _filtered = widget.available
            .where((c) => _removeDiacritics(c.name.toLowerCase()).contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
        left: 24,
        right: 24,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Competencias', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Listo', style: TextStyle(color: AppColors.silver)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar competencia...',
                prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filtered.length,
                itemBuilder: (context, index) {
                  final comp = _filtered[index];
                  final isSelected = widget.selected.any((c) => c.id == comp.id);
                  return CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(comp.name, style: const TextStyle(color: Colors.white)),
                    value: isSelected,
                    activeColor: AppColors.green,
                    checkColor: AppColors.bgSurface,
                    side: const BorderSide(color: AppColors.textMuted),
                    onChanged: (bool? checked) {
                      if (checked != null) {
                        widget.onSelectionChanged(comp, checked);
                        setState(() {});
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _PlatformsPickerModal extends StatefulWidget {
  final List<String> available;
  final List<String> selected;
  final Function(String, bool) onSelectionChanged;

  const _PlatformsPickerModal({
    required this.available,
    required this.selected,
    required this.onSelectionChanged,
  });

  @override
  State<_PlatformsPickerModal> createState() => _PlatformsPickerModalState();
}

class _PlatformsPickerModalState extends State<_PlatformsPickerModal> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Plataformas', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Listo', style: TextStyle(color: AppColors.silver)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.available.length,
                itemBuilder: (context, index) {
                  final plat = widget.available[index];
                  final isSelected = widget.selected.contains(plat);
                  return CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(plat, style: const TextStyle(color: Colors.white)),
                    value: isSelected,
                    activeColor: AppColors.green,
                    checkColor: AppColors.bgSurface,
                    side: const BorderSide(color: AppColors.textMuted),
                    onChanged: (bool? checked) {
                      if (checked != null) {
                        widget.onSelectionChanged(plat, checked);
                        setState(() {});
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SingleSelectModal extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selectedValue;
  final Function(String) onSelected;

  const _SingleSelectModal({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.space16),
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: options.map((opt) {
                final isSelected = opt == selectedValue;
                return ListTile(
                  title: Text(opt, style: TextStyle(color: isSelected ? AppColors.green : Colors.white)),
                  trailing: isSelected ? const Icon(Icons.check, color: AppColors.green) : null,
                  onTap: () => onSelected(opt),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
