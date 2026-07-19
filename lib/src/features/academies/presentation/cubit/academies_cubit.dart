import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_academies.dart';
import 'academies_state.dart';

class AcademiesCubit extends Cubit<AcademiesState> {

  AcademiesCubit(
      this._getAcademies,
      ) : super(
    const AcademiesState(),
  );

  final GetAcademies _getAcademies;

  Future<void> loadAcademies() async {

    emit(
      state.copyWith(
        status: AcademiesStatus.loading,
      ),
    );

    try {

      final academies = await _getAcademies();

      emit(
        state.copyWith(
          status: AcademiesStatus.success,
          academies: academies,
        ),
      );

    } catch (e) {

      emit(
        state.copyWith(
          status: AcademiesStatus.error,
          errorMessage: e.toString(),
        ),
      );

    }

  }

}