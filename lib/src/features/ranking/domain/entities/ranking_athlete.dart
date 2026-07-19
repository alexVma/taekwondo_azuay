import 'package:flutter/material.dart';

class RankingAthlete {
  const RankingAthlete({
    required this.position,
    required this.name,
    required this.academy,
    required this.points,
    required this.badgeColor,
    required this.isChampion,
    required this.avatarSeed,
  });

  final int position;
  final String name;
  final String academy;
  final int points;
  final Color badgeColor;
  final bool isChampion;
  final Color avatarSeed;

  static const cadets = <RankingAthlete>[
    RankingAthlete(
      position: 1,
      name: 'Mateo Sebastian Jaramillo',
      academy: 'Club Dragones Azuay',
      points: 850,
      badgeColor: Color(0xffffc400),
      isChampion: true,
      avatarSeed: Color(0xff163344),
    ),
    RankingAthlete(
      position: 2,
      name: 'Valentina Ortiz Vera',
      academy: 'Escuela Municipal Cuenca',
      points: 720,
      badgeColor: Color(0xffb8b8b8),
      isChampion: false,
      avatarSeed: Color(0xffa8171c),
    ),
    RankingAthlete(
      position: 3,
      name: 'Andres Felipe Cardenas',
      academy: 'Academia Kyon-Ji',
      points: 685,
      badgeColor: Color(0xffc47a2c),
      isChampion: false,
      avatarSeed: Color(0xff143340),
    ),
  ];
}
