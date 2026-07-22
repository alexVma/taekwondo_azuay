import 'package:flutter/material.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_radii.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_spacing.dart';

enum _EventStatusType { active, upcoming, finished }

class TournamentStatusBadge extends StatelessWidget {
  const TournamentStatusBadge({super.key, required this.date});

  final DateTime date;

  _EventStatusType _getStatusFromDate() {
    final today = DateTime.now();
    final eventDate = DateTime(date.year, date.month, date.day);
    final todayDate = DateTime(today.year, today.month, today.day);

    if (eventDate.isAtSameMomentAs(todayDate)) {
      return _EventStatusType.active;
    } else if (eventDate.isAfter(todayDate)) {
      return _EventStatusType.upcoming;
    } else {
      return _EventStatusType.finished;
    }
  }

  @override
  Widget build(BuildContext context) {
    final computedStatus = _getStatusFromDate();

    final background = switch (computedStatus) {
      _EventStatusType.active => EliteMartialColors.secondaryContainer,
      _EventStatusType.upcoming => EliteMartialColors.surfaceContainerHigh,
      _EventStatusType.finished => EliteMartialColors.surfaceContainerHigh,
    };
    final foreground = switch (computedStatus) {
      _EventStatusType.active => EliteMartialColors.onSecondary,
      _EventStatusType.upcoming => EliteMartialColors.onSurfaceVariant,
      _EventStatusType.finished => EliteMartialColors.onSurfaceVariant,
    };
    final label = switch (computedStatus) {
      _EventStatusType.active => 'EN CURSO',
      _EventStatusType.upcoming => 'PROXIMO',
      _EventStatusType.finished => 'FINALIZADO',
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
