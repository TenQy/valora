import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/animated_app_background.dart';
import '../../shared/widgets/section_label.dart';
import '../../shared/widgets/valora_app_bar.dart';
import '../../shared/widgets/valora_searchable_dropdown.dart';
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
  late final TextEditingController _yearsExperienceController;
  late final TextEditingController _bioController;

  String? _selectedAreaId;
  JobRoleItem? _selectedCareerObj;
  String _selectedProfessionalLevel = 'Junior';

  // Catalogs
  List<ProfessionalAreaItem> _areas = [];
  List<CompetencyItem> _competenciesCatalog = [];
  List<LanguageItem> _languagesCatalog = [];
  List<LanguageLevelItem> _languageLevelsCatalog = [];
  List<JobRoleItem> _jobRolesCatalog = [];
  List<CertificationIssuerItem> _certificationIssuersCatalog = [];

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
    _yearsExperienceController = TextEditingController();
    _bioController = TextEditingController();

    _loadData();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
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
      final areas = await _repository.fetchProfessionalAreas();
      final competencies = await _repository.fetchCompetencies();
      final languages = await _repository.fetchLanguages();
      final levels = await _repository.fetchLanguageLevels();
      final jobRoles = await _repository.fetchJobRoles();
      final issuers = await _repository.fetchCertificationIssuers();
      final rawProfile = await _repository.fetchRawProfileForEditing();

      if (!mounted) return;

      setState(() {
        _areas = areas;
        _competenciesCatalog = competencies;
        _languagesCatalog = languages;
        _languageLevelsCatalog = levels;
        _jobRolesCatalog = jobRoles;
        _certificationIssuersCatalog = issuers;

        if (rawProfile != null) {
          _fullNameController.text = rawProfile['full_name'] as String? ?? '';
          _selectedAreaId = rawProfile['professional_area_id'] as String?;
          
          final careerTxt = rawProfile['career'] as String? ?? '';
          _selectedCareerObj = _jobRolesCatalog.cast<JobRoleItem?>().firstWhere(
            (r) => r?.name == careerTxt,
            orElse: () => null,
          );

          final level = rawProfile['professional_level'] as String?;
          if (level != null && _levelOptions.contains(level)) {
            _selectedProfessionalLevel = level;
          }

          final yrs = rawProfile['years_experience'];
          _yearsExperienceController.text = yrs != null ? yrs.toString() : '';
          _bioController.text = rawProfile['bio'] as String? ?? '';

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
        career: _selectedCareerObj?.name ?? '',
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

  // --- Dialogs ---

  void _showAddCompetencyDialog() {
    CompetencyItem? selectedComp;
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
                    ValoraSearchableDropdown<CompetencyItem>(
                      label: 'Competencia',
                      value: selectedComp,
                      items: availableCompetencies,
                      itemLabel: (comp) => comp.name,
                      itemSubLabel: (comp) => comp.category ?? '',
                      onChanged: (val) => setDialogState(() => selectedComp = val),
                    ),
                    const SizedBox(height: AppSpacing.space16),
                    ValoraSearchableDropdown<String>(
                      label: 'Nivel de dominio',
                      value: selectedLevel,
                      items: const ['Básico', 'Intermedio', 'Avanzado'],
                      itemLabel: (lvl) => lvl,
                      onChanged: (val) => setDialogState(() => selectedLevel = val ?? 'Básico'),
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
                  onPressed: selectedComp == null
                      ? null
                      : () {
                          setState(() {
                            _selectedCompetencies.add(
                              EditableUserCompetency(
                                competencyId: selectedComp!.id,
                                name: selectedComp!.name,
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
    LanguageItem? selectedLang;
    LanguageLevelItem? selectedLevel;

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
                    ValoraSearchableDropdown<LanguageItem>(
                      label: 'Idioma',
                      value: selectedLang,
                      items: availableLangs,
                      itemLabel: (lang) => lang.name,
                      onChanged: (val) => setDialogState(() => selectedLang = val),
                    ),
                    const SizedBox(height: AppSpacing.space16),
                    ValoraSearchableDropdown<LanguageLevelItem>(
                      label: 'Nivel',
                      value: selectedLevel,
                      items: _languageLevelsCatalog,
                      itemLabel: (lvl) => lvl.name,
                      itemSubLabel: (lvl) => lvl.description ?? '',
                      onChanged: (val) => setDialogState(() => selectedLevel = val),
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
                          setState(() {
                            _selectedLanguages.add(
                              EditableUserLanguage(
                                languageId: selectedLang!.id,
                                languageName: selectedLang!.name,
                                languageLevelId: selectedLevel!.id,
                                levelName: selectedLevel!.name,
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
    final dateCtrl = TextEditingController();
    CertificationIssuerItem? selectedIssuer;
    bool isValidating = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
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
                    ValoraSearchableDropdown<CertificationIssuerItem>(
                      label: 'Institución / Emisor',
                      value: selectedIssuer,
                      items: _certificationIssuersCatalog,
                      itemLabel: (issuer) => issuer.name,
                      onChanged: (val) => setDialogState(() => selectedIssuer = val),
                    ),
                    const SizedBox(height: AppSpacing.space12),
                    TextFormField(
                      controller: dateCtrl,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Fecha de obtención (YYYY-MM-DD)',
                        hintText: '2026-01-15',
                        suffixIcon: Icon(Icons.calendar_today, size: 20, color: AppColors.textMuted),
                      ),
                      onTap: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: now,
                          firstDate: DateTime(1980),
                          lastDate: now,
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: AppColors.silver,
                                  onPrimary: Colors.black,
                                  surface: AppColors.bgSurface,
                                  onSurface: Colors.white,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          dateCtrl.text = picked.toIso8601String().split('T').first;
                        }
                      },
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
                  onPressed: (selectedIssuer == null || isValidating)
                      ? null
                      : () async {
                          final certName = nameCtrl.text.trim();
                          if (certName.isEmpty) return;
                          
                          setDialogState(() => isValidating = true);
                          
                          try {
                            final res = await Supabase.instance.client.functions.invoke(
                              'validate-text',
                              body: {'text': certName, 'type': 'certification'},
                            );
                            
                            final isValid = res.data['isValid'] as bool? ?? true;
                            
                            if (!isValid) {
                              if (!context.mounted) return;
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Ese nombre de certificación no parece válido.'),
                                  backgroundColor: AppColors.colorError,
                                ),
                              );
                              return;
                            }
                            
                            setState(() {
                              _selectedCertifications.add(
                                EditableUserCertification(
                                  name: certName,
                                  issuer: selectedIssuer!.name,
                                  issueDate: dateCtrl.text.trim(),
                                ),
                              );
                            });
                            if (context.mounted) Navigator.of(context).pop();
                          } catch (e) {
                            if (!context.mounted) return;
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error validando: $e'),
                                backgroundColor: AppColors.colorError,
                                duration: const Duration(seconds: 4),
                              ),
                            );
                          }
                        },
                  child: isValidating 
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Agregar'),
                ),
              ],
            );
          },
        );
      },
    );
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
        title: 'Editar Perfil',
      ),
      body: AnimatedAppBackground(
        child: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
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

                          ValoraSearchableDropdown<ProfessionalAreaItem>(
                            label: 'Área Profesional',
                            value: selectedAreaObj,
                            items: _areas,
                            itemLabel: (area) => area.name,
                            onChanged: (area) => setState(() => _selectedAreaId = area?.id),
                            validator: (v) => v == null ? 'Selecciona un área profesional' : null,
                          ),
                          const SizedBox(height: AppSpacing.space16),

                          ValoraSearchableDropdown<JobRoleItem>(
                            label: 'Carrera / Profesión',
                            value: _selectedCareerObj,
                            items: _jobRolesCatalog,
                            itemLabel: (role) => role.name,
                            onChanged: (role) => setState(() => _selectedCareerObj = role),
                            validator: (v) => v == null ? 'Selecciona una profesión' : null,
                          ),
                          const SizedBox(height: AppSpacing.space16),

                          ValoraSearchableDropdown<String>(
                            label: 'Nivel Profesional',
                            value: _selectedProfessionalLevel,
                            items: _levelOptions,
                            itemLabel: (lvl) => lvl,
                            onChanged: (lvl) =>
                                setState(() => _selectedProfessionalLevel = lvl ?? 'Junior'),
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
                                    subtitle: Text(
                                      '${cert.issuer} ${cert.issueDate.isNotEmpty ? '• ${cert.issueDate}' : ''}',
                                      style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                                    ),
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
        ),
      ),
    );
  }
}
