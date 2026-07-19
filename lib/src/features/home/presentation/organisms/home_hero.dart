import 'package:flutter/material.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_spacing.dart';

import '../../../../core/app_strings.dart';
import '../../../../core/theme/text_style.dart';

class HomeHero extends StatelessWidget {
  const HomeHero({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: (size.height * 0.6),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/img/aso_logo.png'),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    EliteMartialColors.primary.withValues(alpha: .65),
                    EliteMartialColors.primary.withValues(alpha: .9),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.homeTitle,
                  style: AppTextStyle.goldTitleXXLStyle,
                ),
                const SizedBox(height: EliteMartialSpacing.xl),
                Text(
                  AppStrings.homeBody,
                  style: AppTextStyle.whiteBodyLargeStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
