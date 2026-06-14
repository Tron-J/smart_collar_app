import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/features/herd/providers/herd_provider.dart';
import 'package:smart_collar_app/features/onboarding/data/models/collar.dart';
import 'package:smart_collar_app/shared/widgets/primary_button.dart';
import 'package:smart_collar_app/shared/widgets/error_view.dart';
import 'package:smart_collar_app/shared/widgets/loading_shimmer.dart';
import 'package:smart_collar_app/shared/widgets/status_badge.dart';

class CollarsScreen extends ConsumerWidget {
  const CollarsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collarsValue = ref.watch(farmCollarsProvider);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Collars', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 6),
        Text(
          'Farm collars and their latest device status.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
        ),
        const SizedBox(height: 16),
        PrimaryButton.filled(
          label: 'Add animal and collar',
          onPressed: () => context.go('/add-animal'),
        ),
        const SizedBox(height: 16),
        collarsValue.when(
          loading: () => const LoadingShimmer(height: 220),
          error: (error, _) => ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(farmCollarsProvider),
          ),
          data: (collars) {
            if (collars.isEmpty) {
              return const _EmptyCollarsState();
            }
            return Column(
              children: collars
                  .map(
                    (collar) => _CollarCard(
                      collar: collar,
                      onTap: () => context.go('/collars/${collar.id}'),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _CollarCard extends StatelessWidget {
  const _CollarCard({required this.collar, required this.onTap});

  final Collar collar;
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
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: kAccentPrimary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.memory_rounded, color: kAccentPrimary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    collar.deviceId,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Battery ${collar.batteryPct ?? 0}% | Wi-Fi ${collar.wifiRssi ?? 0}%',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: kTextSecond),
                  ),
                ],
              ),
            ),
            StatusBadge(
              label: collar.isOnline ? 'Online' : 'Offline',
              color: collar.isOnline ? kAccentPrimary : kTextMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCollarsState extends StatelessWidget {
  const _EmptyCollarsState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kAccentSoft),
      ),
      child: Text(
        'No collars are registered for this farm yet.',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
      ),
    );
  }
}
