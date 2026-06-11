import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  HiveService();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    await Hive.initFlutter();
    _isInitialized = true;
  }

  Future<void> putJsonList({
    required String boxName,
    required String key,
    required List<Map<String, dynamic>> value,
  }) async {
    await init();
    final box = await Hive.openBox<List>(boxName);
    await box.put(key, value);
  }

  Future<List<Map<String, dynamic>>> readJsonList({
    required String boxName,
    required String key,
  }) async {
    await init();
    final box = await Hive.openBox<List>(boxName);
    final value = box.get(key);
    if (value == null) return [];
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}
