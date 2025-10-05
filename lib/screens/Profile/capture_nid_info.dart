import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('NID Verification'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          // Debug button to see raw OCR output
          IconButton(
            icon: Icon(Icons.bug_report),
            onPressed: _debugOCR,
          ),
        ],
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

            // Debug OCR Button
            if (_frontImage != null)
              ElevatedButton(
                onPressed: _debugOCR,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: Text('DEBUG OCR OUTPUT'),
              ),

            SizedBox(height: 16),

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

  Future<void> _debugOCR() async {
    if (_frontImage == null) {
      _showError('Please upload front side first');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final text = await extractNidInfo(_frontImage!);
      print("=== RAW OCR OUTPUT ===");
      print(text);
      print("=== END RAW OUTPUT ===");

      // Show in dialog for easy viewing
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Raw OCR Output'),
          content: SingleChildScrollView(
            child: Text(text.isEmpty ? 'No text detected' : text),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      _showError('Debug failed: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
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
      _analyzeExtraction(frontText, frontData, true);

      // Extract from back image if available
      if (_backImage != null) {
        final backText = await extractNidInfo(_backImage!);
        final backData = _parseBangladeshNIDInformation(backText, isFront: false);
        _updateFormFields(backData);
        _analyzeExtraction(backText, backData, false);
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

  // Image preprocessing for better OCR
  Future<Uint8List> _preprocessImage(Uint8List imageBytes) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) return imageBytes;

      // Convert to grayscale
      var processed = img.grayscale(image);
      // Increase contrast
      processed = img.adjustColor(processed, contrast: 1.5);
      // Sharpen image
      // Increase brightness if needed
      processed = img.adjustColor(processed, brightness: 1.1);

      return Uint8List.fromList(img.encodeJpg(processed, quality: 95));
    } catch (e) {
      print("Image preprocessing failed: $e");
      return imageBytes;
    }
  }

  Future<String> extractNidInfo(Uint8List imageBytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/nid_scan_${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Preprocess image for better OCR
      final processedImage = await _preprocessImage(imageBytes);
      await tempFile.writeAsBytes(processedImage);

      final inputImage = InputImage.fromFilePath(tempFile.path);

      String bestResult = '';
      int bestWordCount = 0;

      // Try multiple approaches
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final recognizedText = await textRecognizer.processImage(inputImage);

      final wordCount = recognizedText.text.split(RegExp(r'\s+')).where((word) => word.length > 2).length;

      if (wordCount > bestWordCount) {
        bestResult = recognizedText.text;
        bestWordCount = wordCount;
      }

      await textRecognizer.close();
      await tempFile.delete();

      print("OCR extracted $bestWordCount words");
      return bestResult;
    } catch (e) {
      print("Error extracting NID info: $e");
      return '';
    }
  }

  Map<String, String> _parseBangladeshNIDInformation(String fullText, {required bool isFront}) {
    final data = <String, String>{};

    if (fullText.isEmpty) return data;

    // Enhanced text normalization
    fullText = fullText
        .replaceAll('\r', '')
        .replaceAll('|', 'I')
        .replaceAllMapped(RegExp(r' {2,}'), (m) => ' ')
        .replaceAllMapped(RegExp(r'\n+'), (m) => '\n')
        .toUpperCase();

    if (isFront) {
      // --- FRONT SIDE PATTERNS ---

      // Name patterns
      _extractWithPattern(data, fullText, 'name', [
        RegExp(r'NAME[:\s]*([A-Z\s]{10,50})'),
        RegExp(r'([A-Z]{2,20}\s+[A-Z]{2,20}\s+[A-Z]{2,20})'),
        RegExp(r'([A-Z]{2,20}\s+[A-Z]{2,20})'),
      ]);

      // NID Number patterns
      _extractWithPattern(data, fullText, 'NID No.', [
        RegExp(r'(\d{10,17})'),
        RegExp(r'NID[:\s]*NO[:\s]*(\d{10,17})'),
        RegExp(r'NATIONAL[:\s]*ID[:\s]*(\d{10,17})'),
      ]);

      // Date of Birth patterns
      _extractWithPattern(data, fullText, 'Date of Birth', [
        RegExp(r'DATE[:\s]*OF[:\s]*BIRTH[:\s]*(\d{1,2}[-/]\d{1,2}[-/]\d{4})'),
        RegExp(r'DOB[:\s]*(\d{1,2}[-/]\d{1,2}[-/]\d{4})'),
        RegExp(r'(\d{1,2}[-/]\d{1,2}[-/]\d{4})'),
      ]);

      // Father's Name patterns
      _extractWithPattern(data, fullText, 'father', [
        RegExp(r"FATHER[']?S[:\s]*NAME[:\s]*([A-Z\s]{10,50})"),
        RegExp(r"FATHER[:\s]*([A-Z\s]{10,50})"),
      ]);

      // Mother's Name patterns
      _extractWithPattern(data, fullText, 'mother', [
        RegExp(r"MOTHER[']?S[:\s]*NAME[:\s]*([A-Z\s]{10,50})"),
        RegExp(r"MOTHER[:\s]*([A-Z\s]{10,50})"),
      ]);

    } else {
      // --- BACK SIDE PATTERNS ---

      // Address patterns
      _extractWithPattern(data, fullText, 'address', [
        RegExp(r'ADDRESS[:\s]*([A-Z0-9\s,.-]{10,100})'),
        RegExp(r'VILLAGE[:\s]*([A-Z0-9\s,.-]{10,100})'),
      ]);

      // Place of Birth patterns
      _extractWithPattern(data, fullText, 'birth_place', [
        RegExp(r'PLACE[:\s]*OF[:\s]*BIRTH[:\s]*([A-Z\s,.-]{10,50})'),
        RegExp(r'BIRTH[:\s]*PLACE[:\s]*([A-Z\s,.-]{10,50})'),
      ]);

      // Issue Date patterns
      _extractWithPattern(data, fullText, 'issue_date', [
        RegExp(r'ISSUE[:\s]*DATE[:\s]*(\d{1,2}[-/]\d{1,2}[-/]\d{4})'),
        RegExp(r'DATE[:\s]*OF[:\s]*ISSUE[:\s]*(\d{1,2}[-/]\d{1,2}[-/]\d{4})'),
      ]);
    }

    return data;
  }

  void _extractWithPattern(Map<String, String> data, String text, String field, List<RegExp> patterns) {
    for (final pattern in patterns) {
      final matches = pattern.allMatches(text);
      for (final match in matches) {
        final value = (match.group(1) ?? match.group(0) ?? '').trim();
        if (value.isNotEmpty && value.length > 3 && !data.containsKey(field)) {
          data[field] = value;
          print("✅ Found $field: $value");
          break;
        }
      }
      if (data.containsKey(field)) break;
    }
  }

  void _analyzeExtraction(String fullText, Map<String, String> extractedData, bool isFront) {
    print("=== ${isFront ? 'FRONT' : 'BACK'} SIDE ANALYSIS ===");
    print("Text length: ${fullText.length}");
    print("Extracted: $extractedData");

    final expectedFields = isFront ?
    ['name', 'NID No.', 'Date of Birth', 'father', 'mother'] :
    ['address', 'birth_place', 'issue_date'];

    for (final field in expectedFields) {
      if (!extractedData.containsKey(field)) {
        print("❌ MISSING: $field");
      }
    }
    print("=== END ANALYSIS ===");
  }

  void _updateFormFields(Map<String, String> data) {
    print('FINAL EXTRACTED DATA: $data');
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