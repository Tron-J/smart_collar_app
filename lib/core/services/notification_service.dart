import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  Future<bool> requestPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted || status.isLimited;
  }

  Future<String?> registerDeviceToken() async {
    await requestPermission();
    return null;
  }
}
