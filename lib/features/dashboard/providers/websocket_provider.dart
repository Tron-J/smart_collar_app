import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_collar_app/core/network/websocket_service.dart';
import 'package:smart_collar_app/core/providers/app_services.dart';
import 'package:smart_collar_app/core/providers/notification_provider.dart';
import 'package:smart_collar_app/core/providers/session_provider.dart';
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
  final currentFarmId = ref.watch(currentFarmIdProvider);
  final notifications = ref.read(notificationServiceProvider);
  final controller = StreamController<void>();

  StreamSubscription<Map<String, dynamic>>? subscription;
  String? subscribedFarmId;

  Future<void> subscribeFarm(String farmId) async {
    if (farmId.isEmpty || farmId == subscribedFarmId || service.baseUrl.trim().isEmpty) {
      return;
    }
    subscribedFarmId = farmId;
    service.send({'type': 'subscribe_farm', 'farm_id': farmId});
  }

  Future<void> connectAndSubscribe() async {
    final token = Supabase.instance.client.auth.currentSession?.accessToken;
    if (token == null || token.isEmpty || service.baseUrl.trim().isEmpty) {
      ref.read(liveReadingsProvider.notifier).setConnection(false);
      return;
    }
    service.connect(token, onConnected: () {
      currentFarmId.whenData((farmId) {
        if (farmId != null) {
          unawaited(subscribeFarm(farmId));
        }
      });
    });
  }

  ref.listen(currentFarmIdProvider, (previous, next) {
    next.whenData((farmId) {
      if (farmId != null) {
        unawaited(subscribeFarm(farmId));
      }
    });
  });

  subscription = service.stream.listen((event) {
    final type = event['type'];
    final data = event['data'];

    if (type == 'reading' && data is Map<String, dynamic>) {
      final notifier = ref.read(liveReadingsProvider.notifier);
      notifier.updateReading(SensorReading.fromJson(data));
      notifier.setConnection(true);
    }

    if (type == 'collar_status') {
      ref.read(liveReadingsProvider.notifier).setConnection(true);
    }

    if (type == 'alert' && data is Map<String, dynamic>) {
      final message = data['message']?.toString() ?? 'New collar alert';
      final title = data['severity']?.toString() == 'critical'
          ? 'Critical health alert'
          : 'Health alert';
      unawaited(
        notifications.showAlertNotification(
          title: title,
          body: message,
          payload: data['id']?.toString(),
        ),
      );
    }

    controller.add(null);
  });

  unawaited(connectAndSubscribe());

  ref.onDispose(() {
    subscription?.cancel();
    service.disconnect();
    ref.read(liveReadingsProvider.notifier).setConnection(false);
    controller.close();
  });

  return controller.stream;
});

