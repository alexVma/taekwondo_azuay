import 'package:flutter/material.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: EliteMartialColors.primary,
      ),
      child: const Center(
        child: Icon(
          Icons.person,
          color: EliteMartialColors.onPrimary,
        ),
      ),
    );
  }
}
