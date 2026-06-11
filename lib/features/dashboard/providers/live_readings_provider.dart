import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_collar_app/core/providers/app_services.dart';
import 'package:smart_collar_app/core/providers/session_provider.dart';
import 'package:smart_collar_app/features/dashboard/data/dashboard_repository.dart';
import 'package:smart_collar_app/features/dashboard/data/models/sensor_reading.dart';

class ReadingsState {
  const ReadingsState({
    this.latest,
    this.isConnected = false,
    this.lastUpdated,
  });

  final SensorReading? latest;
  final bool isConnected;
  final DateTime? lastUpdated;

  ReadingsState copyWith({
    SensorReading? latest,
    bool? isConnected,
    DateTime? lastUpdated,
  }) {
    return ReadingsState(
      latest: latest ?? this.latest,
      isConnected: isConnected ?? this.isConnected,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class LiveReadingsNotifier extends StateNotifier<ReadingsState> {
  LiveReadingsNotifier() : super(const ReadingsState());

  void updateReading(SensorReading reading) {
    state = state.copyWith(latest: reading, lastUpdated: DateTime.now());
  }

  void setConnection(bool isConnected) {
    state = state.copyWith(isConnected: isConnected);
  }
}

final liveReadingsProvider =
    StateNotifierProvider<LiveReadingsNotifier, ReadingsState>(
      (ref) => LiveReadingsNotifier(),
    );

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(
    apiClient: ref.watch(apiClientProvider),
    hiveService: ref.watch(hiveServiceProvider),
  );
});

final latestReadingProvider = FutureProvider<SensorReading?>((ref) async {
  final animalId = await ref.watch(currentAnimalIdProvider.future);
  if (animalId == null) return null;
  final reading = await ref
      .watch(dashboardRepositoryProvider)
      .fetchLatestReading(animalId);
  if (reading != null) {
    ref.read(liveReadingsProvider.notifier).updateReading(reading);
  }
  return reading;
});
