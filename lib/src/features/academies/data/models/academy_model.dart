import '../../domain/entities/academy.dart';
import '../../domain/enums/academy_type.dart';
import '../../domain/enums/competition_level.dart';
import '../../domain/enums/academy_status.dart';

class AcademyModel extends Academy {
  const AcademyModel({
    required super.id,
    required super.name,
    required super.url,
    required super.coach,
    required super.address,
    required super.phone,
    required super.schedule,
    required super.badge,
    required super.latitude,
    required super.longitude,
    required super.type,
    required super.competitionLevel,
    required super.status,
    required super.representative,
    required super.email,
  });

  factory AcademyModel.fromMap(
      Map<String, dynamic> map,
      String id,
      ) {
    final type = AcademyType.values.firstWhere(
      (e) => e.displayName == map['type'],
      orElse: () => AcademyType.noAfiliado,
    );
    final level = CompetitionLevel.values.firstWhere(
      (e) => e.displayName == map['competitionLevel'],
      orElse: () => CompetitionLevel.clubs,
    );
    final status = AcademyStatus.values.firstWhere(
      (e) => e.displayName == map['status'],
      orElse: () => AcademyStatus.activa,
    );

    return AcademyModel(
      id: id,
      name: map['name'] ?? '',
      url: map['url'] ??  '',
      coach: map['coach'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      schedule: map['schedule'] ?? '',
      badge: map['badge'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
      type: type,
      competitionLevel: level,
      status: status,
      representative: map['representative'] ?? '',
      email: map['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
      'imageUrl': url,
      'coach': coach,
      'address': address,
      'phone': phone,
      'schedule': schedule,
      'badge': badge,
      'latitude': latitude,
      'longitude': longitude,
      'type': type.displayName,
      'competitionLevel': competitionLevel.displayName,
      'status': status.displayName,
      'representative': representative,
      'email': email,
    };
  }
}