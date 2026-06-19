import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_collar_app/core/providers/app_services.dart';
import 'package:smart_collar_app/core/providers/session_provider.dart';
import 'package:smart_collar_app/features/dashboard/data/dashboard_repository.dart';
import 'package:smart_collar_app/features/dashboard/data/models/sensor_reading.dart';
import 'package:smart_collar_app/features/herd/providers/herd_provider.dart';

class ReadingsState {
  const ReadingsState({
    this.latest,
    this.recent = const [],
    this.latestByCollar = const {},
    this.isConnected = false,
    this.lastUpdated,
  });

  final SensorReading? latest;
  final List<SensorReading> recent;
  final Map<String, SensorReading> latestByCollar;
  final bool isConnected;
  final DateTime? lastUpdated;

  ReadingsState copyWith({
    SensorReading? latest,
    List<SensorReading>? recent,
    Map<String, SensorReading>? latestByCollar,
    bool? isConnected,
    DateTime? lastUpdated,
  }) {
    return ReadingsState(
      latest: latest ?? this.latest,
      recent: recent ?? this.recent,
      latestByCollar: latestByCollar ?? this.latestByCollar,
      isConnected: isConnected ?? this.isConnected,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class LiveReadingsNotifier extends StateNotifier<ReadingsState> {
  LiveReadingsNotifier() : super(const ReadingsState());

  void updateReading(SensorReading reading) {
    final alreadyRecorded = state.recent.any(
      (item) =>
          item.collarId == reading.collarId &&
          item.recordedAt.isAtSameMomentAs(reading.recordedAt),
    );
    final updatedRecent = alreadyRecorded
        ? state.recent
        : [...state.recent, reading];
    final updatedLatestByCollar = {
      ...state.latestByCollar,
      reading.collarId: reading,
    };
    state = state.copyWith(
      latest: reading,
      recent: updatedRecent.length > 24
          ? updatedRecent.sublist(updatedRecent.length - 24)
          : updatedRecent,
      latestByCollar: updatedLatestByCollar,
      lastUpdated: DateTime.now(),
    );
  }

  void updateFarmReadings(List<SensorReading> readings) {
    if (readings.isEmpty) {
      state = state.copyWith(
        isConnected: false,
        lastUpdated: DateTime.now(),
      );
      return;
    }

    for (final reading in readings) {
      updateReading(reading);
    }
    state = state.copyWith(isConnected: true, lastUpdated: DateTime.now());
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

final farmLatestReadingsProvider = FutureProvider<List<SensorReading>>((
  ref,
) async {
  final animals = await ref.watch(herdAnimalsProvider.future);
  final repository = ref.watch(dashboardRepositoryProvider);
  final readings = <SensorReading>[];

  for (final animal in animals) {
    try {
      final reading = await repository.fetchLatestReading(animal.id);
      if (reading != null) {
        readings.add(reading);
      }
    } catch (_) {
      // A single missing collar reading should not block the farm dashboard.
    }
  }

  ref.read(liveReadingsProvider.notifier).updateFarmReadings(readings);
  return readings;
});
