import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/valora_searchable_dropdown.dart';
import '../models/catalog_models.dart';
import '../services/profile_repository.dart';

class AddCertificationDialog extends StatefulWidget {
  const AddCertificationDialog({
    super.key,
    required this.issuersCatalog,
    required this.repository,
  });

  final List<CertificationIssuerItem> issuersCatalog;
  final ProfileRepository repository;

  @override
  State<AddCertificationDialog> createState() => _AddCertificationDialogState();
}

class _AddCertificationDialogState extends State<AddCertificationDialog> {
  final _nameCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  CertificationIssuerItem? _selectedIssuer;
  bool _isValidating = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.bgSurface,
      title: const Text('Agregar Certificación', style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Nombre de certificación',
                hintText: 'ej. AWS Cloud Practitioner',
              ),
            ),
            const SizedBox(height: AppSpacing.space12),
            ValoraSearchableDropdown<CertificationIssuerItem>(
              label: 'Institución / Emisor',
              value: _selectedIssuer,
              items: widget.issuersCatalog,
              itemLabel: (issuer) => issuer.name,
              onChanged: (val) => setState(() => _selectedIssuer = val),
            ),
            const SizedBox(height: AppSpacing.space12),
            TextFormField(
              controller: _dateCtrl,
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
                  _dateCtrl.text = picked.toIso8601String().split('T').first;
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
          onPressed: (_selectedIssuer == null || _isValidating)
              ? null
              : () async {
                  final certName = _nameCtrl.text.trim();
                  if (certName.isEmpty) return;
                  
                  setState(() => _isValidating = true);
                  try {
                    final isValid = await widget.repository.validateText(certName, 'certification');
                    
                    if (!isValid) {
                      if (!context.mounted) return;
                      setState(() => _isValidating = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ese nombre de certificación no parece válido.'),
                          backgroundColor: AppColors.colorError,
                        ),
                      );
                      return;
                    }
                    
                    final result = EditableUserCertification(
                      name: certName,
                      issuer: _selectedIssuer!.name,
                      issueDate: _dateCtrl.text.trim(),
                    );
                    if (context.mounted) Navigator.of(context).pop(result);
                  } catch (e) {
                    if (!context.mounted) return;
                    setState(() => _isValidating = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error validando: $e'),
                        backgroundColor: AppColors.colorError,
                        duration: const Duration(seconds: 4),
                      ),
                    );
                  }
                },
          child: _isValidating 
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Agregar'),
        ),
      ],
    );
  }
}
