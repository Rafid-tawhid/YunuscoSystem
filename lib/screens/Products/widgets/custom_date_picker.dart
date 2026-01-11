import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A smart, reusable date picker widget
/// Features:
/// - Shows formatted date
/// - Customizable label
/// - Emits selected date to parent
/// - Works inside forms or standalone
class SmartDatePicker extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const SmartDatePicker({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: firstDate ?? DateTime(2000),
          lastDate: lastDate ?? DateTime(2100),
        );

        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          selectedDate != null
              ? DateFormat('dd MMM yyyy').format(selectedDate!)
              : 'Select date',
          style: TextStyle(
            color: selectedDate != null
                ? Colors.black
                : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
