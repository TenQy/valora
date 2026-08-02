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

  void _loadData() {
    setState(() {
      _future = _service.fetchDashboardData();
    });
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
    final List<String> tips = [];

    // Tip 1: Completitud
    if (data.profileCompleteness < 100) {
      tips.add('Tienes un ${data.profileCompleteness}% de tu perfil completo. Llenar los datos faltantes aumentará la precisión de tu valor.');
    } else {
      tips.add('Tu perfil base está impecable. El siguiente paso es diversificar tus conocimientos fuera de tu zona de confort.');
    }

    // Tip 2: Basado en el último match
    if (data.latestMatches.isNotEmpty) {
      final topMatch = data.latestMatches.first;
      if (topMatch.missingCompetencies.isNotEmpty) {
        final missing = topMatch.missingCompetencies.take(2).join(', ');
        tips.add('Para asegurar tu puesto ideal como ${topMatch.jobRoleName}, el mercado exige que domines: $missing. ¡Añádelo a tu plan de estudio!');
      } else {
        tips.add('Tienes cobertura total para ${topMatch.jobRoleName}. Te sugerimos actualizar tus expectativas salariales o apuntar a roles de liderazgo.');
      }
    } else {
      tips.add('Genera tu primera Compatibilidad Laboral para recibir recomendaciones precisas sobre qué tecnología aprender a continuación.');
    }

    // Tip 3: General de nivel
    if (data.professionalLevel == 'Junior' || data.professionalLevel == 'Estudiante') {
      tips.add('Las certificaciones oficiales son el atajo más rápido para saltar a un nivel Mid/Senior y destacar entre los candidatos.');
    } else if (data.professionalLevel == 'Semi Senior' || data.professionalLevel == 'Mid Level') {
      tips.add('En tu nivel, las habilidades de arquitectura y metodologías ágiles comienzan a tener más peso que el código puro.');
    } else if (data.professionalLevel == 'Senior' || data.professionalLevel == 'Especialista') {
      tips.add('Como talento Senior, dominar idiomas adicionales multiplicará tus oportunidades de acceder a salarios internacionales de primer nivel.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.rocket_launch_outlined, color: AppColors.silver, size: 20),
            SizedBox(width: 8),
            Text('Tu Ruta de Crecimiento', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 16),
        ...tips.map((t) => _buildGuideItem(t)),
      ],
    );
  }

  Widget _buildGuideItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2, right: 12),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: AppColors.silver.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.silver),
          ),
          Expanded(child: Text(text, style: const TextStyle(color: AppColors.silverMuted, fontSize: 13, height: 1.5))),
        ],
      ),
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
