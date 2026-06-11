import 'package:flutter/material.dart';
import 'package:smart_collar_app/core/constants/colors.dart';

class CollarStatusBar extends StatelessWidget {
  const CollarStatusBar({super.key, required this.isConnected});

  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    final color = isConnected ? kHealthy : kTextMuted;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kBgCardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kAccentSoft),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            isConnected ? 'Collar online' : 'Collar offline',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: kTextSecond),
          ),
          const Spacer(),
          Text(
            'Last ping: --',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: kTextMuted),
          ),
        ],
      ),
    );
  }
}
