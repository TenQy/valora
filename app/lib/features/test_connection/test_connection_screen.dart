import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_card.dart';

class TestConnectionScreen extends StatelessWidget {
  const TestConnectionScreen({super.key});

  Future<Map<String, List<Map<String, dynamic>>>> _fetchCatalogs() async {
    final client = Supabase.instance.client;
    final responses = await Future.wait([
      client
          .from('professional_areas')
          .select('id, name, description')
          .order('name'),
      client
          .from('competencies')
          .select('id, name, category, description')
          .order('name'),
    ]);

    return {
      'areas': List<Map<String, dynamic>>.from(responses[0]),
      'competencies': List<Map<String, dynamic>>.from(responses[1]),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba Supabase')),
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: _fetchCatalogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.space24),
              child: Center(
                child: Text(
                  'Error al consultar Supabase:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body,
                ),
              ),
            );
          }

          final catalogs = snapshot.data ?? {};
          final areas = catalogs['areas'] ?? [];
          final competencies = catalogs['competencies'] ?? [];

          if (areas.isEmpty && competencies.isEmpty) {
            return const Center(child: Text('No hay catalogos registrados.'));
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.space24),
            children: [
              Text(
                'Areas profesionales',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.space12),
              if (areas.isEmpty)
                const Text('No hay areas profesionales registradas.')
              else
                ...areas.map((area) {
                  final description = area['description'] as String?;

                  return _CatalogCard(
                    title: area['name'] as String,
                    subtitle: description,
                  );
                }),
              const SizedBox(height: AppSpacing.space24),
              Text(
                'Competencias',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.space12),
              if (competencies.isEmpty)
                const Text('No hay competencias registradas.')
              else
                ...competencies.map((competency) {
                  final category = competency['category'] as String?;
                  final description = competency['description'] as String?;

                  return _CatalogCard(
                    title: competency['name'] as String,
                    subtitle: [
                      if (category != null && category.isNotEmpty)
                        'Categoria: $category',
                      if (description != null && description.isNotEmpty)
                        description,
                    ].join('\n'),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

class _CatalogCard extends StatelessWidget {
  const _CatalogCard({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space12),
      child: AppCard(
        showShadow: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.space8),
              Text(subtitle!, style: AppTextStyles.compactBody),
            ],
          ],
        ),
      ),
    );
  }
}
