import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String Function(T) displayText;
  final ValueChanged<T?> onChanged;
  final String hintText;
  final double menuMaxHeight;

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.value,
    required this.displayText,
    required this.onChanged,
    this.hintText = 'Select',
    this.menuMaxHeight = 240,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonFormField<T>(
        value: value,
        isExpanded: true,
        hint: Text(hintText),
        icon: const Icon(Icons.keyboard_arrow_down),
        decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        dropdownColor: Colors.white,
        menuMaxHeight: menuMaxHeight, // This controls the max height of the dropdown menu
        style: const TextStyle(fontSize: 16, color: Colors.black),
        selectedItemBuilder: (BuildContext context) {
          return items.map<Widget>((T item) {
            return Text(
              value != null ? displayText(value as T) : hintText,
              style: const TextStyle(fontSize: 16),
            );
          }).toList();
        },
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              displayText(item),
              style: const TextStyle(fontSize: 16),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}