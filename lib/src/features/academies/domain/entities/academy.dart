import '../enums/academy_type.dart';
import '../enums/competition_level.dart';
import '../enums/academy_status.dart';

class Academy {
  const Academy({
    required this.id,
    required this.name,
    required this.url,
    required this.coach,
    required this.address,
    required this.phone,
    required this.schedule,
    required this.badge,
    required this.latitude,
    required this.longitude,
    this.type = AcademyType.noAfiliado,
    this.competitionLevel = CompetitionLevel.clubs,
    this.status = AcademyStatus.activa,
    this.representative = '',
    this.email = '',
  });

  final String id;
  final String name;
  final String url;
  final String coach;
  final String address;
  final String phone;
  final String schedule;
  final String badge;
  final double latitude;
  final double longitude;
  final AcademyType type;
  final CompetitionLevel competitionLevel;
  final AcademyStatus status;
  final String representative;
  final String email;

}
