import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_collar_app/core/config/app_config.dart';
import 'package:smart_collar_app/core/network/api_client.dart';
import 'package:smart_collar_app/core/storage/hive_service.dart';
import 'package:smart_collar_app/core/storage/secure_storage.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.fromEnvironment();
});

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final storage = ref.watch(secureStorageProvider);
  return ApiClient(baseUrl: config.apiBaseUrl, storage: storage);
});

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});
