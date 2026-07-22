import 'academy_injection.dart';
import 'profile_injection.dart';

Future<void> initDependencies() async {
  await initAcademyDependencies();
  initProfileDependencies();
}