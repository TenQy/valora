import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TestConnectionScreen extends StatelessWidget {
  const TestConnectionScreen({super.key});

  Future<List<Map<String, dynamic>>> _fetchProfessionalAreas() async {
    final response = await Supabase.instance.client
        .from('professional_areas')
        .select('id, name, description')
        .order('name');

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba Supabase')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchProfessionalAreas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Error al consultar Supabase:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final areas = snapshot.data ?? [];

          if (areas.isEmpty) {
            return const Center(
              child: Text('No hay áreas profesionales registradas.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: areas.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final area = areas[index];
              final description = area['description'] as String?;

              return Card(
                child: ListTile(
                  title: Text(
                    area['name'] as String,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: description == null || description.isEmpty
                      ? null
                      : Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(description),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
