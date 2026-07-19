import '../../domain/entities/academy.dart';
import '../../domain/repository/academy_repository.dart';
import '../datasource/academy_firestore_datasource.dart';
import '../models/academy_model.dart';

class AcademyRepositoryImpl implements AcademyRepository {
  final AcademyFirestoreDatasource datasource;

  AcademyRepositoryImpl(this.datasource);

  @override
  Future<List<Academy>> getAcademies() {
    return datasource.getAcademies();
  }

  @override
  Future<void> saveAcademies(
      List<Academy> academies,
      ) async {
    final models = academies
        .map(
          (e) => AcademyModel(
        id: e.id,
        name: e.name,
        url: e.url,
        coach: e.coach,
        address: e.address,
        phone: e.phone,
        schedule: e.schedule,
        badge: e.badge,
        latitude: e.latitude,
        longitude: e.longitude,
      ),
    )
        .toList();

    await datasource.saveAcademies(models);
  }
}