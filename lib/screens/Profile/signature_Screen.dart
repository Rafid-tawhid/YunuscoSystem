import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SignatureScreen extends StatefulWidget {
  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  bool _isLoading = false;
  List<Uint8List> _strokeHistory = []; // Store each stroke for undo functionality

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSignatureChanged);
  }

  void _onSignatureChanged() {
    // We'll capture the state when the user finishes a stroke
    if (!_controller.isEmpty) {
      // We'll handle the undo logic differently since the controller doesn't expose stroke history directly
    }
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      final permission = await Permission.photos.request();
      return permission.isGranted;
    } else if (Platform.isIOS) {
      final permission = await Permission.photosAddOnly.request();
      return permission.isGranted;
    }
    return false;
  }

  Future<void> _exportSignature() async {
    if (_controller.isEmpty) {
      _showSnackBar('Please sign before saving', Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Request permissions
      bool hasPermission = await _requestPermissions();
      if (!hasPermission) {
        throw Exception('Photo library permission denied');
      }

      // Export signature as PNG
      Uint8List? signatureData = await _controller.toPngBytes();

      if (signatureData != null) {
        // Save to gallery using photo_manager
        await _saveToGallery(signatureData);

        _showSnackBar('Signature saved to gallery!', Colors.green);
        _clearSignature();
      }
    } catch (e) {
      _showSnackBar('Error saving signature: ${e.toString()}', Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveToGallery(Uint8List imageData) async {
    // Create a temporary file
    final Directory tempDir = await getTemporaryDirectory();
    final String filePath = '${tempDir.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png';
    final File file = File(filePath);

    // Write the image data to the file
    await file.writeAsBytes(imageData);

    // Save to gallery using photo_manager
    final AssetEntity? asset = await PhotoManager.editor.saveImage(
      file.readAsBytesSync(),
      title: 'signature_${DateTime.now().millisecondsSinceEpoch}.png', filename: 'signature_nid',
    );

    if (asset == null) {
      throw Exception('Failed to save image to gallery');
    }

    // Clean up temporary file
    await file.delete();
  }

  // Undo the last stroke
  // Simple and reliable undo method
  // Correct undo method - removes only the last stroke
  void _undoLastStroke() {
    final points = List.of(_controller.points); // Copy current points
    if (points.isEmpty) {
      _showSnackBar('Nothing to undo', Colors.orange);
      return;
    }

    // Move backward to find the last stroke separator (null)
    int i = points.length - 1;
    while (i >= 0 && points[i] != null) {
      i--;
    }

    // If no null found, that means there's only one stroke — clear all
    if (i < 0) {
      _controller.clear();
    } else {
      // Keep points only before that null (remove the last stroke)
      _controller.points = points.sublist(0, i);
    }

    _showSnackBar('Last stroke removed', Colors.green);
  }


  // Enhanced undo with stroke tracking (more advanced implementation)
  void _undoLastStrokeAdvanced() async {
    if (_controller.points.isEmpty) {
      _showSnackBar('Nothing to undo', Colors.orange);
      return;
    }

    try {
      // Get current points
      final currentPoints = List<Point>.from(_controller.points);

      if (currentPoints.isNotEmpty) {
        // Find the last stroke by looking for breaks (points with null)
        int lastStrokeEndIndex = currentPoints.length - 1;

        // Find the start of the last stroke
        int lastStrokeStartIndex = lastStrokeEndIndex;
        while (lastStrokeStartIndex > 0) {
          lastStrokeStartIndex--;
        }

        // Remove the last stroke
        currentPoints.removeRange(lastStrokeStartIndex, currentPoints.length);

        // Update the controller with remaining points
        _controller.points = currentPoints;

        _showSnackBar('Last stroke removed', Colors.green);
      }
    } catch (e) {
      _showSnackBar('Error undoing last stroke', Colors.red);
    }
  }

  // Simple undo implementation using the controller's points
  void _simpleUndo() {
    final points = _controller.points;
    if (points.isEmpty) {
      _showSnackBar('Nothing to undo', Colors.orange);
      return;
    }

    // Remove the last stroke by finding the last null separator
    final List<Point> newPoints = [];
    bool foundLastStroke = false;

    for (int i = points.length - 1; i >= 0; i--) {
      if (!foundLastStroke) {
        if (points[i] == null) {
          foundLastStroke = true;
        }
        continue;
      }
      newPoints.add(points[i]!);
    }

    newPoints.reversed.toList();
    _controller.points = newPoints;
  }

  // Best undo implementation for the signature package
  void _bestUndo() {
    final points = _controller.points;
    if (points.isEmpty) {
      _showSnackBar('Nothing to undo', Colors.orange);
      return;
    }

    // Find the index of the last null (stroke separator)
    int lastNullIndex = -1;
    for (int i = points.length - 1; i >= 0; i--) {
      if (points[i] == null) {
        lastNullIndex = i;
        break;
      }
    }

    if (lastNullIndex == -1) {
      // Only one stroke exists, clear everything
      _controller.clear();
    } else {
      // Remove everything after the last null separator
      _controller.points = points.sublist(0, lastNullIndex);
    }
  }

  void _clearSignature() {
    _controller.clear();
    _strokeHistory.clear();
    _showSnackBar('Signature cleared', Colors.blue);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signature Pad'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('How to use'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• Draw your signature in the area below'),
                      SizedBox(height: 8),
                      Text('• Use Undo to remove the last stroke'),
                      SizedBox(height: 8),
                      Text('• Use Clear to start over'),
                      SizedBox(height: 8),
                      Text('• Save to save your signature to gallery'),
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
          // Instructions
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Sign below:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Draw your signature in the area below',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Signature area
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              margin: EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Signature(
                  controller: _controller,
                  height: double.infinity,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),

          // Action Buttons
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Top row: Undo and Clear
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.undo, size: 20),
                        label: Text('Undo'),
                        onPressed: _undoLastStroke,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.orange),
                          foregroundColor: Colors.orange,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.clear, size: 20),
                        label: Text('Clear All'),
                        onPressed: _clearSignature,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.red),
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Save button
                FilledButton.icon(
                  icon: _isLoading
                      ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Icon(Icons.save, size: 20),
                  label: _isLoading ? Text('Saving...') : Text('Save to Gallery'),
                  onPressed: _isLoading ? null : _exportSignature,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onSignatureChanged);
    _controller.dispose();
    super.dispose();
  }
}