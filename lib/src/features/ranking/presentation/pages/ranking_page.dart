import 'package:flutter/material.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_spacing.dart';
import 'package:taekwondo_azuay/src/features/ranking/domain/entities/ranking_athlete.dart';
import 'package:taekwondo_azuay/src/features/ranking/presentation/atoms/ranking_filter_chip.dart';
import 'package:taekwondo_azuay/src/features/ranking/presentation/molecules/ranking_athlete_card.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  static const _primaryFilters = ['Individual', 'Pareja', 'Equipo'];
  static const _categoryFilters = ['Pre-Cadetes', 'Cadetes', 'Junior'];
  static const _beltFilters = ['Gup (Colores)', 'Poom/Dan (Negro)'];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: EliteMartialColors.surfaceContainerLowest,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed([
                Text(
                  'Ranking Provincial',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: EliteMartialColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: EliteMartialSpacing.sm),
                Text(
                  'Clasificacion oficial acumulada',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: EliteMartialColors.onSurfaceVariant,
                        height: 1.25,
                      ),
                ),
                const SizedBox(height: EliteMartialSpacing.xl),
                const _FilterRow(labels: _primaryFilters, selectedIndex: 0),
                const SizedBox(height: EliteMartialSpacing.sm),
                const _FilterRow(labels: _categoryFilters, selectedIndex: 1),
                const SizedBox(height: EliteMartialSpacing.sm),
                const _FilterRow(labels: _beltFilters, selectedIndex: 1),
                const SizedBox(height: EliteMartialSpacing.xl),
                for (final athlete in RankingAthlete.cadets) ...[
                  RankingAthleteCard(athlete: athlete),
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

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.labels,
    required this.selectedIndex,
  });

  final List<String> labels;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final entry in labels.indexed) ...[
            RankingFilterChip(
              label: entry.$2,
              isSelected: entry.$1 == selectedIndex,
            ),
            const SizedBox(width: EliteMartialSpacing.sm),
          ],
        ],
      ),
    );
  }
}
