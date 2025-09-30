import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';

class SimpleNIDScreen extends StatefulWidget {
  @override
  _SimpleNIDScreenState createState() => _SimpleNIDScreenState();
}

class _SimpleNIDScreenState extends State<SimpleNIDScreen> {
  final ImagePicker _picker = ImagePicker();

  Uint8List? _frontImage;
  Uint8List? _backImage;

  bool _isLoading = false;
  String _extractedText = '';

  // Text editing controllers for NID data
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nidNumberController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _placeOfBirthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NID Verification'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Front Side Section
            _buildImageSection(
              title: 'NID Front Side',
              image: _frontImage,
              onTap: () => _pickAndCropImage(isFront: true),
            ),

            SizedBox(height: 24),

            // Back Side Section
            _buildImageSection(
              title: 'NID Back Side',
              image: _backImage,
              onTap: () => _pickAndCropImage(isFront: false),
            ),

            SizedBox(height: 24),

            // NID Information Form
            if (_frontImage != null || _backImage != null)
              _buildNIDForm(),

            SizedBox(height: 16),

            // Extract Information Button
            if (_frontImage != null && _backImage != null)
              ElevatedButton(
                onPressed: _extractAllInformation,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                ),
                child: Text(
                  'EXTRACT INFORMATION',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),

            SizedBox(height: 16),

