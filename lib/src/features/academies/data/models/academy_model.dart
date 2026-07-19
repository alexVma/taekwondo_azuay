import '../../domain/entities/academy.dart';

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
  });

  factory AcademyModel.fromMap(
      Map<String, dynamic> map,
      String id,
      ) {
    return AcademyModel(
      id: id,
      name: map['name'] ?? '',
      url: map['url'] ?? '',
      coach: map['coach'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      schedule: map['schedule'] ?? '',
      badge: map['badge'] ?? '',
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
      'coach': coach,
      'address': address,
      'phone': phone,
      'schedule': schedule,
      'badge': badge,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}