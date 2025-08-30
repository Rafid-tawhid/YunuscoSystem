import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageWithShimmer extends StatelessWidget {
  final String imageUrl;
  final String defaultImage;

  const ImageWithShimmer({
    super.key,
    required this.imageUrl,
    required this.defaultImage,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadImage(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              color: Colors.grey[300],
              width: double.infinity,
              height: double.infinity,
            ),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Image.asset(
            defaultImage,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
        } else {
          return Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                defaultImage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          );
        }
      },
    );
  }

  Future<bool> _loadImage(String url) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return true;
    } catch (_) {
      return false;
    }
  }
}
