import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 6),
        Text(
          'Manage your profile, farm, and collar preferences.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: kTextSecond),
        ),
        const SizedBox(height: 20),
        _SectionTile(title: 'Profile'),
        _SectionTile(title: 'Farm'),
        _SectionTile(title: 'Collar management'),
        _SectionTile(title: 'Notifications'),
        _SectionTile(
          title: 'Alert thresholds',
          onTap: () => context.go('/alerts/thresholds'),
        ),
        _SectionTile(title: 'Data & Privacy'),
        _SectionTile(title: 'About', onTap: () => context.go('/about')),
      ],
    );
  }
}

class _SectionTile extends StatelessWidget {
  const _SectionTile({required this.title, this.onTap});

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kBgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kAccentSoft),
        ),
        child: Row(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const Spacer(),
            const Icon(Icons.chevron_right, color: kTextMuted),
          ],
        ),
      ),
    );
  }
}
