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
      ],
    );
  }

  Future<void> _toggleNotifications(bool enabled) async {
    if (!enabled) {
      setState(() => _alertsEnabled = false);
      return;
    }
    setState(() => _isRequesting = true);
    final granted = await NotificationService().requestPermission();
    if (!mounted) return;
    setState(() {
      _alertsEnabled = granted;
      _isRequesting = false;
    });
  }
}
