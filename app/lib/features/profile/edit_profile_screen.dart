import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
import 'utils/level_utils.dart';
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
  String _selectedProfessionalLevel = 'Estudiante';

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
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = 'edit_profile_cache_${Supabase.instance.client.auth.currentUser?.id}';
      final cachedStr = prefs.getString(cacheKey);

      if (cachedStr != null) {
        try {
          final cachedData = jsonDecode(cachedStr) as Map<String, dynamic>;
          _parseDataToState(
            areas: (cachedData['areas'] as List).map((e) => ProfessionalAreaItem.fromJson(e)).toList(),
            competencies: (cachedData['competencies'] as List).map((e) => CompetencyItem.fromJson(e)).toList(),
            languages: (cachedData['languages'] as List).map((e) => LanguageItem.fromJson(e)).toList(),
            levels: (cachedData['levels'] as List).map((e) => LanguageLevelItem.fromJson(e)).toList(),
            jobRoles: (cachedData['jobRoles'] as List).map((e) => JobRoleItem.fromJson(e)).toList(),
            issuers: (cachedData['issuers'] as List).map((e) => CertificationIssuerItem.fromJson(e)).toList(),
            rawProfile: cachedData['rawProfile'] as Map<String, dynamic>?,
          );
          if (mounted) setState(() => _isLoading = false);
        } catch (e) {
          debugPrint('Error parsing cache: $e');
        }
      }

      final areas = await _repository.fetchProfessionalAreas();
      final competencies = await _repository.fetchCompetencies();
      final languages = await _repository.fetchLanguages();
      final levels = await _repository.fetchLanguageLevels();
      final jobRoles = await _repository.fetchJobRoles();
      final issuers = await _repository.fetchCertificationIssuers();
      final rawProfile = await _repository.fetchRawProfileForEditing();

      if (!mounted) return;

      final freshData = {
        'areas': areas.map((e) => e.toJson()).toList(),
        'competencies': competencies.map((e) => e.toJson()).toList(),
        'languages': languages.map((e) => e.toJson()).toList(),
        'levels': levels.map((e) => e.toJson()).toList(),
        'jobRoles': jobRoles.map((e) => e.toJson()).toList(),
        'issuers': issuers.map((e) => e.toJson()).toList(),
        'rawProfile': rawProfile,
      };
      prefs.setString(cacheKey, jsonEncode(freshData));

      String? guestAreaId;
      String? guestLevel;
      List<EditableUserCompetency> guestCompetencies = [];
      try {
        final guestResultJson = prefs.getString('guest_estimation_result');
        if (guestResultJson != null) {
          final guestData = jsonDecode(guestResultJson) as Map<String, dynamic>;
          guestAreaId = guestData['professional_area_id'] as String?;
          guestLevel = guestData['professional_level'] as String?;
          if (guestData['competencies'] != null) {
            final rawComps = guestData['competencies'] as List;
            for (final rc in rawComps) {
              final comp = rc as Map<String, dynamic>;
              guestCompetencies.add(EditableUserCompetency(
                competencyId: comp['competency_id'] as String,
                name: comp['name'] as String,
                level: comp['level'] as String,
                requiresLevel: comp['requires_level'] as bool? ?? true,
              ));
            }
          }
        }
      } catch (e) {
        debugPrint('Error loading guest data for prefill: $e');
      }

      _parseDataToState(
        areas: areas,
        competencies: competencies,
        languages: languages,
        levels: levels,
        jobRoles: jobRoles,
        issuers: issuers,
        rawProfile: rawProfile,
        guestAreaId: guestAreaId,
        guestLevel: guestLevel,
        guestCompetencies: guestCompetencies,
      );

      setState(() => _isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error al cargar datos del perfil: $e';
        _isLoading = false;
      });
    }
  }

  void _parseDataToState({
    required List<ProfessionalAreaItem> areas,
    required List<CompetencyItem> competencies,
    required List<LanguageItem> languages,
    required List<LanguageLevelItem> levels,
    required List<JobRoleItem> jobRoles,
    required List<CertificationIssuerItem> issuers,
    required Map<String, dynamic>? rawProfile,
    String? guestAreaId,
    String? guestLevel,
    List<EditableUserCompetency> guestCompetencies = const [],
  }) {
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
      if (level != null && _currentLevelOptions.contains(level)) {
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
            requiresLevel: compObj?['requires_level'] as bool? ?? true,
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

    if (guestAreaId != null && _selectedAreaId == null) {
      _selectedAreaId = guestAreaId;
    }
    if (guestLevel != null && _selectedProfessionalLevel == 'Estudiante') {
      if (_currentLevelOptions.contains(guestLevel)) {
        _selectedProfessionalLevel = guestLevel;
      }
    }
    if (guestCompetencies.isNotEmpty && _selectedCompetencies.isEmpty) {
      _selectedCompetencies = List.from(guestCompetencies);
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
          final maxYears = LevelUtils.getMaxYearsForLevel(_selectedProfessionalLevel);
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

      final profileId = await _repository.saveProfile(
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

      try {
        final prefs = await SharedPreferences.getInstance();
        final guestResultJson = prefs.getString('guest_estimation_result');
        if (guestResultJson != null) {
          final guestData = jsonDecode(guestResultJson) as Map<String, dynamic>;
          await _repository.saveGuestEstimation(profileId, guestData);
          await prefs.remove('guest_estimation_result');
        }
      } catch (e) {
        debugPrint('Error al migrar datos de invitado: $e');
      }

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
        selectedAreaId: _selectedAreaId,
      ),
    );
    if (!mounted) return;
    FocusManager.instance.primaryFocus?.unfocus();

    if (result != null) {
      setState(() => _selectedCompetencies.add(result));
    }
  }

  void _showEditCompetencyLevelDialog(EditableUserCompetency comp, [StateSetter? setModalState]) async {
    if (!comp.requiresLevel) return;

    final levels = ['Básico', 'Intermedio', 'Avanzado', 'Experto'];
    
    final newLevel = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(AppSpacing.space16),
                child: Text('Nivel de dominio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              ...levels.map((lvl) => ListTile(
                title: Text(lvl, style: TextStyle(color: comp.level == lvl ? AppColors.green : Colors.white)),
                trailing: comp.level == lvl ? const Icon(Icons.check, color: AppColors.green) : null,
                onTap: () => Navigator.of(context).pop(lvl),
              )),
            ],
          ),
        );
      },
    );

    if (newLevel != null && mounted) {
      setState(() {
        comp.level = newLevel;
      });
      if (setModalState != null) setModalState(() {});
    }
  }

  void _showEditLanguageLevelDialog(EditableUserLanguage lang, [StateSetter? setModalState]) async {
    final levels = _languageLevelsCatalog;
    
    final newLevelItem = await showModalBottomSheet<LanguageLevelItem>(
      context: context,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(AppSpacing.space16),
                child: Text('Nivel de idioma', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Expanded(
                child: ListView(
                  children: levels.map((lvl) => ListTile(
                    title: Text(lvl.name, style: TextStyle(color: lang.languageLevelId == lvl.id ? AppColors.green : Colors.white)),
                    subtitle: lvl.description != null ? Text(lvl.description!, style: const TextStyle(color: AppColors.textMuted)) : null,
                    trailing: lang.languageLevelId == lvl.id ? const Icon(Icons.check, color: AppColors.green) : null,
                    onTap: () => Navigator.of(context).pop(lvl),
                  )).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (newLevelItem != null && mounted) {
      setState(() {
        lang.languageLevelId = newLevelItem.id;
        lang.levelName = newLevelItem.name;
      });
      if (setModalState != null) setModalState(() {});
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
    FocusManager.instance.primaryFocus?.unfocus();

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
    FocusManager.instance.primaryFocus?.unfocus();

    if (result != null) {
      setState(() => _selectedCertifications.add(result));
    }
  }

  void _showEditCertificationDialog(EditableUserCertification cert, [StateSetter? setModalState]) async {
    final result = await showDialog<EditableUserCertification>(
      context: context,
      builder: (context) => AddCertificationDialog(
        issuersCatalog: _certificationIssuersCatalog,
        repository: _repository,
        initialData: cert,
      ),
    );
    if (!mounted) return;
    FocusManager.instance.primaryFocus?.unfocus();

    if (result != null) {
      setState(() {
        cert.name = result.name;
        cert.issuer = result.issuer;
        cert.issueDate = result.issueDate;
      });
      if (setModalState != null) setModalState(() {});
    }
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
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: _errorMessage != null
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
                : Skeletonizer(
                    enabled: _isLoading,
                    effect: ShimmerEffect(
                      baseColor: AppColors.bgSurface.withValues(alpha: 0.5),
                      highlightColor: AppColors.silverSubtle,
                    ),
                    child: Form(
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
                            label: 'Carrera / Profesión (Opcional)',
                            value: _selectedCareerObj,
                            items: _jobRolesCatalog,
                            itemLabel: (role) => role.name,
                            onChanged: (role) => setState(() => _selectedCareerObj = role),
                            defaultFilter: _selectedAreaId != null 
                                ? (role) => role.professionalAreaId == _selectedAreaId
                                : null,
                            validator: (v) => null, // Opcional
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
                                  final maxYears = LevelUtils.getMaxYearsForLevel(_selectedProfessionalLevel);
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
                          SectionLabel(
                            'Competencias',
                            trailing: _selectedCompetencies.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.delete_sweep, color: AppColors.colorError, size: 20),
                                    onPressed: () => _confirmDelete(
                                      'Borrar todas',
                                      '¿Estás seguro de que quieres borrar todas tus competencias?',
                                      () => setState(() => _selectedCompetencies.clear()),
                                    ),
                                    tooltip: 'Borrar todas',
                                  )
                                : null,
                          ),
                          const SizedBox(height: AppSpacing.space12),

                          _buildEditableList<EditableUserCompetency>(
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
                                  subtitle: comp.requiresLevel ? Text(comp.level, style: const TextStyle(color: AppColors.green)) : null,
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (comp.requiresLevel)
                                        IconButton(
                                          icon: const Icon(Icons.edit, size: 18, color: AppColors.silver),
                                          onPressed: () => _showEditCompetencyLevelDialog(comp, setModalState),
                                        ),
                                      IconButton(
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
                                    ],
                                  ),
                                  onTap: comp.requiresLevel ? () => _showEditCompetencyLevelDialog(comp, setModalState) : null,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: AppSpacing.space12),

                          OutlinedButton.icon(
                            onPressed: _showAddCompetencyDialog,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Agregar competencia'),
                          ),

                          const SizedBox(height: AppSpacing.space32),
                          SectionLabel(
                            'Idiomas',
                            trailing: _selectedLanguages.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.delete_sweep, color: AppColors.colorError, size: 20),
                                    onPressed: () => _confirmDelete(
                                      'Borrar todos',
                                      '¿Estás seguro de que quieres borrar todos tus idiomas?',
                                      () => setState(() => _selectedLanguages.clear()),
                                    ),
                                    tooltip: 'Borrar todos',
                                  )
                                : null,
                          ),
                          const SizedBox(height: AppSpacing.space12),

                          _buildEditableList<EditableUserLanguage>(
                            items: _selectedLanguages,
                            emptyMessage: 'No has agregado idiomas aún.',
                            modalTitle: 'Todos tus Idiomas',
                            builder: (lang, setModalState) {
                              return Card(
                                color: AppColors.bgSurface,
                                margin: const EdgeInsets.only(bottom: AppSpacing.space8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppRadius.sm),
                                  side: const BorderSide(color: AppColors.borderSubtle),
                                ),
                                child: ListTile(
                                  dense: true,
                                  title: Text(lang.languageName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                                  subtitle: Text(lang.levelName, style: const TextStyle(color: AppColors.green)),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 18, color: AppColors.silver),
                                        onPressed: () => _showEditLanguageLevelDialog(lang, setModalState),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.colorError),
                                        onPressed: () => _confirmDelete(
                                          'Borrar idioma',
                                          '¿Deseas eliminar ${lang.languageName}?',
                                          () {
                                            setState(() => _selectedLanguages.remove(lang));
                                            if (setModalState != null) setModalState(() {});
                                          }
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () => _showEditLanguageLevelDialog(lang, setModalState),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: AppSpacing.space12),

                          OutlinedButton.icon(
                            onPressed: _showAddLanguageDialog,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Agregar idioma'),
                          ),

                          const SizedBox(height: AppSpacing.space32),
                          SectionLabel(
                            'Certificaciones',
                            trailing: _selectedCertifications.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.delete_sweep, color: AppColors.colorError, size: 20),
                                    onPressed: () => _confirmDelete(
                                      'Borrar todas',
                                      '¿Estás seguro de que quieres borrar todas tus certificaciones?',
                                      () => setState(() => _selectedCertifications.clear()),
                                    ),
                                    tooltip: 'Borrar todas',
                                  )
                                : null,
                          ),
                          const SizedBox(height: AppSpacing.space12),

                          _buildEditableList<EditableUserCertification>(
                            items: _selectedCertifications,
                            emptyMessage: 'No has agregado certificaciones aún.',
                            modalTitle: 'Todas tus Certificaciones',
                            builder: (cert, setModalState) {
                              return Card(
                                color: AppColors.bgSurface,
                                margin: const EdgeInsets.only(bottom: AppSpacing.space8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppRadius.sm),
                                  side: const BorderSide(color: AppColors.borderSubtle),
                                ),
                                child: ListTile(
                                  dense: true,
                                  title: Text(cert.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                                  subtitle: Text(
                                    '${cert.issuer} ${cert.issueDate.isNotEmpty ? '• ${cert.issueDate}' : ''}',
                                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 18, color: AppColors.silver),
                                        onPressed: () => _showEditCertificationDialog(cert, setModalState),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, color: AppColors.colorError, size: 18),
                                        onPressed: () => _confirmDelete(
                                          'Borrar certificación',
                                          '¿Deseas eliminar ${cert.name}?',
                                          () {
                                            setState(() => _selectedCertifications.remove(cert));
                                            if (setModalState != null) setModalState(() {});
                                          }
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () => _showEditCertificationDialog(cert, setModalState),
                                ),
                              );
                            },
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
      ),
    );
  }
}
