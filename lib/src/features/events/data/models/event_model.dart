import '../../domain/entities/event.dart';
import '../../domain/enums/event_type.dart';
import '../../domain/enums/competition_type.dart';
import '../../domain/enums/ranking.dart';
import '../../domain/enums/event_level.dart';
import '../../domain/enums/event_status.dart';

class EventModel extends Event {
  EventModel({
    required String id,
    required String name,
    required EventType eventType,
    required CompetitionType competitionType,
    required Ranking ranking,
    required EventLevel level,
    required DateTime date,
    required String address,
    required EventStatus status,
    required String reglamentoUrl,
    required String imageUrl,
    required String observations,
    String? director,
    int? score,
    bool? isOfficial,
    required double latitude,
    required double longitude,
  }) : super(
    id: id,
    name: name,
    eventType: eventType,
    competitionType: competitionType,
    ranking: ranking,
    level: level,
    date: date,
    address: address,
    status: status,
    reglamentoUrl: reglamentoUrl,
    imageUrl: imageUrl,
    observations: observations,
    director: director,
    score: score,
    isOfficial: isOfficial,
    latitude: latitude,
    longitude: longitude,
  );

  factory EventModel.fromMap(String id, Map<String, dynamic> map) {
    return EventModel(
      id: id,
      name: map['name'] ?? '',
      eventType: EventType.values.firstWhere(
        (e) => e.displayName == map['eventType'],
        orElse: () => EventType.campeonato,
      ),
      competitionType: CompetitionType.values.firstWhere(
        (e) => e.displayName == map['competitionType'],
        orElse: () => CompetitionType.abierto,
      ),
      ranking: Ranking.values.firstWhere(
        (e) => e.displayName == map['ranking'],
        orElse: () => Ranking.na,
      ),
      level: EventLevel.values.firstWhere(
        (e) => e.displayName == map['level'],
        orElse: () => EventLevel.clubs,
      ),
      date: map['date'] != null
        ? DateTime.fromMillisecondsSinceEpoch(map['date'])
        : DateTime.now(),
      address: map['address'] ?? '',
      status: EventStatus.values.firstWhere(
        (e) => e.displayName == map['status'],
        orElse: () => EventStatus.activo,
      ),
      reglamentoUrl: map['reglamentoUrl'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      observations: map['observations'] ?? '',
      director: map['director'],
      score: map['score'],
      isOfficial: map['isOfficial'],
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'eventType': eventType.displayName,
      'competitionType': competitionType.displayName,
      'ranking': ranking.displayName,
      'level': level.displayName,
      'date': date.millisecondsSinceEpoch,
      'address': address,
      'status': status.displayName,
      'reglamentoUrl': reglamentoUrl,
      'imageUrl': imageUrl,
      'observations': observations,
      'director': director,
      'score': score,
      'isOfficial': isOfficial,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
