import 'package:hive_ce/hive.dart';
import 'hive_boxes.dart';

class AnonymousId {
  AnonymousId._();

  static const _key = 'anonymousId';

  static String get() {
    final box = Hive.box(HiveBoxes.prefs);
    var id = box.get(_key) as String?;
    if (id == null) {
      id = 'anon_${DateTime.now().millisecondsSinceEpoch}';
      box.put(_key, id);
    }
    return id;
  }
}
