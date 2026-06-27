import 'package:hive_ce_flutter/hive_flutter.dart';

import 'hive_boxes.dart';

class HiveInit {
  HiveInit._();

  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox(HiveBoxes.prefs),
      Hive.openBox(HiveBoxes.checklist),
      Hive.openBox(HiveBoxes.offline),
      Hive.openBox(HiveBoxes.poiCache),
      Hive.openBox(HiveBoxes.search),
      Hive.openBox(HiveBoxes.favorites),
      Hive.openBox(HiveBoxes.drafts),
      Hive.openBox(HiveBoxes.correctionsDraft),
    ]);
  }
}
