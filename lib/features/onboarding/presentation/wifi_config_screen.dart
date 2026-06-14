import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/shared/widgets/smart_collar_scaffold.dart';
import 'package:smart_collar_app/shared/widgets/status_badge.dart';
import 'package:smart_collar_app/shared/widgets/primary_button.dart';

class WifiConfigScreen extends StatelessWidget {
  const WifiConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SmartCollarScaffold(
      appBar: AppBar(
        backgroundColor: kBgDeep,
        elevation: 0,
        title: const Text('Wi-Fi configuration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Text(
              'Connect the collar to Wi-Fi',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              'Enable Bluetooth and connect to the collar to send Wi-Fi details.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: kBgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kAccentSoft),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Connection status',
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: kTextSecond),
                  ),
                  const SizedBox(height: 8),
                  const StatusBadge(label: 'Searching'),
                  const SizedBox(height: 12),
                  Text(
                    'We will show nearby Smart Collar devices here.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: kTextMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton.filled(
              label: 'Continue',
              onPressed: () => context.go('/setup-complete'),
            ),
          ],
        ),
      ),
    );
  }
}
