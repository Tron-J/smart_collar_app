import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/features/onboarding/providers/onboarding_provider.dart';
import 'package:smart_collar_app/shared/widgets/primary_button.dart';
import 'package:smart_collar_app/shared/widgets/smart_collar_scaffold.dart';

class SetupCompleteScreen extends ConsumerWidget {
  const SetupCompleteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider).valueOrNull;

    return SmartCollarScaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 48),
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: kAccentPrimary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: kBgDeep, size: 32),
            ),
            const SizedBox(height: 24),
            Text(
              'Collar setup complete',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              'This animal and collar are registered under your current farm. You can add more collars for more animals from the same farm.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
            ),
            const SizedBox(height: 24),
            _SummaryRow(
              label: 'Farm',
              value: state?.farm?.name ?? 'Current farm',
            ),
            _SummaryRow(
              label: 'Collar ID',
              value: state?.collar?.deviceId ?? 'Paired collar',
            ),
            _SummaryRow(label: 'Connection', value: 'Ready for live data'),
            const Spacer(),
            PrimaryButton.filled(
              label: 'Add another animal and collar',
              onPressed: () => context.push('/add-animal'),
            ),
            const SizedBox(height: 12),
            PrimaryButton.outlined(
              label: 'View all collars',
              onPressed: () => context.go('/collars'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go('/dashboard'),
              child: const Text('Go to farm dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
