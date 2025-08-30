import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  // Form controllers
  final TextEditingController _modelNameController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _manufacturerController = TextEditingController();
  final TextEditingController _specificationsController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // Image handling
  final List<XFile> _productImages = [];
  final ImagePicker _imagePicker = ImagePicker();

  // UI state
  bool _isLoading = false;
  double _uploadProgress = 0.0;
  String _uploadStatus = '';

  // Categories
  final List<String> _categories = [
    'Smartphones',
    'Laptops',
    'Tablets',
    'Cameras',
    'Audio Devices',
    'Wearables',
    'Gaming Consoles',
    'Accessories',
    'Other'
  ];
  String _selectedCategory = 'Smartphones';

  // Conditions
  final List<String> _conditions = [
    'New',
    'Refurbished',
    'Used - Like New',
    'Used - Good',
    'Used - Fair'
  ];
  String _selectedCondition = 'New';

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await FirebaseAuth.instance.signInAnonymously();
    await Permission.storage.request();
    await Permission.photos.request();
    await Permission.mediaLibrary.request();
    await Permission.camera.request();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        setState(() {
          _productImages.addAll(images);
        });
      }
    } catch (e) {
      _showError('Failed to pick images: $e');
    }
  }

  Future<void> _captureImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 90,
      );

      if (image != null) {
        setState(() {
          _productImages.add(image);
        });
      }
    } catch (e) {
      _showError('Failed to capture image: $e');
    }
  }

  Future<void> _saveProduct() async {
    if (_productImages.isEmpty) {
      _showError('Please add at least one product image');
      return;
    }

    if (_modelNameController.text.isEmpty) {
      _showError('Please enter model name');
      return;
    }

    if (_serialNumberController.text.isEmpty) {
      _showError('Please enter serial number');
      return;
    }

    setState(() {
      _isLoading = true;
      _uploadProgress = 0.0;
      _uploadStatus = 'Saving product...';
    });

    try {
      // Generate unique ID for this product
      final String productId = const Uuid().v4();
      final DateTime now = DateTime.now();

      // Upload images to Firebase Storage
      List<String> imageUrls = [];
      for (int i = 0; i < _productImages.length; i++) {
        setState(() {
          _uploadProgress = 0.2 + (0.5 * (i + 1) / _productImages.length);
          _uploadStatus =
              'Uploading image ${i + 1}/${_productImages.length}...';
        });

        final imageUrl =
            await uploadImageWithoutAuth(_productImages[i], productId);
        imageUrls.add(imageUrl);
      }

      // Prepare product data
      final productData = {
        'id': productId,
        'timestamp': now,
        'modelName': _modelNameController.text,
        'serialNumber': _serialNumberController.text,
        'manufacturer': _manufacturerController.text,
        'category': _selectedCategory,
        'condition': _selectedCondition,
        'specifications': _specificationsController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'quantity': int.tryParse(_quantityController.text) ?? 1,
        'imageUrls': imageUrls,
        'status': 'Available'
      };

      // Save to Firestore
      setState(() {
        _uploadStatus = 'Saving product details...';
        _uploadProgress = 0.8;
      });

      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .set(productData);

      setState(() {
        _uploadProgress = 1.0;
        _uploadStatus = 'Product saved successfully!';
      });

      _showSuccess(
          'Product "${_modelNameController.text}" saved successfully!');
      _clearForm();
    } catch (e) {
      _showError('Failed to save product: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> uploadImageWithoutAuth(XFile image, String uniqueId) async {
    final ref = FirebaseStorage.instance.ref().child('uploads/$uniqueId.jpg');

    final uploadTask = ref.putFile(File(image.path));
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  void _clearForm() {
    setState(() {
      _modelNameController.clear();
      _serialNumberController.clear();
      _manufacturerController.clear();
      _specificationsController.clear();
      _priceController.clear();
      _quantityController.clear();
      _productImages.clear();
      _selectedCategory = 'Smartphones';
      _selectedCondition = 'New';
      _uploadProgress = 0.0;
      _uploadStatus = '';
    });
  }

  void _removeImage(int index) {
    setState(() {
      _productImages.removeAt(index);
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Electronic Product Catalog'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _clearForm,
            tooltip: 'Clear Form',
          ),
        ],
      ),
      body: _isLoading ? _buildProgressIndicator() : _buildProductForm(),
    );
  }

  Widget _buildProgressIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(value: _uploadProgress),
          const SizedBox(height: 20),
          Text(
            _uploadStatus,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            '${(_uploadProgress * 100).toStringAsFixed(0)}% complete',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildProductForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Images
          const Text(
            'Product Images',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Add clear images showing the product from different angles',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _pickImages,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Add from Gallery'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _captureImage,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take Photo'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Selected Images Preview
          if (_productImages.isNotEmpty) ...[
            Text(
              'Selected Images (${_productImages.length})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _productImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_productImages[index].path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.red,
                            child: IconButton(
                              icon: const Icon(Icons.close,
                                  size: 12, color: Colors.white),
                              onPressed: () => _removeImage(index),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Product Details
          const Text(
            'Product Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Model Name
          TextFormField(
            controller: _modelNameController,
            decoration: const InputDecoration(
              labelText: 'Model Name *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.model_training),
            ),
          ),
          const SizedBox(height: 12),

          // Serial Number
          TextFormField(
            controller: _serialNumberController,
            decoration: const InputDecoration(
              labelText: 'Serial Number *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.confirmation_number),
            ),
          ),
          const SizedBox(height: 12),

          // Manufacturer
          TextFormField(
            controller: _manufacturerController,
            decoration: const InputDecoration(
              labelText: 'Manufacturer',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.business),
            ),
          ),
          const SizedBox(height: 12),

          // Category Dropdown
          InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.category),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCategory,
                isExpanded: true,
                items: _categories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Condition Dropdown
          InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Condition',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.construction),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCondition,
                isExpanded: true,
                items: _conditions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCondition = newValue!;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Price
          TextFormField(
            controller: _priceController,
            decoration: const InputDecoration(
              labelText: 'Price (\$)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),

          // Quantity
          TextFormField(
            controller: _quantityController,
            decoration: const InputDecoration(
              labelText: 'Quantity',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.inventory),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),

          // Specifications
          TextFormField(
            controller: _specificationsController,
            decoration: const InputDecoration(
              labelText: 'Specifications & Features',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 24),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: const Text('SAVE PRODUCT TO CATALOG'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _modelNameController.dispose();
    _serialNumberController.dispose();
    _manufacturerController.dispose();
    _specificationsController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}
