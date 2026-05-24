import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    state = state.copyWith(
      latest: reading,
      lastUpdated: DateTime.now(),
    );
  }

  void setConnection(bool isConnected) {
    state = state.copyWith(isConnected: isConnected);
  }
}

final liveReadingsProvider =
    StateNotifierProvider<LiveReadingsNotifier, ReadingsState>(
  (ref) => LiveReadingsNotifier(),
);
