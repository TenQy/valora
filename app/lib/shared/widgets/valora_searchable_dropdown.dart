import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Dropdown/Selector personalizado con búsqueda, límite de scroll (~6-7 items)
/// y diseño oscuro acorde al sistema de diseño.
class ValoraSearchableDropdown<T> extends FormField<T> {
  ValoraSearchableDropdown({
    super.key,
    required String label,
    required T? value,
    required List<T> items,
    required String Function(T item) itemLabel,
    String Function(T item)? itemSubLabel,
    required ValueChanged<T?> onChanged,
    super.validator,
    String? hintText,
  }) : super(
          initialValue: value,
          builder: (FormFieldState<T> state) {
            final selectedItem = value;
            final displayText = selectedItem != null
                ? itemLabel(selectedItem)
                : (hintText ?? 'Seleccionar...');

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () async {
                    FocusScope.of(state.context).unfocus();
                    final picked = await showModalBottomSheet<T>(
                      context: state.context,
                      backgroundColor: AppColors.bgSurface,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) {
                        return _SearchBottomSheet<T>(
                          title: label,
                          items: items,
                          selectedItem: value,
                          itemLabel: itemLabel,
                          itemSubLabel: itemSubLabel,
                        );
                      },
                    );

                    if (picked != null) {
                      state.didChange(picked);
                      onChanged(picked);
                    }
                  },
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: label,
                      errorText: state.errorText,
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.silverMuted,
                      ),
                    ),
                    child: Text(
                      displayText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: selectedItem != null
                            ? Colors.white
                            : AppColors.textPlaceholder,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
}

class _SearchBottomSheet<T> extends StatefulWidget {
  const _SearchBottomSheet({
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.itemLabel,
    this.itemSubLabel,
  });

  final String title;
  final List<T> items;
  final T? selectedItem;
  final String Function(T item) itemLabel;
  final String Function(T item)? itemSubLabel;

  @override
  State<_SearchBottomSheet<T>> createState() => _SearchBottomSheetState<T>();
}

class _SearchBottomSheetState<T> extends State<_SearchBottomSheet<T>> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.items.where((item) {
      if (_query.trim().isEmpty) return true;
      final label = widget.itemLabel(item).toLowerCase();
      final sub = widget.itemSubLabel?.call(item).toLowerCase() ?? '';
      final q = _query.trim().toLowerCase();
      return label.contains(q) || sub.contains(q);
    }).toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppSpacing.space20,
        right: AppSpacing.space20,
        top: AppSpacing.space20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textMuted),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space12),

          TextField(
            controller: _searchController,
            autofocus: widget.items.length > 5,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Buscar...',
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.silverMuted,
                size: 20,
              ),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        size: 18,
                        color: AppColors.textMuted,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
            ),
            onChanged: (val) => setState(() => _query = val),
          ),
          const SizedBox(height: AppSpacing.space16),

          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 320),
            child: filtered.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.space24),
                    child: Center(
                      child: Text(
                        'No se encontraron resultados',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) =>
                        const Divider(color: AppColors.borderSubtle, height: 1),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final isSelected = item == widget.selectedItem;
                      final label = widget.itemLabel(item);
                      final subLabel = widget.itemSubLabel?.call(item);

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.space12,
                          vertical: AppSpacing.space4,
                        ),
                        title: Text(
                          label,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.colorSuccess
                                : Colors.white,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: subLabel != null
                            ? Text(
                                subLabel,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 12,
                                ),
                              )
                            : null,
                        trailing: isSelected
                            ? const Icon(
                                Icons.check,
                                color: AppColors.colorSuccess,
                                size: 20,
                              )
                            : null,
                        onTap: () => Navigator.of(context).pop(item),
                      );
                    },
                  ),
          ),
          const SizedBox(height: AppSpacing.space20),
        ],
      ),
    );
  }
}
