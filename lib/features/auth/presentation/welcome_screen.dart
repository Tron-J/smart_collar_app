import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/shared/widgets/julius_scaffold.dart';
import 'package:smart_collar_app/shared/widgets/teal_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return JuliusScaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: kAccentPrimary,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'J',
                  style: TextStyle(
                    color: kBgDeep,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Intelligent PPR Early Detection\nfor your herd',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Monitor body temperature, heart rate, and motion in real time.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: kTextSecond),
            ),
            const Spacer(),
            TealButton.filled(
              label: 'Create account',
              onPressed: () => context.go('/register'),
            ),
            const SizedBox(height: 12),
            TealButton.outlined(
              label: 'Sign in',
              onPressed: () => context.go('/login'),
            ),
          ],
        ),
      ),
    );
  }
}
