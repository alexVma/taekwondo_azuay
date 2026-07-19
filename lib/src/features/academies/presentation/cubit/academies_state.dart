import 'package:equatable/equatable.dart';

import '../../domain/entities/academy.dart';

enum AcademiesStatus {
  initial,
  loading,
  success,
  error,
}

class AcademiesState extends Equatable {

  const AcademiesState({
    this.status = AcademiesStatus.initial,
    this.academies = const [],
    this.errorMessage = '',
  });

  final AcademiesStatus status;

  final List<Academy> academies;

  final String errorMessage;

  AcademiesState copyWith({
    AcademiesStatus? status,
    List<Academy>? academies,
    String? errorMessage,
  }) {
    return AcademiesState(
      status: status ?? this.status,
      academies: academies ?? this.academies,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
    status,
    academies,
    errorMessage,
  ];
}