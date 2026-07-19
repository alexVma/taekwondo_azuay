import 'package:flutter/material.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: EliteMartialColors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.sports_martial_arts_rounded,
        color: EliteMartialColors.inversePrimary,
        size: 30,
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: EliteMartialColors.surfaceContainerHigh,
        border: Border.all(color: EliteMartialColors.outlineVariant, width: 2),
      ),
      child: ClipOval(
        child: ColoredBox(
          color: EliteMartialColors.primaryContainer,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.person_rounded,
                color: EliteMartialColors.inversePrimary,
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
