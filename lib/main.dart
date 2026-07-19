import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '/src/core/di/injector.dart';

import 'RankingImporter.dart';
import 'firebase_options.dart';
import 'package:taekwondo_azuay/src/app/taekwondo_azuay_app.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initDependencies();
//
  final importer = RankingImporter();

  await importer.importar();
  runApp(const TaekwondoAzuayApp());
}
