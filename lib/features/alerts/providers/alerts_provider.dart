import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_collar_app/core/network/api_client.dart';
import 'package:smart_collar_app/features/alerts/data/alerts_repository.dart';
import 'package:smart_collar_app/features/alerts/data/models/alert.dart';

final currentFarmIdProvider = Provider<String?>((ref) => null);

final alertsRepositoryProvider = Provider<AlertsRepository>((ref) {
  return AlertsRepository(apiClient: ApiClient(baseUrl: 'https://placeholder'));
});

final alertsProvider = FutureProvider<List<Alert>>((ref) async {
  final farmId = ref.watch(currentFarmIdProvider);
  if (farmId == null) {
    return [];
  }
  return ref.read(alertsRepositoryProvider).fetchAlerts(farmId: farmId);
});
