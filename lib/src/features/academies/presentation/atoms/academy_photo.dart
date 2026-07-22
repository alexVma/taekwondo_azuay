import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';

class AcademyPhoto extends StatelessWidget {
  const AcademyPhoto({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 145,
      width: double.infinity,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: EliteMartialColors.surfaceContainer,
            child: const Center(
              child: Icon(Icons.image_not_supported, size: 40),
            ),
          );
        },
      ),
    );
  }
}