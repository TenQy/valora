import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../results/models/job_match_model.dart';
import '../results/models/salary_estimation.dart';
import '../results/history_screen.dart';
import '../results/job_match_screen.dart';
import '../../shared/widgets/match_badge.dart';
import '../../shared/widgets/expandable_text.dart';
import 'services/dashboard_service.dart';
import '../results/services/results_service.dart';
import '../results/models/growth_path_model.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({
    super.key,
    required this.onEstimateSalaryPressed,
    required this.onJobMatchPressed,
  });

  final VoidCallback onEstimateSalaryPressed;
  final VoidCallback onJobMatchPressed;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _service = DashboardService();
  late Future<DashboardData> _future;
  bool _isGeneratingPath = false;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _growthPathKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  DashboardData get _dummyData => DashboardData(
        userName: 'Usuario',
        professionalLevel: 'Senior',
        profileCompleteness: 85,
        latestEstimation: const SalaryEstimation(
          estimatedMinSalary: 35000,
          estimatedMaxSalary: 45000,
          currency: 'MXN',
          professionalLevel: 'Senior',
          summary: 'Basado en tus habilidades técnicas de alto nivel, esto es lo que ofrece el mercado.',
          influentialFactors: [],
          topHighlights: [],
          factorBreakdown: [],
        ),
        latestMatches: [
          JobMatchResult(
            jobRoleId: 'dummy',
            jobRoleName: 'Desarrollador Flutter Senior',
            matchPercentage: 90,
            estimatedMinSalary: 0,
            estimatedMaxSalary: 0,
            currency: 'MXN',
            searchQuery: 'Flutter',
            matchedCompetencies: [],
            missingCompetencies: [],
            summary: 'Cumples con la gran mayoría de los requisitos.',
          ),
        ],
      );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _future = _service.fetchDashboardData();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => _loadData(),
      child: FutureBuilder<DashboardData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildError(snapshot.error.toString());
          }

          final isLoading = snapshot.connectionState == ConnectionState.waiting;
          final data = isLoading ? _dummyData : snapshot.data;

          if (!isLoading && data == null) {
            return _buildError('No se encontraron datos.');
          }

          return Skeletonizer(
            enabled: isLoading,
            effect: ShimmerEffect(
              baseColor: AppColors.bgSurface,
              highlightColor: AppColors.silver.withValues(alpha: 0.1),
            ),
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppSpacing.space24),
              children: [
                _buildHeader(data!),
                const SizedBox(height: 24),
                _buildCompleteness(data),
                const SizedBox(height: 32),
                _buildActions(),
                const SizedBox(height: 32),
                if (data.latestEstimation != null) ...[
                  _buildLatestEstimation(data.latestEstimation!),
                  const SizedBox(height: 32),
                ],
                if (data.latestMatches.isNotEmpty) ...[
                  _buildLatestMatches(data.latestMatches),
                  const SizedBox(height: 32),
                ],
                _buildImprovementGuide(data),
                const SizedBox(height: 64),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _generateGrowthPath({bool forceRefresh = false}) async {
    setState(() => _isGeneratingPath = true);
    try {
      final resultsService = ResultsService();
      await resultsService.fetchGrowthPath(forceRefresh: forceRefresh);
      await _loadData();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_growthPathKey.currentContext != null) {
          Scrollable.ensureVisible(
            _growthPathKey.currentContext!,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            alignment: 0.1,
          );
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: AppColors.colorError,
        ),
      );
    } finally {
      if (mounted) setState(() => _isGeneratingPath = false);
    }
  }

  void _confirmRefreshPath(bool isProfileUpdatedRecently) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isProfileUpdatedRecently ? '¿Generar Nueva Ruta?' : '¿Actualizar Ruta?', 
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)
        ),
        content: Text(
          isProfileUpdatedRecently
            ? 'Hemos detectado que actualizaste tu perfil recientemente.\n\nAl continuar, Valora analizará tus nuevos datos para trazar una ruta de aprendizaje más precisa y actualizada a tu nivel actual.\n\n¿Deseas generarla ahora?'
            : 'Tu ruta está guardada localmente.\n\nTen en cuenta que si no has modificado tu perfil (agregando habilidades, idiomas o certificaciones), pedir una nueva ruta generará resultados muy similares o idénticos a los que ya tienes.\n\n¿Estás seguro de que quieres generar una nueva?',
          style: const TextStyle(color: AppColors.silverMuted, fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar', style: TextStyle(color: AppColors.silverMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _generateGrowthPath(forceRefresh: true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.textPrimary,
              foregroundColor: AppColors.bgBase,
            ),
            child: Text(isProfileUpdatedRecently ? 'Sí, generar' : 'Sí, actualizar', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }


  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.colorError),
          const SizedBox(height: 16),
          Text(error, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _loadData, child: const Text('Reintentar')),
        ],
      ),
    );
  }

  Widget _buildHeader(DashboardData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hola, ${data.userName}', style: AppTextStyles.h1),
      ],
    );
  }

  Widget _buildCompleteness(DashboardData data) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space20),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDefault),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Perfil completado', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
              Text('${data.profileCompleteness}%', style: const TextStyle(color: AppColors.silver, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.bgInput,
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: data.profileCompleteness / 100,
              child: Skeleton.leaf(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2E7D32),
                        AppColors.colorSuccess,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Acciones Rápidas', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: widget.onEstimateSalaryPressed,
                icon: const Icon(Icons.monetization_on_outlined, size: 18),
                label: const Text('Estimar salario'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: widget.onJobMatchPressed,
                icon: const Icon(Icons.work_outline, size: 18),
                label: const Text('Match Laboral'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bgSurface,
                  foregroundColor: AppColors.silver,
                  side: const BorderSide(color: AppColors.borderDefault),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLatestEstimation(SalaryEstimation est) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.bgSurface,
            AppColors.bgSurface.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.silver.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.monetization_on, color: AppColors.silver, size: 20),
                  SizedBox(width: 8),
                  Text('Última estimación', style: TextStyle(color: AppColors.silver, fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HistoryScreen()));
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Historial', style: TextStyle(fontSize: 13, color: AppColors.silver)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '\$${Formatters.formatThousands(est.estimatedMinSalary)} - \$${Formatters.formatThousands(est.estimatedMaxSalary)} ${est.currency}',
            style: const TextStyle(color: AppColors.silver, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5),
          ),
          const SizedBox(height: 8),
          ExpandableText(
            text: est.summary,
            maxLines: 2,
            style: const TextStyle(color: AppColors.silverMuted, fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestMatches(List<JobMatchResult> matches) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Último Match', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => JobMatchScreen(savedMatches: matches)),
                );
              },
              child: const Text('Ver todos', style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...matches.map((m) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => _showMatchDetails(context, m),
            borderRadius: BorderRadius.circular(12),
            child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.jobRoleName, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('${m.matchPercentage}% de compatibilidad', style: const TextStyle(color: AppColors.silverMuted, fontSize: 12)),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.silverMuted),
              ],
            ),
          ),
          ),
        )),
      ],
    );
  }

  Widget _buildImprovementGuide(DashboardData data) {
    if (data.latestGrowthPath != null) {
      final result = data.latestGrowthPath!;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            key: _growthPathKey,
            children: const [
              Icon(Icons.rocket_launch_outlined, color: AppColors.silver, size: 20),
              SizedBox(width: 8),
              Text('Tu Ruta de Crecimiento', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            result.summary,
            style: const TextStyle(color: AppColors.silverMuted, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 24),
          _buildTimeline(result),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _isGeneratingPath ? null : () => _confirmRefreshPath(data.isProfileUpdatedRecently),
              icon: _isGeneratingPath 
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.silver))
                : const Icon(Icons.refresh, size: 18),
              label: Text(_isGeneratingPath ? 'Actualizando...' : 'Actualizar Ruta'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.silver,
                side: const BorderSide(color: AppColors.borderDefault),
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (data.isProfileUpdatedRecently) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.colorInfo.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.colorInfo.withValues(alpha: 0.3)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: AppColors.colorInfo, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Has actualizado tu perfil recientemente. ¡Te sugerimos generar una nueva ruta!',
                      style: TextStyle(color: AppColors.colorInfo, fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          key: _growthPathKey,
          children: const [
            Icon(Icons.rocket_launch_outlined, color: AppColors.silver, size: 20),
            SizedBox(width: 8),
            Text('Tu Ruta de Crecimiento', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Genera un plan de acción paso a paso impulsado por IA para alcanzar tu siguiente nivel profesional.',
          style: TextStyle(color: AppColors.silverMuted, fontSize: 14, height: 1.5),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isGeneratingPath ? null : _generateGrowthPath,
            icon: _isGeneratingPath 
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.bgPage))
              : const Icon(Icons.trending_up, size: 18),
            label: Text(_isGeneratingPath ? 'Generando...' : 'Generar mi Ruta'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline(GrowthPathModel result) {
    Color getIconColor(String type) {
      switch (type) {
        case 'skill': return Colors.blueAccent;
        case 'certification': return Colors.orangeAccent;
        case 'experience': return Colors.green;
        case 'language': return Colors.purpleAccent;
        case 'soft_skill': return Colors.tealAccent;
        default: return AppColors.silver;
      }
    }

    IconData getIcon(String type) {
      switch (type) {
        case 'skill': return Icons.code;
        case 'certification': return Icons.verified_user_outlined;
        case 'experience': return Icons.work_history_outlined;
        case 'language': return Icons.language;
        case 'soft_skill': return Icons.psychology_outlined;
        default: return Icons.star_border;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.space20),
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('NIVEL ACTUAL', style: TextStyle(color: AppColors.silverMuted, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 4),
                  Text(result.currentLevel, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  const Text('SIGUIENTE NIVEL', style: TextStyle(color: AppColors.silverMuted, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 4),
                  Text(result.nextLevel, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: AppSpacing.space16),
              const Divider(color: AppColors.borderDefault),
              const SizedBox(height: AppSpacing.space16),
              Row(
                children: [
                  const Icon(Icons.timer_outlined, color: AppColors.silverMuted, size: 16),
                  const SizedBox(width: 8),
                  Text('Tiempo estimado: ${result.estimatedTime}', style: const TextStyle(color: AppColors.silverMuted, fontSize: 13)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.space24),
        ...result.milestones.asMap().entries.map((entry) {
          final int index = entry.key;
          final milestone = entry.value;
          final isLast = index == result.milestones.length - 1;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: getIconColor(milestone.type).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: getIconColor(milestone.type).withValues(alpha: 0.3)),
                      ),
                      child: Icon(getIcon(milestone.type), size: 16, color: getIconColor(milestone.type)),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: AppColors.borderDefault,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.space24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(milestone.title, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(milestone.description, style: const TextStyle(color: AppColors.silverMuted, fontSize: 14, height: 1.4)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  void _showMatchDetails(BuildContext context, JobMatchResult match) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(match.jobRoleName, style: AppTextStyles.h1.copyWith(fontSize: 20)),
            const SizedBox(height: 8),
            Text(
              '${match.matchPercentage}% de compatibilidad',
              style: const TextStyle(color: AppColors.colorSuccess, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ExpandableText(
              text: match.summary,
              maxLines: 2,
              style: const TextStyle(color: AppColors.silverMuted, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 24),
            if (match.matchedCompetencies.isNotEmpty) ...[
              const Text('Habilidades fuertes:', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: match.matchedCompetencies.map((c) => MatchBadge(label: c, hasIt: true)).toList(),
              ),
              const SizedBox(height: 16),
            ],
            if (match.missingCompetencies.isNotEmpty) ...[
              const Text('Áreas de oportunidad:', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: match.missingCompetencies.map((c) => MatchBadge(label: c, hasIt: false)).toList(),
              ),
              const SizedBox(height: 32),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final query = Uri.encodeComponent(match.searchQuery);
                  final url = Uri.parse('https://www.google.com/search?q=$query&ibp=htl;jobs');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                icon: const Icon(Icons.search),
                label: const Text('Ver ofertas reales'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
        ),
      ),
    );
  }
}
