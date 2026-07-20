import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_radii.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_spacing.dart';
import 'package:taekwondo_azuay/src/features/ranking/domain/entities/ranking_athlete.dart';

class RankingAthleteCard extends StatelessWidget {
  const RankingAthleteCard({super.key, required this.athlete});

  final RankingAthlete athlete;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: EliteMartialColors.surfaceContainerLowest,
        borderRadius: EliteMartialRadii.card,
        border: Border.all(color: const Color(0xffd7dbe2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0f001430),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: EliteMartialRadii.card,
        child: Stack(
          children: [
            if (athlete.isChampion)
              const Positioned(
                top: 0,
                right: 0,
                child: _ChampionRibbon(),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 18, 14, 14),
              child: Row(
                children: [
                  _PositionBadge(athlete: athlete),
                  const SizedBox(width: EliteMartialSpacing.md),
                  _AthletePortrait(imageUrl: athlete.imageUrl),
                  const SizedBox(width: EliteMartialSpacing.md),
                  Expanded(child: _AthleteSummary(athlete: athlete)),
                  const SizedBox(width: EliteMartialSpacing.sm),
                  _Points(points: athlete.points),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AthletePortrait extends StatelessWidget {
  const _AthletePortrait({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: EliteMartialColors.surfaceContainerHigh,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xffd7dbe2)),
      ),
      child: ClipOval(
        child: imageUrl != null
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.person,
                  color: EliteMartialColors.primary,
                ),
              )
            : const Icon(
                Icons.person,
                color: EliteMartialColors.primary,
              ),
      ),
    );
  }
}

class _PositionBadge extends StatelessWidget {
  const _PositionBadge({required this.athlete});

  final RankingAthlete athlete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration:
          BoxDecoration(color: athlete.badgeColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        '${athlete.position}',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
      ),
    );
  }
}


class _AthleteSummary extends StatelessWidget {
  const _AthleteSummary({required this.athlete});

  final RankingAthlete athlete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          athlete.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: EliteMartialColors.primary,
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          athlete.academy,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: EliteMartialColors.primary,
                fontSize: 10,
                height: 1.1,
              ),
        ),
        const SizedBox(height: 5),
        DecoratedBox(
          decoration: BoxDecoration(
            color: EliteMartialColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            child: Text(
              'CADETES - NEGRO',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: EliteMartialColors.onSurface,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Points extends StatelessWidget {
  const _Points({required this.points});

  final int points;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$points',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: EliteMartialColors.secondaryContainer,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
        ),
        Text(
          'PTS',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: EliteMartialColors.primary,
                fontSize: 8,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
        ),
      ],
    );
  }
}

class _ChampionRibbon extends StatelessWidget {
  const _ChampionRibbon();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xffffc400),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        child: Text(
          'CHAMPION',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
        ),
      ),
    );
  }
}
