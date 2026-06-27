import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/storage/hive_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveInit.init();
  await configureDependencies();
  runApp(const SightourApp());
}
