import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_collar_app/features/alerts/providers/alerts_provider.dart';
import 'package:smart_collar_app/features/dashboard/providers/live_readings_provider.dart';
import 'package:smart_collar_app/features/herd/providers/herd_provider.dart';
import 'package:smart_collar_app/features/history/providers/history_provider.dart';

const realtimeRefreshInterval = Duration(seconds: 5);

final realtimeRefreshTickProvider = StreamProvider.autoDispose<int>((ref) {
  final controller = StreamController<int>();
  var tick = 0;
  final timer = Timer.periodic(realtimeRefreshInterval, (_) {
    if (!controller.isClosed) controller.add(++tick);
  });

  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  return controller.stream;
});

void invalidateRealtimeFarmData(WidgetRef ref) {
  ref.invalidate(farmCollarsProvider);
  ref.invalidate(herdAnimalsProvider);
  ref.invalidate(farmLatestReadingsProvider);
  ref.invalidate(latestReadingProvider);
  ref.invalidate(alertsProvider);
  ref.invalidate(historyReadingsProvider);
}

Future<void> refreshRealtimeFarmData(WidgetRef ref) async {
  invalidateRealtimeFarmData(ref);
  await Future.wait([
    ref.read(farmCollarsProvider.future),
    ref.read(herdAnimalsProvider.future),
    ref.read(farmLatestReadingsProvider.future),
    ref.read(alertsProvider.future),
  ]);
}
