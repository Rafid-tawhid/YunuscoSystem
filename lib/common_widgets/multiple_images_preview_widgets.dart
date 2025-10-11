import 'package:flutter/material.dart';

class ImagePreviewWidget extends StatelessWidget {
  final List<String> imageUrls;

  const ImagePreviewWidget({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return const Icon(Icons.image_not_supported, color: Colors.grey);
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FullImageViewer(imageUrls: imageUrls),
          ),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Show first image as thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrls.first,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 40),
            ),
          ),
          // Small overlay showing count
          if (imageUrls.length > 1)
            Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '+${imageUrls.length - 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class FullImageViewer extends StatelessWidget {
  final List<String> imageUrls;

  const FullImageViewer({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('All Images'),
      ),
      body: PageView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          final url = imageUrls[index];
          return InteractiveViewer(
            child: Center(
              child: Image.network(
                url,
                fit: BoxFit.contain,
                loadingBuilder: (_, child, progress) =>
                progress == null ? child : const CircularProgressIndicator(),
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.broken_image, color: Colors.white, size: 80),
              ),
            ),
          );
        },
      ),
    );
  }
}
