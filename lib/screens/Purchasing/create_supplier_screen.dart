import 'package:flutter/material.dart';
import 'package:yunusco_group/utils/colors.dart';


class SupplierFormScreen extends StatefulWidget {
  const SupplierFormScreen({super.key});

  @override
  State<SupplierFormScreen> createState() => _SupplierFormScreenState();
}

class _SupplierFormScreenState extends State<SupplierFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _swiftCodeController = TextEditingController();
  final TextEditingController _supplierCodeController = TextEditingController();

  String _statusValue = 'Local';
  String _countryValue = 'United States';
  String _accountTypeValue = 'Brac-1101';

  final List<String> _statusOptions = ['Local','Global'];
  final List<String> _countryOptions = [
    'United States', 'United Kingdom', 'Canada', 'Australia', 'Germany',
    'France', 'Japan', 'China', 'India', 'Brazil', 'Mexico', 'Bangladesh'
  ];
  final List<String> _accountTypeOptions = [
    'Brac-1101', 'Brac-1102', 'Brac-1103'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Supplier Information Form'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Supplier Name #', _nameController, true),
              const SizedBox(height: 16),
              _buildTextField('Supplier Address', _addressController, false, maxLines: 3),
              const SizedBox(height: 16),
              _buildCountryDropdown(),
              const SizedBox(height: 16),
              _buildTextField('Supplier Website', _websiteController, false),
              const SizedBox(height: 16),
              _buildTextField('Supplier Conf. Person', _contactPersonController, true),
              const SizedBox(height: 16),
              _buildTextField('Person\'s Designation', _designationController, false),
              const SizedBox(height: 16),
              _buildTextField('Supplier Bank', _bankController, true),
              const SizedBox(height: 16),
              _buildTextField('SWIFT Code', _swiftCodeController, false),
              const SizedBox(height: 16),
              _buildTextField('Supplier Code', _supplierCodeController, true),
              const SizedBox(height: 16),
              _buildStatusDropdown(),
              const SizedBox(height: 16),
              _buildAccountTypeDropdown(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool required, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label + (required ? ' *' : ''),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      maxLines: maxLines,
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  Widget _buildStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status *',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey[400]!),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonFormField<String>(
            value: _statusValue,
            items: _statusOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _statusValue = newValue!;
              });
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            isExpanded: true,
          ),
        ),
      ],
    );
  }

  Widget _buildCountryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Supplier Country *',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey[400]!),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonFormField<String>(
            value: _countryValue,
            items: _countryOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _countryValue = newValue!;
              });
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            isExpanded: true,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Type # *',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey[400]!),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonFormField<String>(
            value: _accountTypeValue,
            items: _accountTypeOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _accountTypeValue = newValue!;
              });
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            isExpanded: true,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Form is valid, process the data
            final supplierData = {
              'Supplier Name': _nameController.text,
              'Supplier Address': _addressController.text,
              'Supplier Country': _countryValue,
              'Supplier Website': _websiteController.text,
              'Contact Person': _contactPersonController.text,
              'Designation': _designationController.text,
              'Supplier Bank': _bankController.text,
              'SWIFT Code': _swiftCodeController.text,
              'Supplier Code': _supplierCodeController.text,
              'Status': _statusValue,
              'Account Type': _accountTypeValue,
            };
            debugPrint(supplierData.toString());
            _showSuccessDialog();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: myColors.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Text(
          'Save Supplier Information',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Supplier information has been saved successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _nameController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    _contactPersonController.dispose();
    _designationController.dispose();
    _bankController.dispose();
    _swiftCodeController.dispose();
    _supplierCodeController.dispose();
    super.dispose();
  }
}