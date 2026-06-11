import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/features/alerts/providers/alerts_provider.dart';
import 'package:smart_collar_app/shared/widgets/error_view.dart';
import 'package:smart_collar_app/shared/widgets/loading_shimmer.dart';
import 'package:smart_collar_app/shared/widgets/teal_button.dart';

class AlertDetailScreen extends ConsumerWidget {
  const AlertDetailScreen({super.key, required this.alertId});

  final String alertId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertValue = ref.watch(alertDetailProvider(alertId));

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Alert detail', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 6),
        Text(
          'Alert ID: $alertId',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: kTextMuted),
        ),
        const SizedBox(height: 16),
        alertValue.when(
          loading: () => const LoadingShimmer(height: 220),
          error: (error, _) => ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(alertDetailProvider(alertId)),
          ),
          data: (alert) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kBgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kAccentSoft),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(alert.alertType.name.toUpperCase()),
                    const SizedBox(height: 8),
                    Text(
                      alert.message,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
                    ),
                    const SizedBox(height: 12),
                    Text('Severity: ${alert.severity.name}'),
                    Text('Temperature: ${alert.tempAtAlert ?? '--'}'),
                    Text('Heart rate: ${alert.hrAtAlert ?? '--'}'),
                    Text('Risk score: ${alert.riskScore ?? '--'}'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TealButton.filled(
                label: alert.isResolved ? 'Resolved' : 'Mark as resolved',
                onPressed: alert.isResolved
                    ? null
                    : () async {
                        await ref
                            .read(alertsRepositoryProvider)
                            .resolveAlert(alert.id);
                        ref.invalidate(alertDetailProvider(alert.id));
                        ref.invalidate(alertsProvider);
                      },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
