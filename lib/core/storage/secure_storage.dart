import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage() : _storage = const FlutterSecureStorage();

  static const _tokenKey = 'auth_token';
  static const _farmIdKey = 'current_farm_id';
  static const _animalIdKey = 'current_animal_id';

  final FlutterSecureStorage _storage;

  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<void> clearToken() => _storage.delete(key: _tokenKey);

  Future<void> saveCurrentFarmId(String farmId) =>
      _storage.write(key: _farmIdKey, value: farmId);

  Future<String?> readCurrentFarmId() => _storage.read(key: _farmIdKey);

  Future<void> saveCurrentAnimalId(String animalId) =>
      _storage.write(key: _animalIdKey, value: animalId);

  Future<String?> readCurrentAnimalId() => _storage.read(key: _animalIdKey);

  Future<void> clearSession() => _storage.deleteAll();
}
