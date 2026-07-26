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
  final _platformsController = TextEditingController();

  String _projectType = 'Personal';
  String _complexity = 'Media';

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
        platforms: _platformsController.text.trim(),
        selectedCompetencies: _selectedCompetencies,
      );
      
      // Trigger Fase 10: Calcular Valor Económico del Proyecto
      try {
        await Supabase.instance.client.functions.invoke(
          'project-value',
          body: {'project_id': projectId},
        );
      } catch (e) {
        debugPrint('Error calculando valor del proyecto: $e');
        // Ignoramos el error para no bloquear el flujo, 
        // el usuario igual guardó su proyecto.
      }

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
      builder: (context) {
        return ListView.builder(
          itemCount: _availableCompetencies.length,
          itemBuilder: (context, index) {
            final comp = _availableCompetencies[index];
            final isSelected = _selectedCompetencies.contains(comp);
            return ListTile(
              title: Text(comp.name, style: const TextStyle(color: Colors.white)),
              trailing: isSelected ? const Icon(Icons.check, color: AppColors.silver) : null,
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedCompetencies.remove(comp);
                  } else {
                    _selectedCompetencies.add(comp);
                  }
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      DropdownButtonFormField<String>(
                        value: _projectType,
                        decoration: const InputDecoration(labelText: 'Tipo de Proyecto'),
                        dropdownColor: AppColors.bgSurface,
                        items: ['Personal', 'Académico', 'Empresa', 'Freelance', 'Open Source']
                            .map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(color: Colors.white))))
                            .toList(),
                        onChanged: (v) => setState(() => _projectType = v!),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _complexity,
                        decoration: const InputDecoration(labelText: 'Nivel de Complejidad'),
                        dropdownColor: AppColors.bgSurface,
                        items: ['Baja', 'Media', 'Alta']
                            .map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(color: Colors.white))))
                            .toList(),
                        onChanged: (v) => setState(() => _complexity = v!),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _timeController,
                        decoration: const InputDecoration(labelText: 'Tiempo Estimado (ej. 3 meses)'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _platformsController,
                        decoration: const InputDecoration(labelText: 'Entregables o Plataformas (ej. Web, iOS, Identidad Visual, Reporte)'),
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
    );
  }
}
