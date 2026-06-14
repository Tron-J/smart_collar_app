import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_collar_app/core/network/websocket_service.dart';
import 'package:smart_collar_app/core/providers/app_services.dart';
import 'package:smart_collar_app/features/dashboard/data/models/sensor_reading.dart';
import 'package:smart_collar_app/features/dashboard/providers/live_readings_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final websocketServiceProvider = Provider<WebSocketService>((ref) {
  final config = ref.watch(appConfigProvider);
  final service = WebSocketService(baseUrl: config.websocketBaseUrl);
  ref.onDispose(service.dispose);
  return service;
});

final websocketStreamProvider = StreamProvider<void>((ref) {
  final service = ref.watch(websocketServiceProvider);
  final controller = StreamController<void>();

  StreamSubscription<Map<String, dynamic>>? subscription;

  Future<void> connect() async {
    final token = Supabase.instance.client.auth.currentSession?.accessToken;
    if (token == null || token.isEmpty || service.baseUrl.trim().isEmpty) {
      ref.read(liveReadingsProvider.notifier).setConnection(false);
      return;
    }
    service.connect(token);
  }

  subscription = service.stream.listen((event) {
    final type = event['type'];
    final data = event['data'];
    if (type == 'reading' && data is Map<String, dynamic>) {
      ref
          .read(liveReadingsProvider.notifier)
          .updateReading(SensorReading.fromJson(data));
    }
    if (type == 'collar_status') {
      ref.read(liveReadingsProvider.notifier).setConnection(true);
    }
    controller.add(null);
  });

  unawaited(connect());

  ref.onDispose(() {
    subscription?.cancel();
    service.disconnect();
    ref.read(liveReadingsProvider.notifier).setConnection(false);
    controller.close();
  });

  return controller.stream;
});
