import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../shared/widgets/animated_app_background.dart';
import '../../shared/widgets/dynamic_loading_message.dart';
import 'package:flutter_animate/flutter_animate.dart' hide ShimmerEffect;
import '../../../shared/widgets/valora_app_bar.dart';
import '../../../shared/widgets/match_badge.dart';
import '../../../shared/widgets/expandable_text.dart';
import 'models/job_match_model.dart';
import 'services/results_service.dart';

class JobMatchScreen extends StatefulWidget {
  final List<JobMatchResult>? savedMatches;

  const JobMatchScreen({super.key, this.savedMatches});

  @override
  State<JobMatchScreen> createState() => _JobMatchScreenState();
}

enum _LoadState { loading, success, error }

class _JobMatchScreenState extends State<JobMatchScreen> {
  final _service = ResultsService();
  
  _LoadState _state = _LoadState.loading;
  String _errorMsg = '';
  List<JobMatchResult> _matches = [];

  // Datos dummy para el skeleton
  final _dummyMatches = List.generate(3, (index) => JobMatchResult(
    jobRoleId: 'dummy',
    jobRoleName: 'Cargando posición...',
    matchPercentage: 100,
    matchedCompetencies: ['Habilidad 1', 'Habilidad 2', 'Habilidad 3'],
    missingCompetencies: ['Habilidad 4', 'Habilidad 5'],
    estimatedMinSalary: 5000,
    estimatedMaxSalary: 8000,
    currency: 'USD',
    summary: 'Calculando compatibilidad de tu perfil con esta posición de acuerdo a los requerimientos del mercado actual...',
    searchQuery: 'Cargando',
  ));

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _state = _LoadState.loading);
    try {
      if (widget.savedMatches != null) {
        _matches = widget.savedMatches!;
      } else {
        _matches = await _service.fetchJobMatches();
      }
      setState(() => _state = _LoadState.success);
    } catch (e) {
      setState(() {
        _errorMsg = e.toString().replaceAll('Exception: ', '');
        _state = _LoadState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      extendBodyBehindAppBar: true,
      appBar: const ValoraAppBar(
        title: 'Compatibilidad Laboral',
        showBackButton: true,
      ),
      body: AnimatedAppBackground(
        child: SafeArea(
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_state == _LoadState.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.space24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.colorError),
              const SizedBox(height: AppSpacing.space16),
              Text(
                _errorMsg,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.space24),
              ElevatedButton(
                onPressed: _loadData,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (_state == _LoadState.success && _matches.isEmpty) {
      return const Center(
        child: Text(
          'No encontramos posiciones compatibles.\nIntenta agregar más habilidades a tu perfil.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textMuted),
        ),
      );
    }

    final isLoading = _state == _LoadState.loading;
    final displayMatches = isLoading ? _dummyMatches : _matches;

    return Column(
      children: [
        if (isLoading)
          const Padding(
            padding: EdgeInsets.fromLTRB(AppSpacing.space24, AppSpacing.space24, AppSpacing.space24, 0),
            child: DynamicLoadingMessage(
              messages: [
                'Buscando posiciones compatibles...',
                'Evaluando tus competencias...',
                'Calculando porcentaje de match...',
                'Ordenando mejores opciones...',
              ],
            ),
          ),
        Expanded(
          child: Skeletonizer(
            enabled: isLoading,
            effect: const ShimmerEffect(
              baseColor: AppColors.bgSurface,
              highlightColor: AppColors.borderDefault,
              duration: Duration(seconds: 2),
            ),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.space24),
              itemCount: displayMatches.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.space24),
              itemBuilder: (context, index) {
                if (isLoading) {
                  return _JobMatchCardSkeleton(match: displayMatches[index], rank: index + 1);
                }
                return JobMatchCard(match: displayMatches[index], rank: index + 1)
                    .animate(delay: (index * 100).ms)
                    .fade(duration: 400.ms)
                    .slideY(begin: 0.05, curve: Curves.easeOut);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class JobMatchCard extends StatelessWidget {
  const JobMatchCard({super.key, required this.match, required this.rank});

  final JobMatchResult match;
  final int rank;

  Future<void> _launchGoogleJobs() async {
    // Buscar empleos en Google Jobs con el query optimizado por IA
    final query = Uri.encodeComponent(match.searchQuery);
    final url = Uri.parse('https://www.google.com/search?q=$query&ibp=htl;jobs');
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDefault),
      ),
      padding: const EdgeInsets.all(AppSpacing.space20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.silver.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '#$rank',
                  style: const TextStyle(
                    color: AppColors.silver,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(match.jobRoleName, style: AppTextStyles.subtitle.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      '\$${Formatters.formatThousands(match.estimatedMinSalary)} - \$${Formatters.formatThousands(match.estimatedMaxSalary)} ${match.currency} / mes',
                      style: const TextStyle(
                        color: AppColors.silver,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getMatchColor(match.matchPercentage).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _getMatchColor(match.matchPercentage).withValues(alpha: 0.3)),
                ),
                child: Text(
                  '${match.matchPercentage}%',
                  style: TextStyle(
                    color: _getMatchColor(match.matchPercentage),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space16),
          ExpandableText(
            text: match.summary,
            maxLines: 3,
            style: const TextStyle(color: AppColors.silver, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: AppSpacing.space16),
          if (match.matchedCompetencies.isNotEmpty) ...[
            const Text('Habilidades que tienes:', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: match.matchedCompetencies.map((c) => MatchBadge(label: c, hasIt: true)).toList(),
            ),
            const SizedBox(height: AppSpacing.space16),
          ],
          if (match.missingCompetencies.isNotEmpty) ...[
            const Text('Áreas de oportunidad:', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: match.missingCompetencies.map((c) => MatchBadge(label: c, hasIt: false)).toList(),
            ),
            const SizedBox(height: AppSpacing.space16),
          ],
          const SizedBox(height: AppSpacing.space8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _launchGoogleJobs,
              icon: const Icon(Icons.search, size: 20),
              label: const Text('Ver ofertas reales'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bgSurface,
                foregroundColor: AppColors.silverHover,
                side: const BorderSide(color: AppColors.borderStrong),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getMatchColor(int percentage) {
    if (percentage >= 80) return AppColors.colorSuccess;
    if (percentage >= 60) return AppColors.colorWarning;
    return AppColors.colorError;
  }
}

class _JobMatchCardSkeleton extends StatelessWidget {
  const _JobMatchCardSkeleton({required this.match, required this.rank});

  final JobMatchResult match;
  final int rank;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDefault),
      ),
      padding: const EdgeInsets.all(AppSpacing.space20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.silver.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text('#$rank'),
              ),
              const SizedBox(width: AppSpacing.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(match.jobRoleName, style: AppTextStyles.subtitle),
                    const SizedBox(height: 4),
                    const Text('\$5,000 - \$8,000 USD / mes'),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.silver.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('100%'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space16),
          Text(match.summary, maxLines: 3),
          const SizedBox(height: AppSpacing.space16),
          const Text('Habilidades que tienes:'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: match.matchedCompetencies.map((c) => _SkeletonBadge(label: c)).toList(),
          ),
          const SizedBox(height: AppSpacing.space16),
          const Text('Áreas de oportunidad:'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: match.missingCompetencies.map((c) => _SkeletonBadge(label: c)).toList(),
          ),
          const SizedBox(height: AppSpacing.space24),
          const SizedBox(
            width: double.infinity,
            height: 48,
          ),
        ],
      ),
    );
  }
}

class _SkeletonBadge extends StatelessWidget {
  final String label;

  const _SkeletonBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.silver.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.silver.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, color: AppColors.silver),
      ),
    );
  }
}
