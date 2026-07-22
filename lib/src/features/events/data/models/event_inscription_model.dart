import '../../domain/entities/event_inscription.dart';

class EventInscriptionModel extends EventInscription {
  EventInscriptionModel({
    required String athleteId,
    required String athleteName,
    required String academyName,
    required bool isWeighed,
  }) : super(
    athleteId: athleteId,
    athleteName: athleteName,
    academyName: academyName,
    isWeighed: isWeighed,
  );

  factory EventInscriptionModel.fromMap(String id, Map<String, dynamic> map) {
    return EventInscriptionModel(
      athleteId: id,
      athleteName: map['athleteName'] ?? '',
      academyName: map['academyName'] ?? '',
      isWeighed: map['isWeighed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'athleteName': athleteName,
      'academyName': academyName,
      'isWeighed': isWeighed,
    };
  }
}
