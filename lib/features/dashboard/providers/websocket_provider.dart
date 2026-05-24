import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_collar_app/core/network/websocket_service.dart';
import 'package:smart_collar_app/features/dashboard/data/models/sensor_reading.dart';
import 'package:smart_collar_app/features/dashboard/providers/live_readings_provider.dart';

final websocketServiceProvider = Provider<WebSocketService>((ref) {
  return WebSocketService(baseUrl: 'ws://yourserver/ws');
});

final websocketStreamProvider = StreamProvider<void>((ref) {
  final service = ref.watch(websocketServiceProvider);
  final controller = StreamController<void>();

  service.stream.listen((event) {
    final type = event['type'];
    final data = event['data'];
    if (type == 'reading' && data is Map<String, dynamic>) {
      ref.read(liveReadingsProvider.notifier).updateReading(
            SensorReading.fromJson(data),
          );
    }
    if (type == 'collar_status') {
      ref.read(liveReadingsProvider.notifier).setConnection(true);
    }
  });

  ref.onDispose(() {
    controller.close();
  });

  return controller.stream;
});
