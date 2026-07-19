import 'package:flutter/material.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_spacing.dart';
import 'package:taekwondo_azuay/src/features/tournaments/domain/entities/tournament_event.dart';
import 'package:taekwondo_azuay/src/features/tournaments/presentation/molecules/featured_tournament_card.dart';
import 'package:taekwondo_azuay/src/features/tournaments/presentation/molecules/tournament_list_card.dart';

class TournamentsPage extends StatelessWidget {
  const TournamentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final featured =
        TournamentEvent.events.firstWhere((event) => event.isFeatured);
    final secondaryEvents =
        TournamentEvent.events.where((event) => !event.isFeatured).toList();

    return ColoredBox(
      color: EliteMartialColors.surfaceContainerLowest,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed([
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Proximos Eventos',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: EliteMartialColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                          const SizedBox(height: EliteMartialSpacing.xs),
                          Text(
                            'Calendario oficial de la federacion',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: EliteMartialColors.onSurfaceVariant,
                                  height: 1.25,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.circle_outlined,
                      color: EliteMartialColors.outlineVariant,
                      size: 14,
                    ),
                  ],
                ),
                const SizedBox(height: EliteMartialSpacing.xl),
                FeaturedTournamentCard(event: featured),
                const SizedBox(height: EliteMartialSpacing.lg),
                for (final event in secondaryEvents) ...[
                  TournamentListCard(event: event),
                  const SizedBox(height: EliteMartialSpacing.md),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
