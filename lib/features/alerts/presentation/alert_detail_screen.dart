import 'package:flutter/material.dart';
import 'package:smart_collar_app/core/constants/colors.dart';

class AlertDetailScreen extends StatelessWidget {
  const AlertDetailScreen({super.key, required this.alertId});

  final String alertId;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Alert detail',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 6),
        Text(
          'Alert ID: $alertId',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: kTextMuted),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kBgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kAccentSoft),
          ),
          child: Text(
            'Full alert context will appear once live data is connected.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: kTextSecond),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: kBgCardLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              'Snapshot chart',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: kTextMuted),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: kAccentPrimary,
            foregroundColor: kBgDeep,
            disabledBackgroundColor: kAccentSoft,
            disabledForegroundColor: kTextMuted,
          ),
          child: const Text('Mark as resolved'),
        ),
      ],
    );
  }
}
