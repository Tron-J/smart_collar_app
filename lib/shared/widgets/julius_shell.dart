import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';

class JuliusShell extends StatelessWidget {
  const JuliusShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  int _indexFromLocation() {
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/sensors')) return 1;
    if (location.startsWith('/alerts')) return 2;
    if (location.startsWith('/history')) return 3;
    if (location.startsWith('/settings') || location.startsWith('/about')) {
      return 4;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _indexFromLocation();
    return Scaffold(
      backgroundColor: kBgDeep,
      body: SafeArea(child: child),
      bottomNavigationBar: _BottomNavBar(
        currentIndex: index,
        onTap: (next) {
          switch (next) {
            case 0:
              context.go('/dashboard');
              break;
            case 1:
              context.go('/sensors');
              break;
            case 2:
              context.go('/alerts');
              break;
            case 3:
              context.go('/history');
              break;
            case 4:
              context.go('/settings');
              break;
          }
        },
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kBgCard,
        border: Border(top: BorderSide(color: kAccentSoft)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _NavItem(
            label: 'Dashboard',
            icon: Icons.dashboard_rounded,
            isActive: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavItem(
            label: 'Sensors',
            icon: Icons.sensors,
            isActive: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _NavItem(
            label: 'Alerts',
            icon: Icons.notifications_active_outlined,
            isActive: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          _NavItem(
            label: 'History',
            icon: Icons.timeline_rounded,
            isActive: currentIndex == 3,
            onTap: () => onTap(3),
          ),
          _NavItem(
            label: 'Settings',
            icon: Icons.settings,
            isActive: currentIndex == 4,
            onTap: () => onTap(4),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? kAccentPrimary : kTextMuted;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: color),
              ),
              const SizedBox(height: 4),
              Container(
                width: 24,
                height: 3,
                decoration: BoxDecoration(
                  color: isActive ? kAccentPrimary : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
