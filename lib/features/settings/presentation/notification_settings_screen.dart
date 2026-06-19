import 'package:flutter/material.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/core/services/notification_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _alertsEnabled = false;
  bool _isRequesting = false;

  @override
  void initState() {
    super.initState();
    _refreshStatus();
  }

  Future<void> _refreshStatus() async {
    await NotificationService.instance.initialize();
    await NotificationService.instance.refreshAndroidPermission();
    if (!mounted) return;
    setState(() {
      _alertsEnabled = NotificationService.instance.isPermissionGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Notifications',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        Text(
          'Enable alert permission for health, battery, and offline collar events.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          value: _alertsEnabled,
          onChanged: _isRequesting ? null : _toggleNotifications,
          title: const Text('Push alerts'),
          subtitle: const Text('Health risk, low battery, and collar offline'),
          activeThumbColor: kAccentPrimary,
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _sendTestNotification,
          icon: const Icon(Icons.notifications_active_outlined),
          label: const Text('Send test alert'),
        ),
      ],
    );
  }

  Future<void> _toggleNotifications(bool enabled) async {
    if (!enabled) {
      setState(() => _alertsEnabled = false);
      return;
    }
    setState(() => _isRequesting = true);
    final granted = await NotificationService.instance.requestPermission();
    await NotificationService.instance.refreshAndroidPermission();
    if (!mounted) return;
    setState(() {
      _alertsEnabled = granted;
      _isRequesting = false;
    });
  }

  Future<void> _sendTestNotification() async {
    await NotificationService.instance.showAlertNotification(
      title: 'Smart Collar test alert',
      body: 'Notifications are working. You will hear from us on every critical event.',
    );
  }
}
