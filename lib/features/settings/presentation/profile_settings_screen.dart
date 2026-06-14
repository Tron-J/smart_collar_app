import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Profile', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        _InfoTile(
          title: 'Email',
          value: user?.email ?? 'Signed in user',
          icon: Icons.mail_outline_rounded,
        ),
        _InfoTile(
          title: 'Account ID',
          value: user?.id ?? 'Unavailable',
          icon: Icons.badge_outlined,
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () async {
            await Supabase.instance.client.auth.signOut();
            if (context.mounted) context.go('/welcome');
          },
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Sign out'),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

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
                  value,
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
