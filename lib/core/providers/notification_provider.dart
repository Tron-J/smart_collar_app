import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_collar_app/core/services/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
