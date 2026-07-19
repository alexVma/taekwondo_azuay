import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../../features/academies/data/datasource/academy_firestore_datasource.dart';
import '../../features/academies/data/repository/academy_repository_impl.dart';
import '../../features/academies/domain/repository/academy_repository.dart';
import '../../features/academies/domain/usecases/get_academies.dart';
import '../../features/academies/presentation/cubit/academies_cubit.dart';

final sl = GetIt.instance;

Future<void> initAcademyDependencies() async {

  // Firebase
  sl.registerLazySingleton<FirebaseFirestore>(
        () => FirebaseFirestore.instance,
  );

  // Datasource
  sl.registerLazySingleton<AcademyFirestoreDatasource>(
        () => AcademyFirestoreDatasource(sl()),
  );

  // Repository
  sl.registerLazySingleton<AcademyRepository>(
        () => AcademyRepositoryImpl(sl()),
  );

  // UseCases
  sl.registerLazySingleton<GetAcademies>(
        () => GetAcademies(sl()),
  );

  // Cubit
  sl.registerFactory<AcademiesCubit>(
        () => AcademiesCubit(sl()),
  );
}