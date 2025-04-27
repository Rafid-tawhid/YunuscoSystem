import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DepartmentChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Function(bool) onSelected;
  final Color color;

  const DepartmentChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black,
      ),
      selectedColor: color,
      iconTheme: IconThemeData(
        color: selected ? Colors.white : Colors.black,
      ),
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}