import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerWidget extends StatefulWidget {
  final Function(List<File>)? onImagesChanged; // Callback function

  const ImagePickerWidget({Key? key, this.onImagesChanged}) : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  List<File> _selectedImages = [];

  Future<void> _pickImages() async {
    try {
      final List<XFile>? pickedFiles = await ImagePicker().pickMultiImage(
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 80,
      );

      if (pickedFiles != null) {
        setState(() {
          _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
        });
        // Notify parent about the change
        widget.onImagesChanged?.call(_selectedImages);
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
    // Notify parent about the change
    widget.onImagesChanged?.call(_selectedImages);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Add Images Button
        if (_selectedImages.length < 10)
          GestureDetector(
            onTap: _pickImages,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade50,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate, color: Colors.grey, size: 30),
                  SizedBox(height: 8),
                  Text('Add Images', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),

        const SizedBox(height: 16),

        // Selected Images Row
        if (_selectedImages.isNotEmpty)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(_selectedImages.length, (index) {
              return Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImages[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.error, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: -8,
                    right: -8,
                    child: GestureDetector(
                      onTap: () => _removeImage(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
      ],
    );
  }
}