            // Extracted Text (for debugging)
            if (_extractedText.isNotEmpty)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Debug Information:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(_extractedText, style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection({
    required String title,
    required Uint8List? image,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[400]!,
                  style: image == null ? BorderStyle.solid : BorderStyle.none,
                ),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[50],
              ),
              child: image == null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, size: 40, color: Colors.grey[400]),
                  SizedBox(height: 8),
                  Text('Tap to Add Photo', style: TextStyle(color: Colors.grey[600])),
                ],
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(image, fit: BoxFit.cover),
              ),
            ),
          ),
          if (image != null) ...[
            SizedBox(height: 8),
            TextButton(
              onPressed: onTap,
              child: Text('Change Photo'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNIDForm() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue[300]!),
        borderRadius: BorderRadius.circular(12),
        color: Colors.blue[50],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NID Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[800]),
          ),
          SizedBox(height: 16),
          _buildTextField('Full Name', _nameController, Icons.person),
          SizedBox(height: 12),
          _buildTextField('NID Number', _nidNumberController, Icons.credit_card),
          SizedBox(height: 12),
          _buildTextField('Date of Birth', _dateOfBirthController, Icons.cake),
          SizedBox(height: 12),
          _buildTextField("Father's Name", _fatherNameController, Icons.man),
          SizedBox(height: 12),
          _buildTextField("Mother's Name", _motherNameController, Icons.woman),
          SizedBox(height: 12),
          _buildTextField('Address', _addressController, Icons.home),
          SizedBox(height: 12),
          _buildTextField('Place of Birth', _placeOfBirthController, Icons.place),
          SizedBox(height: 12),
          _buildTextField('Issue Date', _issueDateController, Icons.date_range),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Future<void> _pickAndCropImage({required bool isFront}) async {
    try {
      final XFile? pickedFile = await showModalBottomSheet<XFile>(
        context: context,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  final file = await _picker.pickImage(source: ImageSource.gallery);
                  Navigator.pop(context, file);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take Photo'),
                onTap: () async {
                  final file = await _picker.pickImage(source: ImageSource.camera);
                  Navigator.pop(context, file);
                },
              ),
            ],
          ),
        ),
      );

      if (pickedFile != null) {
        final Uint8List? croppedImage = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageCropScreen(
              imageFile: File(pickedFile.path),
              aspectRatio: 16 / 9,
            ),
          ),
        );

        if (croppedImage != null) {
          setState(() {
            if (isFront) {
              _frontImage = croppedImage;
            } else {
              _backImage = croppedImage;
            }
          });
        }
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  Future<void> _extractAllInformation() async {
    if (_frontImage == null) {
      _showError('Please upload front side of NID');
      return;
    }

    setState(() {
      _isLoading = true;
      _extractedText = '';
    });

    try {
      // Extract from front image
      final frontText = await extractNidInfo(_frontImage!);
      final frontData = _parseBangladeshNIDInformation(frontText, isFront: true);
      _updateFormFields(frontData);

      // Extract from back image if available
      if (_backImage != null) {
        final backText = await extractNidInfo(_backImage!);
        final backData = _parseBangladeshNIDInformation(backText, isFront: false);
        _updateFormFields(backData);
      }

      setState(() {
        _extractedText = 'Front side extracted: ${frontText.length} characters\n'
            'Back side extracted: ${_backImage != null ? 'Yes' : 'No'}\n'
            'Data has been auto-filled in the form above.';
      });

    } catch (e) {
      _showError('Failed to extract information: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> extractNidInfo(Uint8List imageBytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/nid_scan_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(imageBytes);

      final inputImage = InputImage.fromFilePath(tempFile.path);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final recognizedText = await textRecognizer.processImage(inputImage);

      await textRecognizer.close();
      await tempFile.delete();

      return recognizedText.text;
    } catch (e) {
      print("Error extracting NID info: $e");
      return '';
    }
  }

  Map<String, String> _parseBangladeshNIDInformation(String fullText, {required bool isFront}) {
    final data = <String, String>{};

    if (fullText.isEmpty) return data;

    // Normalize text (remove extra spaces, unify line breaks)
    fullText = fullText.replaceAll('\r', '').replaceAllMapped(RegExp(r' {2,}'), (m) => ' ');

    if (isFront) {
      // --- FRONT SIDE FIELDS ---
      // Name
      _extractWithPattern(data, fullText, 'name', [
        RegExp(r'Name\s*\n([A-Z\s\.]+)', caseSensitive: false),
        RegExp(r'Name[:\s]*([A-Z\s\.]+)', caseSensitive: false),
      ]);

// Father
      _extractWithPattern(data, fullText, 'father', [
        RegExp(r'Father.?s Name\s*[:\-]?\s*([A-Za-z\s\.]+)', caseSensitive: false),
        RegExp(r'Father\s*[:\-]?\s*([A-Za-z\s\.]+)', caseSensitive: false),
        RegExp(r'পিতা\s*[:\-]?\s*([^\n]+)'), // Bangla fallback
      ]);

// Mother
      _extractWithPattern(data, fullText, 'mother', [
        RegExp(r'Mother.?s Name\s*[:\-]?\s*([A-Za-z\s\.]+)', caseSensitive: false),
        RegExp(r'Mother\s*[:\-]?\s*([A-Za-z\s\.]+)', caseSensitive: false),
        RegExp(r'মাতা\s*[:\-]?\s*([^\n]+)'), // Bangla fallback
      ]);

      // Date of Birth
      _extractWithPattern(data, fullText, 'Date of Birth', [
        RegExp(r'Date of Birth\s*:?[\s]*(\d{1,2}\s\w+\s\d{4})', caseSensitive: false),
        RegExp(r'DOB\s*:?[\s]*(\d{1,2}\s\w+\s\d{4})', caseSensitive: false),
        RegExp(r'(\d{2}\s\w+\s\d{4})'),
      ]);

      // NID Number
      _extractWithPattern(data, fullText, 'NID No.', [
        RegExp(r'NID\s*No.?[:\s]*([\d\s]+)', caseSensitive: false),
        RegExp(r'National ID[:\s]*([\d\s]+)', caseSensitive: false),
        RegExp(r'\b\d{10,17}\b'),
      ]);

    } else {
      // --- BACK SIDE FIELDS ---
      // Address
      _extractWithPattern(data, fullText, 'address', [
        RegExp(r'Address\s*:?([A-Za-z0-9, \-\n]+)', caseSensitive: false),
        RegExp(r'ঠিকানা[:\s]*([^\n]+)'),
      ]);

      // Place of Birth
      _extractWithPattern(data, fullText, 'birth_place', [
        RegExp(r'Place of Birth\s*:?[\s]*([A-Za-z\s]+)', caseSensitive: false),
        RegExp(r'Birth Place\s*:?[\s]*([A-Za-z\s]+)', caseSensitive: false),
      ]);

      // Issue Date
      _extractWithPattern(data, fullText, 'issue_date', [
        RegExp(r'Issue Date\s*:?[\s]*(\d{1,2}\s\w+\s\d{4})', caseSensitive: false),
        RegExp(r'Date of Issue\s*:?[\s]*(\d{1,2}\s\w+\s\d{4})', caseSensitive: false),
        RegExp(r'(\d{2}\s\w+\s\d{4})'),
      ]);
    }

    return data;
  }


  void _extractWithPattern(Map<String, String> data, String text, String field, List<RegExp> patterns) {
    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final value = (match.group(1) ?? match.group(0) ?? '').trim();
        if (value.isNotEmpty && !data.containsKey(field)) {
          data[field] = value;
          break;
        }
      }
    }
  }

  void _updateFormFields(Map<String, String> data) {
    debugPrint('FINAL DATA ${data}');
    setState(() {
      _nameController.text = data['name'] ?? _nameController.text;
      _nidNumberController.text = data['NID No.'] ?? _nidNumberController.text;
      _dateOfBirthController.text = data['Date of Birth'] ?? _dateOfBirthController.text;
      _fatherNameController.text = data['father'] ?? _fatherNameController.text;
      _motherNameController.text = data['mother'] ?? _motherNameController.text;
      _addressController.text = data['address'] ?? _addressController.text;
      _placeOfBirthController.text = data['birth_place'] ?? _placeOfBirthController.text;
      _issueDateController.text = data['issue_date'] ?? _issueDateController.text;
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

  @override
  void dispose() {
    // Dispose all controllers
    _nameController.dispose();
    _nidNumberController.dispose();
    _dateOfBirthController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _addressController.dispose();
    _placeOfBirthController.dispose();
    _issueDateController.dispose();
    super.dispose();
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