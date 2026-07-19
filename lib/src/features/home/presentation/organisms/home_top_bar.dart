import 'package:flutter/material.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_spacing.dart';
import 'package:taekwondo_azuay/src/features/home/presentation/atoms/brand_mark.dart';

import '../../../../core/theme/text_style.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 5, left: 5, right: 5),
      child: Row(
        children: [
          const BrandMark(),
          const SizedBox(width: EliteMartialSpacing.base),
          Expanded(
            child: Text(
              'TAEKWONDO AZUAY',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyle.blueTitleMStyle,
            ),
          ),
          const SizedBox(width: EliteMartialSpacing.base),
          const ProfileAvatar(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(150.0);
}
