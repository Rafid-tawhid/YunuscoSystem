import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class NidExtractorScreen extends StatefulWidget {
  const NidExtractorScreen({Key? key}) : super(key: key);

  @override
  State<NidExtractorScreen> createState() => _NidExtractorScreenState();
}

class _NidExtractorScreenState extends State<NidExtractorScreen> {
  File? frontImage;
  File? backImage;
  bool isLoading = false;

  final nameController = TextEditingController();
  final nidController = TextEditingController();
  final dobController = TextEditingController();
  final pobController = TextEditingController();
  final bloodController = TextEditingController();
  final issueController = TextEditingController();

  final ImagePicker picker = ImagePicker();
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<void> pickImage(bool isFront) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (isFront) {
          frontImage = File(picked.path);
        } else {
          backImage = File(picked.path);
        }
      });
    }
  }

  Future<void> extractData() async {
    if (frontImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select front NID image')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final inputImage = InputImage.fromFile(frontImage!);
      final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);

      String fullText = recognizedText.text;
      debugPrint(fullText);

      // Extract info with regex patterns
      RegExp nameRegex = RegExp(r'Name[:\s]*([A-Za-z\s]+)', caseSensitive: false);
      RegExp nidRegex = RegExp(r'\b\d{10,17}\b');
      RegExp dobRegex = RegExp(r'Date of Birth[:\s]*([\d]{1,2}[/\-\s][A-Za-z]{3}[/\-\s][\d]{4})', caseSensitive: false);
      RegExp pobRegex = RegExp(r'Place of Birth[:\s]*([A-Za-z\s]+)', caseSensitive: false);
      RegExp bloodRegex = RegExp(r'Blood Group[:\s]*([A-Z0-9+]+)', caseSensitive: false);
      RegExp issueRegex = RegExp(r'Issue Date[:\s]*([\d]{1,2}[/\-\s][A-Za-z]{3}[/\-\s][\d]{4})', caseSensitive: false);


      nameController.text =
          nameRegex.firstMatch(fullText)?.group(0)?.trim() ?? '';
      nidController.text =
          nidRegex.firstMatch(fullText)?.group(0)?.trim() ?? '';
      dobController.text =
          dobRegex.firstMatch(fullText)?.group(0)?.trim() ?? '';
      pobController.text =
          pobRegex.firstMatch(fullText)?.group(1)?.trim() ?? '';
      bloodController.text =
          bloodRegex.firstMatch(fullText)?.group(1)?.trim() ?? '';
      issueController.text =
          issueRegex.firstMatch(fullText)?.group(1)?.trim() ?? '';
    } catch (e) {
      debugPrint('Error extracting text: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error extracting data: $e')),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NID Info Extractor')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                imageBox(frontImage, true, 'Front Image'),
                imageBox(backImage, false, 'Back Image'),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: isLoading ? null : extractData,
              icon: const Icon(Icons.text_snippet),
              label: Text(isLoading ? 'Extracting...' : 'Extract & Edit'),
            ),
            const SizedBox(height: 20),
            buildTextField('Full Name', nameController),
            buildTextField('NID Number', nidController),
            buildTextField('Date of Birth', dobController),
            buildTextField('Place of Birth', pobController),
            buildTextField('Blood Group', bloodController),
            buildTextField('Issue Date', issueController),
          ],
        ),
      ),
    );
  }

  Widget imageBox(File? image, bool isFront, String label) {
    return GestureDetector(
      onTap: () => pickImage(isFront),
      child: Container(
        width: 150,
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          image: image != null
              ? DecorationImage(image: FileImage(image), fit: BoxFit.cover)
              : null,
        ),
        child: image == null
            ? Center(child: Text(label, style: TextStyle(color: Colors.grey)))
            : null,
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}


class ImageCropScreen extends StatefulWidget {
  final File imageFile;
  final double aspectRatio;

  const ImageCropScreen({
    Key? key,
    required this.imageFile,
    required this.aspectRatio,
  }) : super(key: key);

  @override
  _ImageCropScreenState createState() => _ImageCropScreenState();
}

class _ImageCropScreenState extends State<ImageCropScreen> {
  final CropController _cropController = CropController();
  Uint8List? _imageData;
  bool _isCropping = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final imageBytes = await widget.imageFile.readAsBytes();
    setState(() {
      _imageData = imageBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Image'),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: _isCropping ? null : _cropImage,
          ),
        ],
      ),
      body: _imageData == null
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Crop(
                controller: _cropController,
                image: _imageData!,
                aspectRatio: widget.aspectRatio,
                onCropped: (result) {
                  switch (result) {
                    case CropSuccess(:final croppedImage):
                      Navigator.pop(context, croppedImage);
                    case CropFailure(:final cause):
                      _showError('Failed to crop: $cause');
                      setState(() => _isCropping = false);
                  }
                },
                interactive: true,
                fixCropRect: false,
                baseColor: Colors.black,
                maskColor: Colors.white.withOpacity(0.5),
                radius: 8,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Pinch to zoom • Drag to move',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Crop area will maintain 16:9 ratio',
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _cropImage() {
    setState(() => _isCropping = true);
    _cropController.crop();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    setState(() => _isCropping = false);
  }
}