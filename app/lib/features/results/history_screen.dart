import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../shared/widgets/valora_app_bar.dart';
import 'package:flutter_animate/flutter_animate.dart' hide ShimmerEffect;

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _client = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _historyFuture = _fetchHistory();
    });
  }

  Future<List<Map<String, dynamic>>> _fetchHistory() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final profileRes = await _client
        .from('profiles')
        .select('id')
        .eq('user_id', userId)
        .maybeSingle();

    if (profileRes == null) return [];

    final profileId = profileRes['id'] as String;

    return await _client
        .from('salary_estimations')
        .select()
        .eq('profile_id', profileId)
        .order('created_at', ascending: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      extendBodyBehindAppBar: true,
      appBar: const ValoraAppBar(
        title: 'Historial de Estimaciones',
        showBackButton: true,
      ),
      body: AnimatedAppBackground(
        child: SafeArea(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _historyFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.silver),
                );
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: AppColors.colorError)));
              }

              final data = snapshot.data;
              if (data == null || data.isEmpty) {
                return const Center(
                  child: Text(
                    'Aún no tienes estimaciones guardadas.',
                    style: TextStyle(color: AppColors.silverMuted),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.space24),
                itemCount: data.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final row = data[index];
                  final dateStr = row['created_at'] as String?;
                  final date = dateStr != null ? DateTime.tryParse(dateStr) : null;
                  final formattedDate = date != null ? '${date.day}/${date.month}/${date.year}' : 'Desconocida';
                  
                  final min = (row['estimated_min_salary'] as num?)?.toInt() ?? 0;
                  final max = (row['estimated_max_salary'] as num?)?.toInt() ?? 0;
                  final cur = row['currency'] ?? 'MXN';

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.bgSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderDefault),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Fecha: $formattedDate', style: const TextStyle(color: AppColors.silverMuted, fontSize: 13)),
                            if (index == 0)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.silver.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text('ACTUAL', style: TextStyle(color: AppColors.silver, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${Formatters.formatThousands(min)} - \$${Formatters.formatThousands(max)} $cur',
                          style: const TextStyle(color: AppColors.silver, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ).animate(delay: (index * 50).ms).fade(duration: 400.ms).slideX(begin: 0.05, curve: Curves.easeOut);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
