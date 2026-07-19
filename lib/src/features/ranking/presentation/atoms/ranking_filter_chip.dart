import 'package:flutter/material.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_radii.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_spacing.dart';

class RankingFilterChip extends StatelessWidget {
  const RankingFilterChip({
    super.key,
    required this.label,
    this.isSelected = false,
  });

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final background = isSelected
        ? EliteMartialColors.secondaryContainer
        : EliteMartialColors.surfaceContainerHigh;
    final foreground = isSelected
        ? EliteMartialColors.onSecondary
        : EliteMartialColors.onSurfaceVariant;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: EliteMartialRadii.pill,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: EliteMartialSpacing.md,
          vertical: EliteMartialSpacing.sm,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
        ),
      ),
    );
  }
}
