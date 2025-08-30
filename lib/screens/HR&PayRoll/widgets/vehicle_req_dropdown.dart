import 'package:flutter/material.dart';

class VehiclePurposeDropdown extends StatefulWidget {
  final ValueChanged<String> onPurposeSelected;
  final String? initialValue;

  const VehiclePurposeDropdown({
    super.key,
    required this.onPurposeSelected,
    this.initialValue,
  });

  @override
  State<VehiclePurposeDropdown> createState() => _VehiclePurposeDropdownState();
}

class _VehiclePurposeDropdownState extends State<VehiclePurposeDropdown> {
  String? _selectedPurpose;

  final List<String> _vehiclePurposes = [
    'Official Meeting',
    'Site Visit',
    'Client Visit',
    'Airport Pickup/Drop',
    'Office Errand',
    'Training Program',
    'Conference/Seminar',
    'Bank Work',
    'Government Office',
    'Material Transport',
    'Goods to Carry',
    'Field Work',
    'Emergency Duty',
    'Guest Transportation',
    'Other Official Work'
  ];

  @override
  void initState() {
    super.initState();
    _selectedPurpose = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedPurpose,
      decoration: InputDecoration(
        labelText: 'Purpose of Requisition',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      items: _vehiclePurposes.map((String purpose) {
        return DropdownMenuItem<String>(
          value: purpose,
          child: Text(purpose),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedPurpose = newValue;
        });
        if (newValue != null) {
          widget.onPurposeSelected(newValue);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a purpose';
        }
        return null;
      },
    );
  }
}
