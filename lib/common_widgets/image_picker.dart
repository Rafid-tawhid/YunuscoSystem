import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerWidget extends StatelessWidget {
  final Function(File?) onImageSelected;
  final String buttonText;
  final double buttonHeight;
  final double iconSize;
  final double fontSize;

  const ImagePickerWidget({
    super.key,
    required this.onImageSelected,
    this.buttonText = 'Upload Image',
    this.buttonHeight = 100,
    this.iconSize = 30,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImageSourceBottomSheet(context),
      child: Container(
        height: buttonHeight,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade400,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: iconSize,
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 8),
            Text(
              buttonText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text(
              'Select Image Source',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            _buildBottomSheetOption(
              context,
              icon: Icons.camera_alt,
              text: 'Take Photo',
              onTap: () => _pickImage(context, ImageSource.camera),
            ),
            _buildBottomSheetOption(
              context,
              icon: Icons.photo_library,
              text: 'Choose from Gallery',
              onTap: () => _pickImage(context, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetOption(
      BuildContext context, {
        required IconData icon,
        required String text,
        required VoidCallback onTap,
      }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
      onTap: () {
        Navigator.pop(context); // Close bottom sheet
        onTap();
      },
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        onImageSelected(File(pickedFile.path));
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to pick image: $e');
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}