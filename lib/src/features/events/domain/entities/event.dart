import '../enums/event_type.dart';
import '../enums/competition_type.dart';
import '../enums/ranking.dart';
import '../enums/event_level.dart';
import '../enums/event_status.dart';

class Event {
  final String id;
  final String name;
  final EventType eventType;
  final CompetitionType competitionType;
  final Ranking ranking;
  final EventLevel level;
  final DateTime date;
  final String address;
  final EventStatus status;
  final String reglamentoUrl;
  final String imageUrl;
  final String observations;
  final String? director;
  final int? score;
  final bool? isOfficial;
  final double latitude;
  final double longitude;

  Event({
    required this.id,
    required this.name,
    required this.eventType,
    required this.competitionType,
    required this.ranking,
    required this.level,
    required this.date,
    required this.address,
    required this.status,
    required this.reglamentoUrl,
    required this.imageUrl,
    required this.observations,
    this.director,
    this.score,
    this.isOfficial,
    required this.latitude,
    required this.longitude,
  });
}
