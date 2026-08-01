import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/animated_app_background.dart';
import '../../../shared/widgets/section_label.dart';
import '../../../shared/widgets/valora_app_bar.dart';
import '../../../shared/widgets/valora_searchable_dropdown.dart';
import '../../profile/models/catalog_models.dart';
import '../../profile/services/profile_repository.dart';
import '../../profile/utils/level_utils.dart';
import '../../profile/widgets/add_competency_dialog.dart';
import 'guest_result_screen.dart';

class GuestEstimationScreen extends StatefulWidget {
  const GuestEstimationScreen({super.key});

  @override
  State<GuestEstimationScreen> createState() => _GuestEstimationScreenState();
}

class _GuestEstimationScreenState extends State<GuestEstimationScreen> {
  final _repository = ProfileRepository(Supabase.instance.client);
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = true;
  bool _isEstimating = false;
  String? _errorMessage;

  String? _selectedAreaId;
  String _selectedProfessionalLevel = 'Estudiante';
  
  List<ProfessionalAreaItem> _areas = [];
  List<CompetencyItem> _competenciesCatalog = [];
  List<EditableUserCompetency> _selectedCompetencies = [];

  List<String> get _currentLevelOptions {
    final areaName = _selectedAreaId != null
        ? _areas.cast<ProfessionalAreaItem?>().firstWhere(
              (a) => a?.id == _selectedAreaId,
              orElse: () => null,
            )?.name
        : null;
    return LevelUtils.getLevelsForArea(areaName);
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Estas llamadas usarán las políticas anon (públicas) gracias a la migración
      final areas = await _repository.fetchProfessionalAreas();
      final competencies = await _repository.fetchCompetencies();

      if (!mounted) return;
      setState(() {
        _areas = areas;
        _competenciesCatalog = competencies;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error al cargar los catálogos. Intenta de nuevo.';
        _isLoading = false;
      });
    }
  }

  void _showAddCompetencyDialog() async {
    final availableCompetencies = _competenciesCatalog.where((cat) {
      return !_selectedCompetencies.any((sc) => sc.competencyId == cat.id);
    }).toList();

    final result = await showDialog<EditableUserCompetency>(
      context: context,
      builder: (context) => AddCompetencyDialog(
        availableCompetencies: availableCompetencies,
        selectedAreaId: _selectedAreaId,
      ),
    );
    
    if (!mounted) return;
    FocusScope.of(context).unfocus();

    if (result != null) {
      setState(() => _selectedCompetencies.add(result));
    }
  }

  Future<void> _submitEstimation() async {
    if (!_formKey.currentState!.validate()) {
      if (_selectedAreaId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, selecciona un área profesional.'),
            backgroundColor: AppColors.colorWarning,
          ),
        );
      }
      return;
    }

    setState(() => _isEstimating = true);

    try {
      final selectedAreaObj = _areas.firstWhere((a) => a.id == _selectedAreaId);

      // Crear el payload del guest
      final guestProfile = {
        'level': _selectedProfessionalLevel,
        'years_experience': 0, // Simplificado para invitados
        'area_name': selectedAreaObj.name,
        'competencies': _selectedCompetencies.map((c) => {
          'name': c.name,
          'level': c.level,
          'requires_level': c.requiresLevel
        }).toList(),
      };

      final response = await Supabase.instance.client.functions.invoke(
        'estimate-salary',
        body: {'guest_profile': guestProfile},
      );

      if (response.status != 200 || response.data == null) {
        throw Exception('Error en el cálculo. Intenta de nuevo.');
      }

      final data = response.data as Map<String, dynamic>;

      if (!mounted) return;

      final prefs = await SharedPreferences.getInstance();
      final guestResult = {
        'estimated_min_salary': data['estimated_min_salary'],
        'estimated_max_salary': data['estimated_max_salary'],
        'currency': data['currency'],
        'professional_level': data['professional_level'],
        'summary': data['summary'],
        'professional_area_id': _selectedAreaId,
        'competencies': _selectedCompetencies.map((c) => {
          'competency_id': c.competencyId,
          'name': c.name,
          'level': c.level,
          'requires_level': c.requiresLevel,
        }).toList(),
      };
      await prefs.setString('guest_estimation_result', jsonEncode(guestResult));

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => GuestResultScreen(
            estimatedMinSalary: data['estimated_min_salary'] as int,
            estimatedMaxSalary: data['estimated_max_salary'] as int,
            currency: data['currency'] as String,
            level: data['professional_level'] as String,
            summary: data['summary'] as String,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.colorError),
      );
    } finally {
      if (mounted) setState(() => _isEstimating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedAreaObj = _selectedAreaId != null
        ? _areas.cast<ProfessionalAreaItem?>().firstWhere(
              (a) => a?.id == _selectedAreaId,
              orElse: () => null,
            )
        : null;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      extendBodyBehindAppBar: true,
      appBar: const ValoraAppBar(
        showBackButton: true,
        title: 'Estimación Rápida',
      ),
      body: AnimatedAppBackground(
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.silver))
              : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_errorMessage!, style: const TextStyle(color: AppColors.colorError)),
                          const SizedBox(height: AppSpacing.space16),
                          OutlinedButton(onPressed: _loadData, child: const Text('Reintentar')),
                        ],
                      ),
                    )
                  : Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSpacing.space24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Con unos pocos datos, nuestro modelo calculará tu valor actual en el mercado laboral.',
                              style: TextStyle(color: AppColors.silverMuted, fontSize: 14),
                            ),
                            const SizedBox(height: AppSpacing.space32),
                            
                            SectionLabel('Información General'),
                            const SizedBox(height: AppSpacing.space16),

                            ValoraSearchableDropdown<ProfessionalAreaItem>(
                              label: 'Área Profesional',
                              value: selectedAreaObj,
                              items: _areas,
                              itemLabel: (area) => area.name,
                              onChanged: (area) => setState(() => _selectedAreaId = area?.id),
                              validator: (v) => v == null ? 'Requerido' : null,
                            ),
                            const SizedBox(height: AppSpacing.space16),

                            ValoraSearchableDropdown<String>(
                              label: 'Nivel Profesional',
                              value: _selectedProfessionalLevel,
                              items: _currentLevelOptions,
                              itemLabel: (lvl) => lvl,
                              onChanged: (lvl) =>
                                  setState(() => _selectedProfessionalLevel = lvl ?? 'Estudiante'),
                            ),
                            
                            const SizedBox(height: AppSpacing.space32),
                            SectionLabel('Competencias Clave (Opcional)'),
                            const SizedBox(height: AppSpacing.space12),

                            if (_selectedCompetencies.isEmpty)
                              const Text(
                                'Puedes agregar competencias tecnológicas para mejorar la precisión del cálculo.',
                                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                              )
                            else
                              Wrap(
                                spacing: AppSpacing.space8,
                                runSpacing: AppSpacing.space8,
                                children: [
                                  for (final comp in _selectedCompetencies)
                                    Chip(
                                      backgroundColor: AppColors.bgSurface,
                                      side: const BorderSide(color: AppColors.borderSubtle),
                                      label: Text(
                                        comp.requiresLevel
                                            ? '${comp.name} (${comp.level})'
                                            : comp.name,
                                        style: const TextStyle(color: Colors.white, fontSize: 13),
                                      ),
                                      onDeleted: () {
                                        setState(() {
                                          _selectedCompetencies.remove(comp);
                                        });
                                      },
                                      deleteIconColor: AppColors.textMuted,
                                    ),
                                ],
                              ),
                            const SizedBox(height: AppSpacing.space12),

                            OutlinedButton.icon(
                              onPressed: _showAddCompetencyDialog,
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Agregar competencia'),
                            ),

                            const SizedBox(height: AppSpacing.space48),

                            ElevatedButton(
                              onPressed: _isEstimating ? null : _submitEstimation,
                              child: _isEstimating
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Text('Calcular mi valor real'),
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
