import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/valora_app_bar.dart';
import '../../../shared/widgets/match_badge.dart';
import 'models/job_match_model.dart';
import 'services/results_service.dart';

class JobMatchScreen extends StatefulWidget {
  final List<JobMatchResult>? savedMatches;

  const JobMatchScreen({super.key, this.savedMatches});

  @override
  State<JobMatchScreen> createState() => _JobMatchScreenState();
}

class _JobMatchScreenState extends State<JobMatchScreen> {
  final _service = ResultsService();
  late Future<List<JobMatchResult>> _future;

  @override
  void initState() {
    super.initState();
    if (widget.savedMatches != null) {
      _future = Future.value(widget.savedMatches!);
    } else {
      _future = _service.fetchJobMatches();
    }
  }

  void _retry() {
    setState(() => _future = _service.fetchJobMatches());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: const ValoraAppBar(title: 'Compatibilidad Laboral'),
      body: FutureBuilder<List<JobMatchResult>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(strokeWidth: 2, color: AppColors.silver),
                  SizedBox(height: AppSpacing.space16),
                  Text('Analizando tu perfil con IA...', style: TextStyle(color: AppColors.textMuted)),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.space24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.colorError),
                    const SizedBox(height: AppSpacing.space16),
                    Text(
                      '${snapshot.error}'.replaceAll('Exception: ', ''),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: AppSpacing.space24),
                    ElevatedButton(
                      onPressed: _retry,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final matches = snapshot.data ?? [];

          if (matches.isEmpty) {
            return const Center(
              child: Text(
                'No encontramos posiciones compatibles.\nIntenta agregar más habilidades a tu perfil.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.space24),
            itemCount: matches.length,
            separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.space24),
            itemBuilder: (context, index) {
              return JobMatchCard(match: matches[index], rank: index + 1);
            },
          );
        },
      ),
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
          Text(
            match.summary,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 14, height: 1.4),
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
