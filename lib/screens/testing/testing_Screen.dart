import 'dart:io';
import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';
import '../Profile/capture_nid_info.dart';
import 'dart:io';           // For File
import 'dart:typed_data' hide Uint8List;

class NIDOCRScreen extends StatefulWidget {
  const NIDOCRScreen({super.key});

  @override
  State<NIDOCRScreen> createState() => _NIDOCRScreenState();
}

class _NIDOCRScreenState extends State<NIDOCRScreen> {
  File? _image;
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _fatherController = TextEditingController();
  final _motherController = TextEditingController();
  final _dobController = TextEditingController();
  final _nidController = TextEditingController();

  Future<void> _pickAndCropImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked == null) return;

    // Navigate to the ImageCropScreen
    final croppedBytes = await Navigator.push<Uint8List>(
      context,
      MaterialPageRoute(
        builder: (_) => ImageCropScreen(
          imageFile: File(picked.path),
          aspectRatio: 16 / 9, // Set your desired ratio
        ),
      ),
    );
    if (croppedBytes != null) {
      setState(() {
        _image = File.fromRawPath(croppedBytes); // Or save to temp file
      });
    }
  }


  Future<void> _extractText() async {
    if (_image == null) return;

    setState(() => _isLoading = true);

    try {
      final text = await TesseractOcr.extractText(
        _image!.path,
        language: "ben+eng", // Bangla + English
      );

      print("🔍 OCR Result:\n$text");

      final info = _parseNIDText(text);

      _nameController.text = info["name"] ?? "";
      _fatherController.text = info["father"] ?? "";
      _motherController.text = info["mother"] ?? "";
      _dobController.text = info["dob"] ?? "";
      _nidController.text = info["nid"] ?? "";

    } catch (e) {
      debugPrint("OCR Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error extracting text: $e')),
      );
    }

    setState(() => _isLoading = false);
  }

  Map<String, String> _parseNIDText(String text) {
    final data = <String, String>{};

    // Normalize text
    final full = text.replaceAll('\n', ' ');

    // Name
    final name = RegExp(r'Name\s*[:\-]?\s*([A-Za-z\s]+)').firstMatch(full);
    data["name"] = name?.group(1)?.trim() ?? "";

    // Father
    final father = RegExp(r'(Father.?s Name|পিতা)[:\-]?\s*([A-Za-z\u0980-\u09FF\s]+)').firstMatch(full);
    data["father"] = father?.group(2)?.trim() ?? "";

    // Mother
    final mother = RegExp(r'(Mother.?s Name|মাতা)[:\-]?\s*([A-Za-z\u0980-\u09FF\s]+)').firstMatch(full);
    data["mother"] = mother?.group(2)?.trim() ?? "";

    // DOB
    final dob = RegExp(r'(\d{2}[\/\-]\d{2}[\/\-]\d{4})').firstMatch(full);
    data["dob"] = dob?.group(1)?.trim() ?? "";

    // NID Number (10–17 digits)
    final nid = RegExp(r'\b\d{10,17}\b').firstMatch(full);
    data["nid"] = nid?.group(0)?.trim() ?? "";

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bangladesh NID OCR")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_image != null)
              Image.file(_image!, height: 180, fit: BoxFit.cover)
            else
              Container(
                height: 180,
                color: Colors.grey[200],
                alignment: Alignment.center,
                child: const Text("No Image Selected"),
              ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _pickAndCropImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Take & Crop Photo"),
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: _isLoading ? null : _extractText,
              icon: const Icon(Icons.text_snippet),
              label: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Extract NID Info"),
            ),

            const SizedBox(height: 20),

            _buildTextField("Name", _nameController),
            _buildTextField("Father", _fatherController),
            _buildTextField("Mother", _motherController),
            _buildTextField("Date of Birth", _dobController),
            _buildTextField("NID Number", _nidController),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}


