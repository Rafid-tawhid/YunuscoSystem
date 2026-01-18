import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/machine_breakdown_dropdown.dart';
import '../../../providers/riverpods/production_provider.dart';

// Option 1: ConsumerWidget (Recommended)
class ProductionLineDropdown extends ConsumerWidget {
  final String label;
  final ProductionLines? selectedLine;
  final Function(ProductionLines?) onChanged;

  const ProductionLineDropdown({
    super.key,
    required this.label,
    required this.selectedLine,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dropdownDataAsync = ref.watch(machineDropdownDataProvider);

    return dropdownDataAsync.when(
      data: (dropdownData) {
        final lines = dropdownData.productionLines ?? [];
        return _buildGenericDropdown<ProductionLines>(
          label: label,
          value: selectedLine,
          items: lines,
          displayText: (line) => line.name ?? line.shortName ?? 'Unknown',
          hintText: 'Select Production Line',
          onChanged: onChanged,
        );
      },
      loading: () => _buildLoadingDropdown(label: label),
      error: (error, stackTrace) => _buildErrorDropdown(label: label, error: error.toString()),
    );
  }
}

// Option 2: Consumer as a widget parameter
Widget buildProductionLineDropdown({
  required WidgetRef ref,
  required String label,
  required ProductionLines? selectedLine,
  required Function(ProductionLines?) onChanged,
}) {
  final dropdownDataAsync = ref.watch(machineDropdownDataProvider);

  return dropdownDataAsync.when(
    data: (dropdownData) {
      final lines = dropdownData.productionLines ?? [];
      return _buildGenericDropdown<ProductionLines>(
        label: label,
        value: selectedLine,
        items: lines,
        displayText: (line) => line.name ?? line.shortName ?? 'Unknown',
        hintText: 'Select Production Line',
        onChanged: onChanged,
      );
    },
    loading: () => _buildLoadingDropdown(label: label),
    error: (error, stackTrace) => _buildErrorDropdown(label: label, error: error.toString()),
  );
}

// Helper method for loading state
Widget _buildLoadingDropdown({required String label}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    ],
  );
}

// Helper method for error state
Widget _buildErrorDropdown({required String label, required String error}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red[300]!),
          borderRadius: BorderRadius.circular(8),
          color: Colors.red[50],
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Error: $error',
                style: const TextStyle(color: Colors.red, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

// Generic dropdown builder (unchanged)
Widget _buildGenericDropdown<T>({
  required String label,
  required T? value,
  required List<T> items,
  required String Function(T) displayText,
  required String hintText,
  required Function(T?) onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            hint: Text(
              hintText,
              style: TextStyle(color: Colors.grey[500]),
            ),
            items: items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  displayText(item),
                  style: const TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: onChanged,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 24,
          ),
        ),
      ),
    ],
  );
}