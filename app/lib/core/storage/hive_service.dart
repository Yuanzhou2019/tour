import 'package:hive_ce/hive.dart';

class HiveService {
  HiveService(this._box);

  final Box _box;

  T? read<T>(String key, {T? defaultValue}) => _box.get(key, defaultValue: defaultValue) as T?;

  Future<void> write<T>(String key, T value) => _box.put(key, value);

  Future<void> delete(String key) => _box.delete(key);

  Future<void> clear() => _box.clear();

  Iterable<dynamic> get values => _box.values;

  static HiveService of(String boxName) => HiveService(Hive.box(boxName));
}
