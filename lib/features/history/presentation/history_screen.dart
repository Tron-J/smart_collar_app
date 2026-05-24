import 'package:flutter/material.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/shared/widgets/loading_shimmer.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'History',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 6),
        Text(
          'Select a time range to explore temperature, heart rate, and activity trends.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: kTextSecond),
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
            'Last 24 hours',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        const SizedBox(height: 20),
        const LoadingShimmer(height: 180),
        const SizedBox(height: 12),
        const LoadingShimmer(height: 180),
      ],
    );
  }
}
