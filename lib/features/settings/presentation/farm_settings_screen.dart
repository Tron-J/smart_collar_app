import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';

class FarmSettingsScreen extends StatelessWidget {
  const FarmSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Farm', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text(
          'Manage farm setup, animals, and paired collars.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
        ),
        const SizedBox(height: 16),
        _ActionTile(
          title: 'Farm setup',
          subtitle: 'Update the farm used by this device.',
          icon: Icons.agriculture_outlined,
          onTap: () => context.push('/farm-setup'),
        ),
        _ActionTile(
          title: 'Add animal',
          subtitle: 'Register a new animal profile.',
          icon: Icons.add_circle_outline_rounded,
          onTap: () => context.push('/add-animal'),
        ),
        _ActionTile(
          title: 'Pair collar',
          subtitle: 'Connect a collar to the farm.',
          icon: Icons.memory_rounded,
          onTap: () => context.push('/pair-collar'),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

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
            Icon(icon, color: kAccentPrimary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: kTextSecond),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: kTextMuted),
          ],
        ),
      ),
    );
  }
}
