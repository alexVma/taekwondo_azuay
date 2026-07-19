import 'package:flutter/material.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_radii.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_spacing.dart';
import 'package:taekwondo_azuay/src/features/academies/domain/entities/academy.dart';
import 'package:taekwondo_azuay/src/features/academies/presentation/atoms/academy_photo.dart';

class AcademyBottomSheet extends StatelessWidget {
  const AcademyBottomSheet({super.key, required this.academy});

  final Academy academy;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .62,
      minChildSize: .28,
      maxChildSize: .82,
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: EliteMartialColors.surfaceContainerLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(22, 10, 22, 24),
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: EliteMartialColors.outlineVariant,
                    borderRadius: EliteMartialRadii.pill,
                  ),
                ),
              ),
              const SizedBox(height: EliteMartialSpacing.lg),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    AcademyPhoto(url: academy.url),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: EliteMartialColors.tertiaryFixedDim,
                          borderRadius: EliteMartialRadii.pill,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 7),
                          child: Text(
                            academy.badge,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: EliteMartialColors.onTertiaryFixed,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: EliteMartialSpacing.lg),
              Text(
                academy.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: EliteMartialColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: EliteMartialSpacing.sm),
              _AcademyInfoRow(icon: Icons.person_outline, text: academy.coach),
              _AcademyInfoRow(
                icon: Icons.location_on_outlined,
                text: academy.address,
                iconColor: EliteMartialColors.secondaryContainer,
              ),
              _AcademyInfoRow(
                icon: Icons.phone_outlined,
                text: academy.phone,
                iconColor: EliteMartialColors.secondaryContainer,
              ),
              _AcademyInfoRow(
                icon: Icons.schedule_outlined,
                text: academy.schedule,
                iconColor: EliteMartialColors.secondaryContainer,
              ),
              const SizedBox(height: EliteMartialSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.assistant_direction_outlined,
                          size: 18),
                      label: const Text('Como llegar'),
                      style: FilledButton.styleFrom(
                        backgroundColor: EliteMartialColors.secondaryContainer,
                        foregroundColor: EliteMartialColors.onSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: EliteMartialSpacing.sm),
                  IconButton.outlined(
                    onPressed: () {},
                    icon: const Icon(Icons.share_outlined),
                    color: EliteMartialColors.primary,
                    padding: const EdgeInsets.all(14),
                    style: IconButton.styleFrom(
                      side: const BorderSide(
                          color: EliteMartialColors.outlineVariant),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AcademyInfoRow extends StatelessWidget {
  const _AcademyInfoRow({
    required this.icon,
    required this.text,
    this.iconColor = EliteMartialColors.onSurfaceVariant,
  });

  final IconData icon;
  final String text;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: EliteMartialSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: EliteMartialSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: EliteMartialColors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    height: 1.28,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
