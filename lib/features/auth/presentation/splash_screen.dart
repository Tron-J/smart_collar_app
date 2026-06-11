import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/features/auth/providers/auth_provider.dart';
import 'package:smart_collar_app/shared/widgets/julius_scaffold.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 900), () async {
      if (!mounted) return;
      final hasToken = await ref
          .read(authControllerProvider.notifier)
          .hasStoredToken();
      if (!mounted) return;
      context.go(hasToken ? '/dashboard' : '/welcome');
    });
  }

  @override
  Widget build(BuildContext context) {
    return JuliusScaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            const SizedBox(height: 16),
            Text(
              'Julius Collar',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              'Intelligent PPR Early Detection',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
            ),
          ],
        ),
      ),
    );
  }
}
