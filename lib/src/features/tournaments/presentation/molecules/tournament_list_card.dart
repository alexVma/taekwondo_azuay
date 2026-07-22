import 'package:flutter/material.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_radii.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_spacing.dart';
import 'package:taekwondo_azuay/src/features/tournaments/domain/entities/tournament_event.dart';
import 'package:taekwondo_azuay/src/features/tournaments/presentation/atoms/tournament_image.dart';
import 'package:taekwondo_azuay/src/features/tournaments/presentation/atoms/tournament_status_badge.dart';

class TournamentListCard extends StatelessWidget {
  const TournamentListCard({super.key, required this.event});

  final TournamentEvent event;

  bool _isEventFinished(DateTime date) {
    final today = DateTime.now();
    final eventDate = DateTime(date.year, date.month, date.day);
    final todayDate = DateTime(today.year, today.month, today.day);
    return eventDate.isBefore(todayDate);
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: EliteMartialColors.surfaceContainerLowest,
        borderRadius: EliteMartialRadii.card,
        border: Border.all(color: const Color(0xffd7dbe2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(EliteMartialSpacing.md),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: SizedBox(
                width: 86,
                height: 86,
                child: TournamentImage(
                  height: 86,
                  imageUrl: event.imageUrl,
                  icon: _isEventFinished(event.eventDate)
                      ? Icons.sports_gymnastics
                      : Icons.workspace_premium,
                ),
              ),
            ),
            const SizedBox(width: EliteMartialSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      TournamentStatusBadge(date: event.eventDate),
                      const SizedBox(width: EliteMartialSpacing.sm),
                      Text(
                        event.date,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: event.status == TournamentStatus.upcoming
                                  ? EliteMartialColors.secondaryContainer
                                  : EliteMartialColors.onSurfaceVariant,
                              fontWeight: FontWeight.w900,
                              fontSize: 11,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: EliteMartialSpacing.sm),
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: EliteMartialColors.primary,
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                        ),
                  ),
                  const SizedBox(height: EliteMartialSpacing.lg),
                  Text(
                    '${event.location} • ${event.modality}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: EliteMartialColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
