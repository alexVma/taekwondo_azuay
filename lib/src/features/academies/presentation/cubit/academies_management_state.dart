import 'package:equatable/equatable.dart';
import '../../data/models/academy_model.dart';

abstract class AcademiesManagementStateBase extends Equatable {
  const AcademiesManagementStateBase();

  @override
  List<Object?> get props => [];
}

class AcademiesManagementState extends AcademiesManagementStateBase {
  final AcademiesManagementStatus status;
  final List<AcademyModel> academies;
  final String? errorMessage;

  const AcademiesManagementState({
    this.status = AcademiesManagementStatus.initial,
    this.academies = const [],
    this.errorMessage,
  });

  const AcademiesManagementState.initial() : this(status: AcademiesManagementStatus.initial);

  const AcademiesManagementState.loading() : this(status: AcademiesManagementStatus.loading);

  const AcademiesManagementState.loaded(List<AcademyModel> academies)
      : this(status: AcademiesManagementStatus.loaded, academies: academies);

  const AcademiesManagementState.error(String message)
      : this(status: AcademiesManagementStatus.error, errorMessage: message);

  @override
  List<Object?> get props => [status, academies, errorMessage];
}

enum AcademiesManagementStatus { initial, loading, loaded, error }
