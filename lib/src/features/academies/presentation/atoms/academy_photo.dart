import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';

class AcademyPhoto extends StatelessWidget {
  const AcademyPhoto({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return SizedBox(
        height: 145,
        width: double.infinity,
        child: Container(
          color: EliteMartialColors.surfaceContainer,
          child: const Center(
            child: Icon(Icons.image_not_supported, size: 40),
          ),
        ),
      );
    }

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
          print('Error cargando imagen: $error');
          print('URL: $url');
          return Container(
            color: EliteMartialColors.surfaceContainer,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.image_not_supported, size: 40),
                const SizedBox(height: 8),
                Text(
                  'Error cargando imagen',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}