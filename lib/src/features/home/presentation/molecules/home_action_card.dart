import 'package:flutter/material.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_radii.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_spacing.dart';
import 'package:taekwondo_azuay/src/features/home/domain/entities/home_action.dart';

import '../../../../core/theme/text_style.dart';

class HomeActionCard extends StatelessWidget {
  const HomeActionCard({super.key, required this.action});

  final HomeAction action;

  @override
  Widget build(BuildContext context) {
    final iconColor = action.label == 'Torneos'
        ? EliteMartialColors.secondaryContainer
        : EliteMartialColors.primaryContainer;
    final chipColor =
        action.isPrimary ? iconColor : EliteMartialColors.surfaceContainerHigh;
    final activeIconColor = action.isPrimary
        ? EliteMartialColors.onPrimary
        : EliteMartialColors.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: EliteMartialColors.surfaceContainerLowest,
        borderRadius: EliteMartialRadii.card,
        border: Border.all(color: const Color(0xffd8dce2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1f001430),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: EliteMartialSpacing.base,
          vertical: EliteMartialSpacing.base,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                color: chipColor,
                shape: BoxShape.circle,
              ),
              child: Icon(action.icon, color: activeIconColor, size: 34),
            ),
            const SizedBox(height: EliteMartialSpacing.base),
            Text(
              action.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.blueTitleMStyle,
            ),
          ],
        ),
      ),
    );
  }
}
