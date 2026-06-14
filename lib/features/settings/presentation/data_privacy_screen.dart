import 'package:flutter/material.dart';
import 'package:smart_collar_app/core/constants/colors.dart';

class DataPrivacyScreen extends StatelessWidget {
  const DataPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Data & Privacy',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        Text(
          'Smart Collar stores farm, collar, animal, reading, and alert data for monitoring.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
        ),
        const SizedBox(height: 16),
        const _PrivacyTile(
          icon: Icons.cloud_done_outlined,
          title: 'Cloud data',
          detail: 'Sensor readings and alerts are synced through the backend.',
        ),
        const _PrivacyTile(
          icon: Icons.lock_outline_rounded,
          title: 'Authentication',
          detail: 'Account access is handled by Supabase Auth.',
        ),
        const _PrivacyTile(
          icon: Icons.delete_outline_rounded,
          title: 'Data removal',
          detail:
              'Delete requests should be handled by the farm administrator.',
        ),
      ],
    );
  }
}

class _PrivacyTile extends StatelessWidget {
  const _PrivacyTile({
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kAccentSoft),
      ),
      child: Row(
        children: [
          Icon(icon, color: kAccentPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: kTextSecond),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
