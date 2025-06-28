import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fingerprint_reconization/fingerprint_reconization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'dart:io';

class BiometricFormScreen extends StatefulWidget {
  const BiometricFormScreen({super.key});

  @override
  State<BiometricFormScreen> createState() => _BiometricFormScreenState();
}

class _BiometricFormScreenState extends State<BiometricFormScreen> {
  final plugin = FingerprintReconization();
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
  );
  final ImagePicker _picker = ImagePicker();

  File? _capturedImage;
  bool? _fingerprintVerified;
  String? _message;
  bool _isProcessing = false;
  bool _isScanningFingerprint = false;

  Future<void> _captureImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _capturedImage = File(image.path);
        });
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing image: ${e.message}')),
      );
    }
  }

  Future<void> _verifyFingerprint() async {
    setState(() => _isScanningFingerprint = true);
    try {
      final result = await plugin.authenticate();
      setState(() {
        _message = result;
        _isScanningFingerprint = false;
      });
    } catch (e) {
      setState(() => _isScanningFingerprint = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fingerprint error: $e')),
      );
    }
  }

  Future<void> _saveAllData() async {
    if (_capturedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture an image')),
      );
      return;
    }

    if (_signatureController.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a signature')),
      );
      return;
    }

    if (_fingerprintVerified == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please verify your fingerprint')),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      // Here you would typically:
      // 1. Save the image file (_capturedImage)
      // 2. Export the signature (_signatureController.toPngBytes())
      // 3. Save the fingerprint verification result
      // 4. Upload to your backend

      await Future.delayed(const Duration(seconds: 2)); // Simulate processing

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All data saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometric Verification'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Image Capture Section
            _buildImageCaptureSection(),
            const SizedBox(height: 30),

            // Signature Section
            _buildSignatureSection(),
            const SizedBox(height: 30),

            // Fingerprint Section
            _buildFingerprintSection(),
            const SizedBox(height: 40),

            // Save Button
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCaptureSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Capture Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _captureImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: _capturedImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(_capturedImage!, fit: BoxFit.cover),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Tap to capture photo'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignatureSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: const Text(
                    'Digital Signature',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(onPressed: (){
                      setState(() {
                        _signatureController.clear();

                      });
                    }, icon: Icon(Icons.clear)),
                    IconButton(onPressed: (){
                      setState(() {
                        _signatureController.undo();

                      });
                    }, icon: Icon(Icons.undo)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Stack(
              children: [

                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Signature(
                    controller: _signatureController,
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _signatureController.clear(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Clear'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_signatureController.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please sign first')),
                      );
                      return;
                    }
                    // Signature is automatically saved in the controller
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Signature saved')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Save Signature'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFingerprintSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Fingerprint Verification',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _verifyFingerprint,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade100,
                  border: Border.all(
                    color: _isScanningFingerprint
                        ? Colors.blue
                        : _fingerprintVerified == true
                        ? Colors.green
                        : _fingerprintVerified == false
                        ? Colors.red
                        : Colors.grey,
                    width: 3,
                  ),
                ),
                child: _isScanningFingerprint
                    ? const Padding(
                  padding: EdgeInsets.all(25),
                  child: CircularProgressIndicator(),
                )
                    : Icon(
                  Icons.fingerprint,
                  size: 50,
                  color: _fingerprintVerified == true
                      ? Colors.green
                      : _fingerprintVerified == false
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _isScanningFingerprint
                  ? 'Scanning fingerprint...'
                  : _fingerprintVerified == true
                  ? 'Fingerprint verified!'
                  : _fingerprintVerified == false
                  ? 'Verification failed'
                  : 'Tap to verify fingerprint',
              style: TextStyle(
                color: _fingerprintVerified == true
                    ? Colors.green
                    : _fingerprintVerified == false
                    ? Colors.red
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _saveAllData,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        child: _isProcessing
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
        )
            : const Text(
          'SAVE ALL DATA',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}