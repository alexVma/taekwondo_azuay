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
    required this.eventDate,
    this.athletes,
    this.isFeatured = false,
    this.imageUrl,
  });

  final String title;
  final String date;
  final String location;
  final String modality;
  final TournamentStatus status;
  final Color imageSeed;
  final int? athletes;
  final bool isFeatured;
  final String? imageUrl;
  final DateTime eventDate;

  String get statusLabel {
    return switch (status) {
      TournamentStatus.active => 'EN CURSO',
      TournamentStatus.upcoming => 'PROXIMO',
      TournamentStatus.finished => 'FINALIZADO',
    };
  }


}
