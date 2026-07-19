import 'package:flutter/material.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_radii.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_spacing.dart';
import 'package:taekwondo_azuay/src/features/tournaments/domain/entities/tournament_event.dart';
import 'package:taekwondo_azuay/src/features/tournaments/presentation/atoms/tournament_image.dart';
import 'package:taekwondo_azuay/src/features/tournaments/presentation/atoms/tournament_status_badge.dart';

class FeaturedTournamentCard extends StatelessWidget {
  const FeaturedTournamentCard({super.key, required this.event});

  final TournamentEvent event;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: EliteMartialColors.surfaceContainerLowest,
        borderRadius: EliteMartialRadii.card,
        border: Border.all(color: const Color(0xffd7dbe2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14001430),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: EliteMartialRadii.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                TournamentImage(seed: event.imageSeed, height: 134),
                Positioned(
                  left: 18,
                  top: 16,
                  child: TournamentStatusBadge(status: event.status),
                ),
              ],
            ),
            Transform.translate(
              offset: const Offset(0, -22),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: EliteMartialColors.surfaceContainerLowest,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                      bottom: Radius.circular(4),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 22, 18, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                event.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: EliteMartialColors.primary,
                                      fontWeight: FontWeight.w700,
                                      height: 1.25,
                                    ),
                              ),
                            ),
                            const Icon(
                              Icons.emoji_events_outlined,
                              color: EliteMartialColors.secondaryContainer,
                              size: 22,
                            ),
                          ],
                        ),
                        const SizedBox(height: EliteMartialSpacing.md),
                        _EventMeta(
                            icon: Icons.calendar_today_outlined,
                            label: event.date),
                        const SizedBox(height: EliteMartialSpacing.md),
                        _EventMeta(
                          icon: Icons.location_on_outlined,
                          label: event.location,
                        ),
                        const SizedBox(height: EliteMartialSpacing.md),
                        _EventMeta(
                          icon: Icons.groups_2_outlined,
                          label: '${event.athletes ?? 0} Atletas',
                        ),
                        const SizedBox(height: EliteMartialSpacing.lg),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {},
                            style: FilledButton.styleFrom(
                              backgroundColor: EliteMartialColors.primary,
                              foregroundColor: EliteMartialColors.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text('Ver Brackets de Combate'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventMeta extends StatelessWidget {
  const _EventMeta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: EliteMartialColors.onSurfaceVariant),
        const SizedBox(width: EliteMartialSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: EliteMartialColors.onSurfaceVariant,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}
