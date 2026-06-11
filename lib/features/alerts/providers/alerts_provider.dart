import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_collar_app/core/providers/app_services.dart';
import 'package:smart_collar_app/core/providers/session_provider.dart';
import 'package:smart_collar_app/features/alerts/data/alerts_repository.dart';
import 'package:smart_collar_app/features/alerts/data/models/alert.dart';
import 'package:smart_collar_app/features/alerts/data/models/alert_threshold.dart';

final alertsRepositoryProvider = Provider<AlertsRepository>((ref) {
  return AlertsRepository(apiClient: ref.watch(apiClientProvider));
});

final alertsProvider = FutureProvider<List<Alert>>((ref) async {
  final farmId = await ref.watch(currentFarmIdProvider.future);
  if (farmId == null) {
    return [];
  }
  return ref.read(alertsRepositoryProvider).fetchAlerts(farmId: farmId);
});

final alertDetailProvider = FutureProvider.family<Alert, String>((ref, id) {
  return ref.watch(alertsRepositoryProvider).fetchAlert(id);
});

final thresholdProvider = FutureProvider<AlertThreshold?>((ref) async {
  final farmId = await ref.watch(currentFarmIdProvider.future);
  if (farmId == null) return null;
  return ref.watch(alertsRepositoryProvider).fetchThreshold(farmId);
});

final thresholdControllerProvider =
    StateNotifierProvider<ThresholdController, AsyncValue<void>>((ref) {
      return ThresholdController(ref);
    });

class ThresholdController extends StateNotifier<AsyncValue<void>> {
  ThresholdController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<void> save(AlertThreshold threshold) async {
    state = const AsyncLoading();
    try {
      await _ref.read(alertsRepositoryProvider).updateThreshold(threshold);
      _ref.invalidate(thresholdProvider);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
