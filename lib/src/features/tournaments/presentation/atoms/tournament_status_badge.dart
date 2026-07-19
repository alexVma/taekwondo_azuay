import 'package:flutter/material.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_radii.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_spacing.dart';
import 'package:taekwondo_azuay/src/features/tournaments/domain/entities/tournament_event.dart';

class TournamentStatusBadge extends StatelessWidget {
  const TournamentStatusBadge({super.key, required this.status});

  final TournamentStatus status;

  @override
  Widget build(BuildContext context) {
    final background = switch (status) {
      TournamentStatus.active => EliteMartialColors.secondaryContainer,
      TournamentStatus.upcoming => EliteMartialColors.surfaceContainerHigh,
      TournamentStatus.finished => EliteMartialColors.surfaceContainerHigh,
    };
    final foreground = switch (status) {
      TournamentStatus.active => EliteMartialColors.onSecondary,
      TournamentStatus.upcoming => EliteMartialColors.onSurfaceVariant,
      TournamentStatus.finished => EliteMartialColors.onSurfaceVariant,
    };
    final label = switch (status) {
      TournamentStatus.active => 'EN CURSO',
      TournamentStatus.upcoming => 'PROXIMO',
      TournamentStatus.finished => 'FINALIZADO',
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: EliteMartialRadii.pill,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: EliteMartialSpacing.sm,
          vertical: 5,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: foreground,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
                height: 1,
              ),
        ),
      ),
    );
  }
}
