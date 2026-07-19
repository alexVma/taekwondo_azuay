import '../entities/academy.dart';

abstract class AcademyRepository {
  Future<List<Academy>> getAcademies();

  Future<void> saveAcademies(
      List<Academy> academies,
      );
}