import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/shared/widgets/julius_scaffold.dart';
import 'package:smart_collar_app/shared/widgets/teal_button.dart';

class SetupCompleteScreen extends StatelessWidget {
  const SetupCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return JuliusScaffold(
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
              'Setup complete',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              'Your collar is ready to stream data once it is online.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
            ),
            const SizedBox(height: 24),
            _SummaryRow(label: 'Farm', value: 'Not set'),
            _SummaryRow(label: 'Animal tag', value: 'Not set'),
            _SummaryRow(label: 'Collar ID', value: 'Not set'),
            _SummaryRow(label: 'Connection', value: 'Pending'),
            const Spacer(),
            TealButton.filled(
              label: 'Go to Dashboard',
              onPressed: () => context.go('/dashboard'),
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
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
