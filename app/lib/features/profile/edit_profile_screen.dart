import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/section_label.dart';
import '../../shared/widgets/valora_app_bar.dart';
import 'models/catalog_models.dart';
import 'services/profile_repository.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _repository = ProfileRepository(Supabase.instance.client);
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  // Controllers & Form State
  late final TextEditingController _fullNameController;
  late final TextEditingController _careerController;
  late final TextEditingController _yearsExperienceController;
  late final TextEditingController _bioController;

  String? _selectedAreaId;
  String _selectedProfessionalLevel = 'Junior';

  // Catalogs
  List<ProfessionalAreaItem> _areas = [];
  List<CompetencyItem> _competenciesCatalog = [];
  List<LanguageItem> _languagesCatalog = [];
  List<LanguageLevelItem> _languageLevelsCatalog = [];

  // Selected editable items
  List<EditableUserCompetency> _selectedCompetencies = [];
  List<EditableUserLanguage> _selectedLanguages = [];
  List<EditableUserCertification> _selectedCertifications = [];

  static const _levelOptions = [
    'Estudiante',
    'Practicante',
    'Junior',
    'Semi Senior',
    'Senior',
    'Especialista',
  ];

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _careerController = TextEditingController();
    _yearsExperienceController = TextEditingController();
    _bioController = TextEditingController();

    _loadData();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _careerController.dispose();
    _yearsExperienceController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. Load Catalogs
      final areas = await _repository.fetchProfessionalAreas();
      final competencies = await _repository.fetchCompetencies();
      final languages = await _repository.fetchLanguages();
      final levels = await _repository.fetchLanguageLevels();

      // 2. Load Raw Profile Data if available
      final rawProfile = await _repository.fetchRawProfileForEditing();

      if (!mounted) return;

      setState(() {
        _areas = areas;
        _competenciesCatalog = competencies;
        _languagesCatalog = languages;
        _languageLevelsCatalog = levels;

        if (rawProfile != null) {
          _fullNameController.text = rawProfile['full_name'] as String? ?? '';
          _selectedAreaId = rawProfile['professional_area_id'] as String?;
          _careerController.text = rawProfile['career'] as String? ?? '';

          final level = rawProfile['professional_level'] as String?;
          if (level != null && _levelOptions.contains(level)) {
            _selectedProfessionalLevel = level;
          }

          final yrs = rawProfile['years_experience'];
          _yearsExperienceController.text = yrs != null ? yrs.toString() : '';
          _bioController.text = rawProfile['bio'] as String? ?? '';

          // Raw competencies
          if (rawProfile['user_competencies'] is List) {
            final rawCompList = rawProfile['user_competencies'] as List;
            _selectedCompetencies = rawCompList.map((item) {
              final compObj = item['competencies'] as Map<String, dynamic>?;
              return EditableUserCompetency(
                competencyId: item['competency_id'] as String,
                name: compObj?['name'] as String? ?? '—',
                level: item['level'] as String? ?? 'Básico',
              );
            }).toList();
          }

          // Raw languages
          if (rawProfile['user_languages'] is List) {
            final rawLangList = rawProfile['user_languages'] as List;
            _selectedLanguages = rawLangList.map((item) {
              final langObj = item['languages'] as Map<String, dynamic>?;
              final levelObj = item['language_levels'] as Map<String, dynamic>?;
              return EditableUserLanguage(
                languageId: item['language_id'] as String,
                languageName: langObj?['name'] as String? ?? '—',
                languageLevelId: item['language_level_id'] as String,
                levelName: levelObj?['name'] as String? ?? '—',
              );
            }).toList();
          }

          // Raw certifications
          if (rawProfile['certifications'] is List) {
            final rawCertList = rawProfile['certifications'] as List;
            _selectedCertifications = rawCertList.map((item) {
              return EditableUserCertification(
                id: item['id'] as String?,
                name: item['name'] as String? ?? '',
                issuer: item['issuer'] as String? ?? '',
                issueDate: item['issue_date'] as String? ?? '',
              );
            }).toList();
          }
        } else {
          // Pre-fill user's metadata name if new profile
          final currentUser = Supabase.instance.client.auth.currentUser;
          if (currentUser != null) {
            _fullNameController.text =
                currentUser.userMetadata?['full_name'] as String? ?? '';
          }
        }

        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error al cargar datos del perfil: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final yrsText = _yearsExperienceController.text.trim();
      final yearsExp = yrsText.isNotEmpty ? int.tryParse(yrsText) : null;

      await _repository.saveProfile(
        fullName: _fullNameController.text,
        professionalAreaId: _selectedAreaId,
        career: _careerController.text,
        professionalLevel: _selectedProfessionalLevel,
        yearsExperience: yearsExp,
        bio: _bioController.text,
        competencies: _selectedCompetencies,
        languages: _selectedLanguages,
        certifications: _selectedCertifications,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil guardado exitosamente'),
          backgroundColor: AppColors.colorSuccess,
        ),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar perfil: $e'),
          backgroundColor: AppColors.colorError,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // --- Dialogs to add items ---

  void _showAddCompetencyDialog() {
    String? selectedCompId;
    String selectedLevel = 'Básico';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final availableCompetencies = _competenciesCatalog.where((cat) {
              return !_selectedCompetencies
                  .any((sc) => sc.competencyId == cat.id);
            }).toList();

            return AlertDialog(
              backgroundColor: AppColors.bgSurface,
              title: const Text('Agregar Competencia', style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      dropdownColor: AppColors.bgSurface,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(labelText: 'Competencia'),
                      value: selectedCompId,
                      items: availableCompetencies.map((comp) {
                        return DropdownMenuItem(
                          value: comp.id,
                          child: Text(comp.name),
                        );
                      }).toList(),
                      onChanged: (val) => setDialogState(() => selectedCompId = val),
                    ),
                    const SizedBox(height: AppSpacing.space16),
                    DropdownButtonFormField<String>(
                      dropdownColor: AppColors.bgSurface,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(labelText: 'Nivel de dominio'),
                      value: selectedLevel,
                      items: const [
                        DropdownMenuItem(value: 'Básico', child: Text('Básico')),
                        DropdownMenuItem(value: 'Intermedio', child: Text('Intermedio')),
                        DropdownMenuItem(value: 'Avanzado', child: Text('Avanzado')),
                      ],
                      onChanged: (val) =>
                          setDialogState(() => selectedLevel = val ?? 'Básico'),
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
                  onPressed: selectedCompId == null
                      ? null
                      : () {
                          final compObj = _competenciesCatalog
                              .firstWhere((c) => c.id == selectedCompId);
                          setState(() {
                            _selectedCompetencies.add(
                              EditableUserCompetency(
                                competencyId: compObj.id,
                                name: compObj.name,
                                level: selectedLevel,
                              ),
                            );
                          });
                          Navigator.of(context).pop();
                        },
                  child: const Text('Agregar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddLanguageDialog() {
    String? selectedLangId;
    String? selectedLevelId;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final availableLangs = _languagesCatalog.where((cat) {
              return !_selectedLanguages
                  .any((sl) => sl.languageId == cat.id);
            }).toList();

            return AlertDialog(
              backgroundColor: AppColors.bgSurface,
              title: const Text('Agregar Idioma', style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      dropdownColor: AppColors.bgSurface,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(labelText: 'Idioma'),
                      value: selectedLangId,
                      items: availableLangs.map((lang) {
                        return DropdownMenuItem(
                          value: lang.id,
                          child: Text(lang.name),
                        );
                      }).toList(),
                      onChanged: (val) => setDialogState(() => selectedLangId = val),
                    ),
                    const SizedBox(height: AppSpacing.space16),
                    DropdownButtonFormField<String>(
                      dropdownColor: AppColors.bgSurface,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(labelText: 'Nivel'),
                      value: selectedLevelId,
                      items: _languageLevelsCatalog.map((lvl) {
                        return DropdownMenuItem(
                          value: lvl.id,
                          child: Text('${lvl.name} ${lvl.description != null ? '(${lvl.description})' : ''}'),
                        );
                      }).toList(),
                      onChanged: (val) => setDialogState(() => selectedLevelId = val),
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
                  onPressed: (selectedLangId == null || selectedLevelId == null)
                      ? null
                      : () {
                          final langObj = _languagesCatalog
                              .firstWhere((l) => l.id == selectedLangId);
                          final levelObj = _languageLevelsCatalog
                              .firstWhere((l) => l.id == selectedLevelId);
                          setState(() {
                            _selectedLanguages.add(
                              EditableUserLanguage(
                                languageId: langObj.id,
                                languageName: langObj.name,
                                languageLevelId: levelObj.id,
                                levelName: levelObj.name,
                              ),
                            );
                          });
                          Navigator.of(context).pop();
                        },
                  child: const Text('Agregar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddCertificationDialog() {
    final nameCtrl = TextEditingController();
    final issuerCtrl = TextEditingController();
    final dateCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.bgSurface,
          title: const Text('Agregar Certificación', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de certificación',
                    hintText: 'ej. AWS Cloud Practitioner',
                  ),
                ),
                const SizedBox(height: AppSpacing.space12),
                TextField(
                  controller: issuerCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Institución / Emisor',
                    hintText: 'ej. Amazon Web Services',
                  ),
                ),
                const SizedBox(height: AppSpacing.space12),
                TextField(
                  controller: dateCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de obtención (YYYY-MM-DD)',
                    hintText: '2026-01-15',
                  ),
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
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                setState(() {
                  _selectedCertifications.add(
                    EditableUserCertification(
                      name: nameCtrl.text.trim(),
                      issuer: issuerCtrl.text.trim(),
                      issueDate: dateCtrl.text.trim(),
                    ),
                  );
                });
                Navigator.of(context).pop();
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: const ValoraAppBar(
        showBackButton: true,
        title: 'Editar Perfil',
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
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
                    child: ListView(
                      padding: const EdgeInsets.all(AppSpacing.space24),
                      children: [
                        SectionLabel('Información General'),
                        const SizedBox(height: AppSpacing.space16),

                        TextFormField(
                          controller: _fullNameController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre Completo',
                          ),
                          validator: (v) =>
                              (v == null || v.trim().isEmpty) ? 'Ingresa tu nombre' : null,
                        ),
                        const SizedBox(height: AppSpacing.space16),

                        DropdownButtonFormField<String>(
                          dropdownColor: AppColors.bgSurface,
                          style: const TextStyle(color: Colors.white),
                          value: _selectedAreaId,
                          decoration: const InputDecoration(
                            labelText: 'Área Profesional',
                          ),
                          items: _areas.map((area) {
                            return DropdownMenuItem(
                              value: area.id,
                              child: Text(area.name),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedAreaId = val),
                          validator: (v) => v == null ? 'Selecciona un área profesional' : null,
                        ),
                        const SizedBox(height: AppSpacing.space16),

                        TextFormField(
                          controller: _careerController,
                          decoration: const InputDecoration(
                            labelText: 'Carrera / Profesión',
                            hintText: 'ej. Ingeniería en Sistemas',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space16),

                        DropdownButtonFormField<String>(
                          dropdownColor: AppColors.bgSurface,
                          style: const TextStyle(color: Colors.white),
                          value: _selectedProfessionalLevel,
                          decoration: const InputDecoration(
                            labelText: 'Nivel Profesional',
                          ),
                          items: _levelOptions.map((level) {
                            return DropdownMenuItem(
                              value: level,
                              child: Text(level),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => _selectedProfessionalLevel = val ?? 'Junior'),
                        ),
                        const SizedBox(height: AppSpacing.space16),

                        TextFormField(
                          controller: _yearsExperienceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Años de Experiencia',
                            hintText: 'ej. 2',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space16),

                        TextFormField(
                          controller: _bioController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Bio corta',
                            hintText: 'Describe tu perfil profesional...',
                          ),
                        ),

                        const SizedBox(height: AppSpacing.space32),
                        SectionLabel('Competencias'),
                        const SizedBox(height: AppSpacing.space12),

                        if (_selectedCompetencies.isEmpty)
                          const Text(
                            'No has agregado competencias aún.',
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
                                    '${comp.name} (${comp.level})',
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

                        const SizedBox(height: AppSpacing.space32),
                        SectionLabel('Idiomas'),
                        const SizedBox(height: AppSpacing.space12),

                        if (_selectedLanguages.isEmpty)
                          const Text(
                            'No has agregado idiomas aún.',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                          )
                        else
                          Wrap(
                            spacing: AppSpacing.space8,
                            runSpacing: AppSpacing.space8,
                            children: [
                              for (final lang in _selectedLanguages)
                                Chip(
                                  backgroundColor: AppColors.bgSurface,
                                  side: const BorderSide(color: AppColors.borderSubtle),
                                  label: Text(
                                    '${lang.languageName} — ${lang.levelName}',
                                    style: const TextStyle(color: Colors.white, fontSize: 13),
                                  ),
                                  onDeleted: () {
                                    setState(() {
                                      _selectedLanguages.remove(lang);
                                    });
                                  },
                                  deleteIconColor: AppColors.textMuted,
                                ),
                            ],
                          ),
                        const SizedBox(height: AppSpacing.space12),

                        OutlinedButton.icon(
                          onPressed: _showAddLanguageDialog,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Agregar idioma'),
                        ),

                        const SizedBox(height: AppSpacing.space32),
                        SectionLabel('Certificaciones'),
                        const SizedBox(height: AppSpacing.space12),

                        if (_selectedCertifications.isEmpty)
                          const Text(
                            'No has agregado certificaciones aún.',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                          )
                        else
                          Column(
                            children: [
                              for (final cert in _selectedCertifications)
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(cert.name, style: const TextStyle(color: Colors.white)),
                                  subtitle: Text('${cert.issuer} ${cert.issueDate.isNotEmpty ? '• ${cert.issueDate}' : ''}',
                                      style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline, color: AppColors.colorError),
                                    onPressed: () {
                                      setState(() {
                                        _selectedCertifications.remove(cert);
                                      });
                                    },
                                  ),
                                ),
                            ],
                          ),
                        const SizedBox(height: AppSpacing.space12),

                        OutlinedButton.icon(
                          onPressed: _showAddCertificationDialog,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Agregar certificación'),
                        ),

                        const SizedBox(height: AppSpacing.space32),

                        ElevatedButton(
                          onPressed: _isSaving ? null : _saveProfile,
                          child: _isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Guardar Perfil'),
                        ),
                        const SizedBox(height: AppSpacing.space24),
                      ],
                    ),
                  ),
      ),
    );
  }
}
