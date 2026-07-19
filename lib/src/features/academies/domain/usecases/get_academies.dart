import '../entities/academy.dart';
import '../repository/academy_repository.dart';

class GetAcademies {
  final AcademyRepository repository;

  GetAcademies(this.repository);

  Future<List<Academy>> call() {
    return repository.getAcademies();
  }
}