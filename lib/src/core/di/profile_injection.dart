import 'package:get_it/get_it.dart';
import 'package:taekwondo_azuay/src/features/academies/data/repositories/academies_management_repository.dart';
import 'package:taekwondo_azuay/src/features/academies/presentation/cubit/academies_management_cubit.dart';
import 'package:taekwondo_azuay/src/features/profile/data/repositories/auth_repository.dart';
import 'package:taekwondo_azuay/src/features/profile/data/repositories/user_repository.dart';
import 'package:taekwondo_azuay/src/features/profile/presentation/cubit/auth_cubit.dart';
import 'package:taekwondo_azuay/src/features/profile/presentation/cubit/users_cubit.dart';

final sl = GetIt.instance;

void initProfileDependencies() {
  sl.registerSingleton<AuthRepository>(AuthRepository());
  sl.registerSingleton<UserRepository>(UserRepository());
  sl.registerSingleton<AcademiesManagementRepository>(
      AcademiesManagementRepository());
  sl.registerSingleton<AuthCubit>(
    AuthCubit(authRepository: sl<AuthRepository>()),
  );
  sl.registerSingleton<UsersCubit>(
    UsersCubit(userRepository: sl<UserRepository>()),
  );
  sl.registerSingleton<AcademiesManagementCubit>(
    AcademiesManagementCubit(
        academiesRepository: sl<AcademiesManagementRepository>()),
  );
}
