import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../common_widgets/image_picker.dart';

class MisAssetInventoryScreen extends StatefulWidget {
  const MisAssetInventoryScreen({super.key});

  @override
  State<MisAssetInventoryScreen> createState() =>
      _MisAssetInventoryScreenState();
}

class _MisAssetInventoryScreenState extends State<MisAssetInventoryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Variables to store selected images
  File? _frontSideImage;
  File? _screenPartImage;
  File? _backSideImage;
  File? _keyPartImage;

  // Controllers for text fields
  final TextEditingController _assetNoController = TextEditingController();
  final TextEditingController _assetTypeController = TextEditingController();
  final TextEditingController _hostNameController = TextEditingController();
  final TextEditingController _ipAddressController = TextEditingController();
  final TextEditingController _ipAddress2Controller = TextEditingController();
  final TextEditingController _iaGroupController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _adNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _idCardNoController = TextEditingController();
  final TextEditingController _employeeNameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _serialNoMacController = TextEditingController();
  final TextEditingController _manufacturerController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _mBoardController = TextEditingController();
  final TextEditingController _processorController = TextEditingController();
  final TextEditingController _processorGenController = TextEditingController();
  final TextEditingController _speedController = TextEditingController();
  final TextEditingController _storageController = TextEditingController();
  final TextEditingController _ramController = TextEditingController();
  final TextEditingController _purchaseDateController = TextEditingController();
  final TextEditingController _purchasePriceController =
      TextEditingController();
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _warrantyController = TextEditingController();
  final TextEditingController _installedOsController = TextEditingController();
  final TextEditingController _licenseOsController = TextEditingController();
  final TextEditingController _serialNoOsController = TextEditingController();
  final TextEditingController _antivirusLicenseController =
      TextEditingController();
  final TextEditingController _officeLicenseController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _transferDateController = TextEditingController();
  final TextEditingController _deviceHistoryController =
      TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'MIS ASSET INVENTORY',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Text(
                  'MIS ASSET INVENTORY',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: myColors.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Asset No section
              _buildSectionHeader('Asset No.:'),
              _buildTextField('Asset Type', _assetTypeController),
              _buildTextField('Host Name', _hostNameController),
              _buildTextField('IP Address', _ipAddressController),
              _buildTextField('IP Address 2', _ipAddress2Controller),
              _buildTextField('IA Group', _iaGroupController),
              _buildTextField('Status', _statusController),
              _buildTextField('AD Name', _adNameController),
              _buildTextField('User Name', _userNameController),
              _buildTextField('IdCard No.:', _idCardNoController),
              _buildTextField('Employee Name:', _employeeNameController),
              _buildTextField('Designation', _designationController),
              _buildTextField('Department', _departmentController),
              _buildTextField('Section', _sectionController),
              _buildTextField('Location', _locationController),
              _buildTextField('Unit', _unitController),
              _buildTextField('Serial No/MAC:', _serialNoMacController),
              _buildTextField('Manufacturer', _manufacturerController),
              _buildTextField('Model', _modelController),
              _buildTextField('M Board:', _mBoardController),

              const SizedBox(height: 16),
              _buildDivider(),
              const SizedBox(height: 16),

              // Processor section
              _buildSectionHeader('Processor:'),
              _buildTextField('Processor Generation:', _processorGenController),
              _buildTextField('Speed (GHz):', _speedController),
              _buildTextField('Storage', _storageController),
              _buildTextField('RAM (GB):', _ramController),
              _buildTextField('Date of Purchase', _purchaseDateController),
              _buildTextField('Purchase Price', _purchasePriceController),
              _buildTextField('Supplier', _supplierController),
              _buildTextField('Warranty', _warrantyController),
              _buildTextField('Installed OS:', _installedOsController),
              _buildTextField('License OS:', _licenseOsController),
              _buildTextField('Serial No Of OS:', _serialNoOsController),
              _buildTextField(
                  'Antivirus License:', _antivirusLicenseController),
              _buildTextField('Office License:', _officeLicenseController),
              _buildTextField('Email Address:', _emailController),
              _buildTextField('Transfer Date:', _transferDateController),
              _buildTextField('Device History:', _deviceHistoryController),
              _buildTextField('Remarks:', _remarksController),

              const SizedBox(height: 16),
              _buildDivider(),
              const SizedBox(height: 16),

              // Photo upload section
              _buildPhotoUploadSection(),

              const SizedBox(height: 30),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'SUBMIT ASSET',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade400,
      thickness: 1,
    );
  }

  Widget _buildPhotoUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Photos:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: ImagePickerWidget(
              onImageSelected: (File? image) {
                // Handle image selection
              },
              buttonText: 'Click to upload Front Side',
              buttonHeight: 120,
              iconSize: 40,
              fontSize: 14,
            )),
            const SizedBox(width: 16),
            Expanded(
              child: ImagePickerWidget(
                onImageSelected: (File? image) {
                  // Handle image selection
                },
                //Click to upload Screen Part
                buttonText: 'Click to upload Screen Part',
                buttonHeight: 120,
                iconSize: 40,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: ImagePickerWidget(
              onImageSelected: (File? image) {
                // Handle image selection
              },
              //Click to upload Screen Part
              buttonText: 'Click to upload Back Side',
              buttonHeight: 120,
              iconSize: 40,
              fontSize: 14,
            )),
            //
            const SizedBox(width: 16),
            Expanded(child: ImagePickerWidget(
              onImageSelected: (File? image) {
                // Handle image selection
              },
              //Click to upload Screen Part
              buttonText: 'Click to upload Key Part',
              buttonHeight: 120,
              iconSize: 40,
              fontSize: 14,
            )),
          ],
        ),
      ],
    );
  }

  void _showImageSourceDialog(String label) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Upload $label'),
        content: const Text('Choose image source'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement camera capture
            },
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement gallery picker
            },
            child: const Text('Gallery'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Handle form submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Asset submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    _assetNoController.dispose();
    _assetTypeController.dispose();
    _hostNameController.dispose();
    _ipAddressController.dispose();
    _ipAddress2Controller.dispose();
    _iaGroupController.dispose();
    _statusController.dispose();
    _adNameController.dispose();
    _userNameController.dispose();
    _idCardNoController.dispose();
    _employeeNameController.dispose();
    _designationController.dispose();
    _departmentController.dispose();
    _sectionController.dispose();
    _locationController.dispose();
    _unitController.dispose();
    _serialNoMacController.dispose();
    _manufacturerController.dispose();
    _modelController.dispose();
    _mBoardController.dispose();
    _processorController.dispose();
    _processorGenController.dispose();
    _speedController.dispose();
    _storageController.dispose();
    _ramController.dispose();
    _purchaseDateController.dispose();
    _purchasePriceController.dispose();
    _supplierController.dispose();
    _warrantyController.dispose();
    _installedOsController.dispose();
    _licenseOsController.dispose();
    _serialNoOsController.dispose();
    _antivirusLicenseController.dispose();
    _officeLicenseController.dispose();
    _emailController.dispose();
    _transferDateController.dispose();
    _deviceHistoryController.dispose();
    _remarksController.dispose();
    super.dispose();
  }
}
