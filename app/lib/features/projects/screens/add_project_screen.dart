import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
      builder: (context) {
        return _CompetenciesPickerModal(
          available: _availableCompetencies,
          selected: _selectedCompetencies,
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
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showPlatformsPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgSurface,
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
            Navigator.pop(context);
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
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
                      SectionLabel('Entregables o Plataformas'),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final plat in _selectedPlatforms)
                            Chip(
                              backgroundColor: AppColors.bgSurface,
                              label: Text(plat, style: const TextStyle(color: Colors.white, fontSize: 13)),
                              deleteIconColor: AppColors.textMuted,
                              onDeleted: () => setState(() => _selectedPlatforms.remove(plat)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _showPlatformsPicker,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Agregar Entregable / Plataforma'),
                      ),
                      const SizedBox(height: 32),
                      SectionLabel('Competencias / Herramientas Aplicadas'),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final comp in _selectedCompetencies)
                            Chip(
                              backgroundColor: AppColors.bgSurface,
                              label: Text(comp.name, style: const TextStyle(color: Colors.white, fontSize: 13)),
                              deleteIconColor: AppColors.textMuted,
                              onDeleted: () => setState(() => _selectedCompetencies.remove(comp)),
                            ),
                        ],
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
    );
  }
}

class _CompetenciesPickerModal extends StatefulWidget {
  final List<CompetencyItem> available;
  final List<CompetencyItem> selected;
  final Function(CompetencyItem, bool) onSelectionChanged;

  const _CompetenciesPickerModal({
    required this.available,
    required this.selected,
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
    _filtered = widget.available;
    _searchController.addListener(_filter);
  }

  void _filter() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtered = widget.available.where((c) => c.name.toLowerCase().contains(query)).toList();
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(comp.name, style: const TextStyle(color: Colors.white)),
                  trailing: isSelected ? const Icon(Icons.check, color: AppColors.silver) : null,
                  onTap: () => widget.onSelectionChanged(comp, true),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _PlatformsPickerModal extends StatelessWidget {
  final List<String> available;
  final List<String> selected;
  final Function(String, bool) onSelectionChanged;

  const _PlatformsPickerModal({
    required this.available,
    required this.selected,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Seleccionar Plataforma', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: available.length,
              itemBuilder: (context, index) {
                final plat = available[index];
                final isSelected = selected.contains(plat);
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(plat, style: const TextStyle(color: Colors.white)),
                  trailing: isSelected ? const Icon(Icons.check, color: AppColors.silver) : null,
                  onTap: () => onSelectionChanged(plat, true),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
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
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (context, index) {
                final opt = options[index];
                final isSelected = opt == selectedValue;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(opt, style: const TextStyle(color: Colors.white)),
                  trailing: isSelected ? const Icon(Icons.check, color: AppColors.silver) : null,
                  onTap: () => onSelected(opt),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
