import 'package:get_it/get_it.dart';
import 'package:taekwondo_azuay/src/features/profile/data/repositories/auth_repository.dart';
import 'package:taekwondo_azuay/src/features/profile/presentation/cubit/auth_cubit.dart';

final sl = GetIt.instance;

void initProfileDependencies() {
  sl.registerSingleton<AuthRepository>(AuthRepository());
  sl.registerSingleton<AuthCubit>(
    AuthCubit(authRepository: sl<AuthRepository>()),
  );
}
