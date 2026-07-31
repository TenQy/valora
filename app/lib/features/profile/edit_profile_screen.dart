import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/animated_app_background.dart';
import '../../shared/widgets/section_label.dart';
import '../../../shared/widgets/valora_app_bar.dart';
import '../../../shared/widgets/valora_searchable_dropdown.dart';
import 'widgets/add_certification_dialog.dart';
import 'widgets/add_competency_dialog.dart';
import 'widgets/add_language_dialog.dart';
import 'models/catalog_models.dart';
import 'services/profile_repository.dart';
import '../dashboard/dashboard_screen.dart';

class EditProfileScreen extends StatefulWidget {
  final bool isInitialSetup;
  const EditProfileScreen({super.key, this.isInitialSetup = false});

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
  late final FocusNode _yearsExperienceFocusNode;

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

  int _getMaxYearsForLevel(String level) {
    switch (level) {
      case 'Estudiante':
        return 2;
      case 'Practicante':
        return 3;
      case 'Junior':
        return 5;
      case 'Semi Senior':
        return 10;
      case 'Senior':
      case 'Especialista':
      default:
        return 70;
    }
  }

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _yearsExperienceController = TextEditingController();
    _bioController = TextEditingController();
    _yearsExperienceFocusNode = FocusNode();

    _loadData();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _yearsExperienceController.dispose();
    _bioController.dispose();
    _yearsExperienceFocusNode.dispose();
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
    if (!_formKey.currentState!.validate()) {
      if (widget.isInitialSetup && (_selectedAreaId == null || _selectedCompetencies.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, ingresa al menos tu área profesional y una competencia para poder calcular tu valor.'),
            backgroundColor: AppColors.colorWarning,
          ),
        );
      }
      final yrsText = _yearsExperienceController.text.trim();
      if (yrsText.isNotEmpty) {
        final yrs = int.tryParse(yrsText);
        if (yrs != null) {
          final maxYears = _getMaxYearsForLevel(_selectedProfessionalLevel);
          if (yrs > maxYears) {
            _yearsExperienceFocusNode.requestFocus();
          }
        }
      }
      return;
    }

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

      if (widget.isInitialSetup) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
          (route) => false,
        );
      } else {
        Navigator.of(context).pop(true);
      }
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

  void _showAddCompetencyDialog() async {
    final availableCompetencies = _competenciesCatalog.where((cat) {
      return !_selectedCompetencies.any((sc) => sc.competencyId == cat.id);
    }).toList();

    final result = await showDialog<EditableUserCompetency>(
      context: context,
      builder: (context) => AddCompetencyDialog(
        availableCompetencies: availableCompetencies,
      ),
    );
    if (!mounted) return;
    FocusScope.of(context).unfocus();

    if (result != null) {
      setState(() => _selectedCompetencies.add(result));
    }
  }

  void _showAddLanguageDialog() async {
    final availableLangs = _languagesCatalog.where((cat) {
      return !_selectedLanguages.any((sl) => sl.languageId == cat.id);
    }).toList();

    final result = await showDialog<EditableUserLanguage>(
      context: context,
      builder: (context) => AddLanguageDialog(
        availableLanguages: availableLangs,
        levelsCatalog: _languageLevelsCatalog,
      ),
    );
    if (!mounted) return;
    FocusScope.of(context).unfocus();

    if (result != null) {
      setState(() => _selectedLanguages.add(result));
    }
  }

  void _showAddCertificationDialog() async {
    final result = await showDialog<EditableUserCertification>(
      context: context,
      builder: (context) => AddCertificationDialog(
        issuersCatalog: _certificationIssuersCatalog,
        repository: _repository,
      ),
    );
    if (!mounted) return;
    FocusScope.of(context).unfocus();

    if (result != null) {
      setState(() => _selectedCertifications.add(result));
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

    return PopScope(
      canPop: !widget.isInitialSetup,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (widget.isInitialSetup) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Configura tu perfil básico para poder usar la app.'),
              backgroundColor: AppColors.colorWarning,
            ),
          );
        }
      },
      child: Scaffold(
      backgroundColor: AppColors.bgPage,
      extendBodyBehindAppBar: true,
      appBar: ValoraAppBar(
        showBackButton: !widget.isInitialSetup,
        title: widget.isInitialSetup ? 'Configura tu Perfil' : 'Editar Perfil',
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
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSpacing.space24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            focusNode: _yearsExperienceFocusNode,
                            controller: _yearsExperienceController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                            validator: (val) {
                              if (val != null && val.isNotEmpty) {
                                final number = int.tryParse(val);
                                if (number != null) {
                                  final maxYears = _getMaxYearsForLevel(_selectedProfessionalLevel);
                                  if (number > maxYears) {
                                    if (maxYears == 70) return 'Máximo 70 años';
                                    return 'Como $_selectedProfessionalLevel máximo $maxYears años';
                                  }
                                }
                              }
                              return null;
                            },
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
                            const SizedBox(height: AppSpacing.space32),
                          ],
                        ),
                      ),
                    ),
          ),
        ),
      ),
    ),
    );
  }
}
