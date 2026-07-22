import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';

class TournamentImage extends StatelessWidget {
  const TournamentImage({
    super.key,
    this.height = 130,
    this.icon = Icons.sports_martial_arts_rounded,
    this.imageUrl,
  });

  final double height;
  final IconData icon;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.contain,
              placeholder: (context, url) => Container(
                color: EliteMartialColors.surfaceContainer,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: EliteMartialColors.surfaceContainer,
                child: Center(
                  child: Icon(icon),
                ),
              ),
            )
          : Container(
              color: EliteMartialColors.surfaceContainer,
              child: Center(
                child: Icon(icon),
              ),
            ),
    );
  }
}

