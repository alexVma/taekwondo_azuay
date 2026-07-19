import 'package:flutter/material.dart';

enum TournamentStatus { active, upcoming, finished }

class TournamentEvent {
  const TournamentEvent({
    required this.title,
    required this.date,
    required this.location,
    required this.modality,
    required this.status,
    required this.imageSeed,
    this.athletes,
    this.isFeatured = false,
  });

  final String title;
  final String date;
  final String location;
  final String modality;
  final TournamentStatus status;
  final Color imageSeed;
  final int? athletes;
  final bool isFeatured;

  String get statusLabel {
    return switch (status) {
      TournamentStatus.active => 'EN CURSO',
      TournamentStatus.upcoming => 'PROXIMO',
      TournamentStatus.finished => 'FINALIZADO',
    };
  }

  static const events = <TournamentEvent>[
    TournamentEvent(
      title: 'Open Panamericano Cuenca 2024',
      date: '15-18 Oct',
      location: 'Coliseo Mayor Jefferson Perez',
      modality: 'Kyorugi',
      athletes: 450,
      status: TournamentStatus.active,
      imageSeed: Color(0xff15384d),
      isFeatured: true,
    ),
    TournamentEvent(
      title: 'Campeonato Interclubes Austral',
      date: 'Nov 02',
      location: 'Cuenca, Ecuador',
      modality: 'Kyorugi',
      status: TournamentStatus.upcoming,
      imageSeed: Color(0xff102d42),
    ),
    TournamentEvent(
      title: 'G2 Ranking Nacional Absoluto',
      date: 'Sep 12',
      location: 'Quito, Ecuador',
      modality: 'Poomsae',
      status: TournamentStatus.finished,
      imageSeed: Color(0xff3d3d3d),
    ),
  ];
}
