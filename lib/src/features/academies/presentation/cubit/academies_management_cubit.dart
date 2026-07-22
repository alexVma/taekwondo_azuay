import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/academy_model.dart';
import '../../data/repositories/academies_management_repository.dart';
import 'academies_management_state.dart';

class AcademiesManagementCubit extends Cubit<AcademiesManagementState> {
  final AcademiesManagementRepository academiesRepository;

  AcademiesManagementCubit({required this.academiesRepository})
      : super(const AcademiesManagementState.initial());

  Future<void> loadAcademies() async {
    emit(const AcademiesManagementState.loading());
    try {
      final academies = await academiesRepository.getAllAcademies();
      emit(AcademiesManagementState.loaded(academies));
    } catch (e) {
      emit(AcademiesManagementState.error('Error al cargar academias: $e'));
    }
  }

  Future<void> createAcademy(AcademyModel academy) async {
    try {
      final success = await academiesRepository.createAcademy(academy);
      if (success) {
        await loadAcademies();
      } else {
        emit(const AcademiesManagementState.error('Error al crear academia'));
      }
    } catch (e) {
      emit(AcademiesManagementState.error('Error: $e'));
    }
  }

  Future<void> updateAcademy(AcademyModel academy) async {
    try {
      final success = await academiesRepository.updateAcademy(academy);
      if (success) {
        await loadAcademies();
      } else {
        emit(const AcademiesManagementState.error('Error al actualizar academia'));
      }
    } catch (e) {
      emit(AcademiesManagementState.error('Error: $e'));
    }
  }

  Future<void> deleteAcademy(String academyId) async {
    try {
      final success = await academiesRepository.deleteAcademy(academyId);
      if (success) {
        await loadAcademies();
      } else {
        emit(const AcademiesManagementState.error('Error al eliminar academia'));
      }
    } catch (e) {
      emit(AcademiesManagementState.error('Error: $e'));
    }
  }
}
