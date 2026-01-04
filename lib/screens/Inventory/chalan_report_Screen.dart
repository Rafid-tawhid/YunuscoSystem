import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ChalanScanScreen extends StatefulWidget {
  const ChalanScanScreen({super.key});

  @override
  State<ChalanScanScreen> createState() => _ChalanScanScreenState();
}

class _ChalanScanScreenState extends State<ChalanScanScreen> {
  String? qrData;
  File? capturedImage;
  MobileScannerController cameraController = MobileScannerController();
  bool _isScanning = true;
  Map<String, dynamic>? _parsedData;

  // Parse QR code data (assuming format: "CHALAN:12345|BUYER:John Doe|DATE:2024-01-15")
  Map<String, dynamic> _parseQRData(String rawData) {
    final Map<String, dynamic> data = {};

    try {
      // Remove brackets if present from barcode
      String cleanData = rawData.replaceAll('[', '').replaceAll(']', '');

      // Split by | for key-value pairs
      final parts = cleanData.split('|');

      for (var part in parts) {
        final keyValue = part.split(':');
        if (keyValue.length >= 2) {
          final key = keyValue[0].trim();
          final value = keyValue.sublist(1).join(':').trim();
          data[key.toLowerCase()] = value;
        }
      }

      // If no key-value pairs found, treat entire string as chalan number
      if (data.isEmpty) {
        data['chalan'] = cleanData;
      }

      // Add scan timestamp
      data['scan_time'] = DateTime.now().toIso8601String();

    } catch (e) {
      data['raw'] = rawData;
      data['error'] = 'Failed to parse QR data';
    }

    return data;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (image != null) {
      setState(() {
        capturedImage = File(image.path);
      });

      // Navigate to preview screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChalanPreviewScreen(
            qrData: qrData!,
            parsedData: _parsedData!,
            imageFile: capturedImage!,
          ),
        ),
      ).then((_) {
        // Reset state when returning from preview
        setState(() {
          qrData = null;
          capturedImage = null;
          _parsedData = null;
          _isScanning = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Chalan QR Scanner',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('How to Scan'),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('1. Position the QR code within the frame'),
                      Text('2. Wait for automatic detection'),
                      Text('3. Tap "Capture Photo" to proceed'),
                      Text('4. Review and submit the chalan'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // QR Scanner Section
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                MobileScanner(
                  controller: cameraController,
                  onDetect: (barcode) {
                    if (!_isScanning || barcode.barcodes.isEmpty) return;

                    final rawData = barcode.barcodes.first.rawValue;
                    if (rawData != null && rawData != qrData) {
                      setState(() {
                        qrData = rawData;
                        _parsedData = _parseQRData(rawData);
                        _isScanning = false;
                      });

                      // Vibrate/haptic feedback
                      // HapticFeedback.mediumImpact();
                    }
                  },
                ),

                // Scanner Overlay
                if (_isScanning) _buildScannerOverlay(),

                // Status Overlay
                if (!_isScanning && qrData != null)
                  Container(
                    color: Colors.black.withOpacity(0.7),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 80,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'QR Code Scanned!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap below to capture photo',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Info/Controls Section
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: qrData != null
                  ? _buildScannedInfo()
                  : _buildWaitingForScan(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.green,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.qr_code_scanner,
              size: 60,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            Text(
              'Align QR code',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaitingForScan() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.qr_code,
          size: 60,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 16),
        const Text(
          'Scan Chalan QR Code',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Position the QR code within the frame',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[500],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildScannedInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              'QR Code Scanned Successfully',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  qrData = null;
                  capturedImage = null;
                  _parsedData = null;
                  _isScanning = true;
                });
              },
              tooltip: 'Scan Again',
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Parsed Data Display
        if (_parsedData != null && _parsedData!.isNotEmpty) ...[
          Container(
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[100]!),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildParsedDataRows(),
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Action Button
        Center(
          child: ElevatedButton.icon(
            onPressed: _pickImage,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            icon: const Icon(Icons.camera_alt, size: 24),
            label: const Text(
              'Capture Chalan Photo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        Text(
          'Tap to capture photo of the physical chalan',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  List<Widget> _buildParsedDataRows() {
    List<Widget> rows = [];

    // Display parsed fields with friendly names
    final Map<String, String> displayNames = {
      'chalan': 'Chalan Number',
      'chalan_no': 'Chalan Number',
      'chalan_number': 'Chalan Number',
      'buyer': 'Buyer Name',
      'buyer_name': 'Buyer Name',
      'date': 'Chalan Date',
      'chalan_date': 'Chalan Date',
      'product': 'Product',
      'product_name': 'Product',
      'quantity': 'Quantity',
      'amount': 'Amount',
      'raw': 'QR Code Data',
    };

    _parsedData!.forEach((key, value) {
      // Skip internal fields
      if (key == 'scan_time' || key == 'error') return;

      final displayName = displayNames[key] ?? key.toUpperCase();

      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  '$displayName:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    });

    return rows;
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}

class ChalanPreviewScreen extends StatelessWidget {
  final String qrData;
  final Map<String, dynamic> parsedData;
  final File imageFile;

  const ChalanPreviewScreen({
    super.key,
    required this.qrData,
    required this.parsedData,
    required this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Chalan Preview',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chalan Photo
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.photo_camera,
                          color: Colors.blue,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Chalan Photo',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(imageFile),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retake Photo'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Chalan Details
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.receipt_long,
                          color: Colors.green,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Chalan Details',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Display parsed data
                    ..._buildDetailRows(),

                    const Divider(height: 24),

                    // Raw QR Data
                    Row(
                      children: [
                        const Icon(
                          Icons.qr_code,
                          color: Colors.purple,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'QR Code Data',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(
                        qrData,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Scan Another'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _submitChalan(context);
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text(
                      'Submit Chalan',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDetailRows() {
    List<Widget> rows = [];

    // Display parsed fields with friendly names
    final Map<String, String> displayNames = {
      'chalan': 'Chalan Number',
      'chalan_no': 'Chalan Number',
      'chalan_number': 'Chalan Number',
      'buyer': 'Buyer Name',
      'buyer_name': 'Buyer Name',
      'date': 'Chalan Date',
      'chalan_date': 'Chalan Date',
      'product': 'Product',
      'product_name': 'Product',
      'quantity': 'Quantity',
      'amount': 'Amount',
      'raw': 'QR Code Data',
    };

    // Add timestamp if available
    if (parsedData.containsKey('scan_time')) {
      try {
        final dateTime = DateTime.parse(parsedData['scan_time']);
        final formattedTime = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
        parsedData['scanned_at'] = formattedTime;
      } catch (e) {
        parsedData['scanned_at'] = parsedData['scan_time'];
      }
    }

    // Sort keys for consistent display
    final keys = parsedData.keys.toList()
      ..sort((a, b) {
        // Put important fields first
        final order = ['chalan', 'chalan_no', 'chalan_number', 'buyer', 'date', 'product'];
        final indexA = order.indexOf(a);
        final indexB = order.indexOf(b);
        if (indexA != -1 && indexB != -1) return indexA.compareTo(indexB);
        if (indexA != -1) return -1;
        if (indexB != -1) return 1;
        return a.compareTo(b);
      });

    for (final key in keys) {
      // Skip internal and error fields
      if (key == 'scan_time' || key == 'error') continue;

      final displayName = displayNames[key] ?? key.replaceAll('_', ' ').toUpperCase();
      final value = parsedData[key].toString();

      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  '$displayName:',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return rows;
  }

  void _submitChalan(BuildContext context) {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              'Submitting Chalan...',
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Remove loading dialog

      // Show success message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Success'),
            ],
          ),
          content: const Text('Chalan has been successfully submitted!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }
}