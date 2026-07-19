import 'package:flutter/material.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_spacing.dart';
import 'package:taekwondo_azuay/src/features/home/domain/entities/home_action.dart';
import 'package:taekwondo_azuay/src/features/home/presentation/molecules/home_action_card.dart';
import 'package:taekwondo_azuay/src/features/home/presentation/organisms/home_hero.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const double _heroGridOverlap = 50;
  static const double _horizontalPadding = 34;
  static const double _bottomContentPadding = 112;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: EliteMartialColors.surfaceContainerLowest,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _HeroWithOverlaidGrid(
              overlap: _heroGridOverlap,
              horizontalPadding: _horizontalPadding,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: _bottomContentPadding),
          ),
        ],
      ),
    );
  }
}

class _HeroWithOverlaidGrid extends StatelessWidget {
  const _HeroWithOverlaidGrid({
    required this.overlap,
    required this.horizontalPadding,
  });

  final double overlap;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final heroHeight = size.height * .6;
    final gridWidth = size.width - (horizontalPadding * 2);
    final cardWidth = (gridWidth - EliteMartialSpacing.lg) / 2;
    final cardHeight = cardWidth / 1.18;
    final gridHeight = (cardHeight * 2) + EliteMartialSpacing.lg;

    return SizedBox(
      height: heroHeight + gridHeight - overlap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: HomeHero(),
          ),
          Positioned(
            top: heroHeight - overlap,
            left: horizontalPadding,
            right: horizontalPadding,
            child: SizedBox(
              height: gridHeight,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: EliteMartialSpacing.lg,
                  crossAxisSpacing: EliteMartialSpacing.lg,
                  childAspectRatio: 1.18,
                ),
                itemCount: HomeAction.actions.length,
                itemBuilder: (context, index) =>
                    HomeActionCard(action: HomeAction.actions[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
