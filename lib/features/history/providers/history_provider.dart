import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_collar_app/core/providers/session_provider.dart';
import 'package:smart_collar_app/features/dashboard/data/models/sensor_reading.dart';
import 'package:smart_collar_app/features/dashboard/providers/live_readings_provider.dart';

enum HistoryRange { sixHours, twentyFourHours, sevenDays, thirtyDays }

final historyRangeProvider = StateProvider<HistoryRange>(
  (ref) => HistoryRange.twentyFourHours,
);

final historyReadingsProvider = FutureProvider<List<SensorReading>>((
  ref,
) async {
  final animalId = await ref.watch(currentAnimalIdProvider.future);
  if (animalId == null) return [];
  final range = ref.watch(historyRangeProvider);
  final now = DateTime.now();
  final from = switch (range) {
    HistoryRange.sixHours => now.subtract(const Duration(hours: 6)),
    HistoryRange.twentyFourHours => now.subtract(const Duration(hours: 24)),
    HistoryRange.sevenDays => now.subtract(const Duration(days: 7)),
    HistoryRange.thirtyDays => now.subtract(const Duration(days: 30)),
  };
  return ref
      .watch(dashboardRepositoryProvider)
      .fetchReadings(animalId: animalId, from: from, to: now);
});
