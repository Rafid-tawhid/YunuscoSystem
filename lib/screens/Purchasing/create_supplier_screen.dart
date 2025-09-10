import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/product_provider.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../common_widgets/select_image.dart';
import '../../providers/hr_provider.dart';
import '../../utils/constants.dart';

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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _swiftCodeController = TextEditingController();
  final TextEditingController _supplierCodeController = TextEditingController();
  final TextEditingController _othersCodeController = TextEditingController();

  String _statusValue = 'Local';
  var _selectedCountryId; // store selected country id
  String _accountTypeValue = 'Brac-1101';
  PlatformFile? _selectedImage;

  final List<String> _statusOptions = ['Local', 'Global'];

  final List<String> _accountTypeOptions = ['Brac-1101', 'Brac-1102', 'Brac-1103'];
  List<String> banks = ['BRAC BANK Ltd.', 'Dutch Bangla Bank Limited', 'HSBC 2', 'HSBC 3', 'HSBC 4', 'Prime Bank Limited', 'South East Bank', 'Standard Chartered Bank Ltd.'];
  String? selectedBank;

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
              _buildTextField('Supplier Email', _emailController, false),
              const SizedBox(height: 16),
              _buildTextField('Supplier Conf. Person', _contactPersonController, true),
              const SizedBox(height: 16),
              _buildTextField('Supplier Contact No.', _contactNumberController, true),
              const SizedBox(height: 16),
              _buildTextField('Person\'s Designation', _designationController, false),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedBank,
                decoration: InputDecoration(
                  labelText: 'Select Bank',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: banks.map((String bank) {
                  return DropdownMenuItem<String>(
                    value: bank,
                    child: Text(
                      bank,
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedBank = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value == 'Select Bank') {
                    return 'Please select a bank';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField('Supplier Bank No.', _bankController, true),
              const SizedBox(height: 16),
              _buildTextField('SWIFT Code', _swiftCodeController, false),
              const SizedBox(height: 16),
              _buildTextField('Supplier Code', _supplierCodeController, true),
              const SizedBox(height: 16),
              _buildTextField('Others', _othersCodeController, true),
              const SizedBox(height: 16),
              _buildStatusDropdown(),
              const SizedBox(height: 16),
              _buildAccountTypeDropdown(),
              const SizedBox(height: 16),
              FilePickerRow(
                buttonText: 'Upload Document',
                onFileSelected: (PlatformFile file) {
                  print('Selected file: ${file.name}');
                  _selectedImage=file;
                  // Handle the file
                },
              ),
              const SizedBox(height: 24),
              _buildSubmitButton(),
              const SizedBox(height: 24),
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
          'Supplier type *',
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
        CountrySearchField(
          onCountrySelected: (country) {
            _selectedCountryId = {
              "id": country['id'],
              "name": country['name'],
            };
            print("Selected Country: ${country['name']} ID: $_selectedCountryId");
          },
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
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            // Form is valid, process the data

            try {
              var request = http.MultipartRequest(
                'POST',
                Uri.parse('https://192.168.15.6:5630/api/inventory/CreateSupplier/'),
              );

              // Add headers
              request.headers['Authorization'] = 'Bearer ${AppConstants.token}';
              // Add fields
              request.fields['SupplierName'] = _nameController.text;
              request.fields['CountryId'] = _selectedCountryId['id'].toString();
              request.fields['Address'] = _addressController.text;
              request.fields['Email'] = _emailController.text;
              request.fields['Website'] = _websiteController.text;
              request.fields['Fax'] = '2323232323'; // Add this controller
              request.fields['ContactNumber'] = _contactNumberController.text; // Add this controller
              request.fields['CountryName'] = _selectedCountryId['name'].toString();
              request.fields['ContactPerson'] = _contactPersonController.text;
              request.fields['Designation'] = _designationController.text;
              request.fields['SupplierCategoryId'] = 'None';
              request.fields['BusinessType'] = _accountTypeValue;
              request.fields['Others'] = _othersCodeController.text;
              request.fields['SupplierBank'] = selectedBank ?? '';
              request.fields['BankAcc'] = _bankController.text; // Add this controller
              request.fields['SwiftCode'] = _swiftCodeController.text;
              request.fields['IsLocal'] = (_statusValue == 'Local').toString(); // Convert to string
              request.fields['AccountCode'] = ''; // Add this controller
              request.fields['SupplierId'] = _supplierCodeController.text;
              request.fields['CodeName'] = _supplierCodeController.text;

              if (_selectedImage != null) {
                // Get file extension to determine content type
                String extension = _selectedImage!.path!.split('.').last.toLowerCase();
                String contentType = 'application/octet-stream';

                if (extension == 'jpg' || extension == 'jpeg') {
                  contentType = 'image/jpeg';
                } else if (extension == 'png') {
                  contentType = 'image/png';
                } else if (extension == 'pdf') {
                  contentType = 'application/pdf';
                } else if (extension == 'gif') {
                  contentType = 'image/gif';
                }

                // Add the file to the request
                request.files.add(await http.MultipartFile.fromPath(
                  'files', // Field name (should match what API expects)
                  _selectedImage!.path??'',
                  filename: 'supplier_file.${extension}', // Optional: set filename
                  contentType: MediaType.parse(contentType), // Optional: set content type
                ));

                print('Adding file: ${_selectedImage!.path}');

                var response = await request.send();
                final responseBody = await response.stream.bytesToString();
                print('Response Status Code: ${response.statusCode}');
                print('Response Body: $responseBody');
              }
            } catch (e) {
              DashboardHelpers.showAlert(msg: '$e');
            }
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
    _contactNumberController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    _emailController.dispose();
    _contactPersonController.dispose();
    _designationController.dispose();
    _bankController.dispose();
    _swiftCodeController.dispose();
    _supplierCodeController.dispose();
    super.dispose();
  }
}

class CountrySearchField extends StatefulWidget {
  // Callback to pass selected country info to parent
  final void Function(Map<String, dynamic> selectedCountry)? onCountrySelected;

  const CountrySearchField({required this.onCountrySelected, Key? key}) : super(key: key);

  @override
  _CountrySearchFieldState createState() => _CountrySearchFieldState();
}

class _CountrySearchFieldState extends State<CountrySearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        return TypeAheadField<Map<String, dynamic>>(
          builder: (context, controller, focusNode) => TextField(
            controller: controller,
            focusNode: focusNode,
            style: DefaultTextStyle.of(context).style.copyWith(fontStyle: FontStyle.normal),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Select Supplier Country',
            ),
          ),
          controller: _controller,
          suggestionsCallback: (pattern) {
            return provider.searchStuffList(pattern);
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion['name']),
              subtitle: Text("ID: ${suggestion['id']}"),
            );
          },
          onSelected: (suggestion) {
            setState(() {
              _controller.text = suggestion['name'];
            });
            // ✅ Call the parent callback
            if (widget.onCountrySelected != null) {
              widget.onCountrySelected!(suggestion);
            }
            FocusScope.of(context).unfocus();
          },
        );
      },
    );
  }
}
