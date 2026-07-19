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
      child: Image.network(url),
    );
  }
}