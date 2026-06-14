import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/core/providers/app_services.dart';
import 'package:smart_collar_app/features/auth/providers/auth_provider.dart';
import 'package:smart_collar_app/features/onboarding/providers/onboarding_provider.dart';
import 'package:smart_collar_app/shared/widgets/smart_collar_scaffold.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _routeFromSplash();
  }

  Future<void> _routeFromSplash() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    try {
      final hasToken = await ref
          .read(authControllerProvider.notifier)
          .hasStoredToken()
          .timeout(const Duration(seconds: 3), onTimeout: () => false);
      if (!mounted) return;

      if (!hasToken) {
        context.go('/welcome');
        return;
      }

      final farmId = await ref
          .read(secureStorageProvider)
          .readCurrentFarmId()
          .timeout(const Duration(seconds: 2), onTimeout: () => null);
      if (!mounted) return;

      if (farmId != null) {
        context.go('/dashboard');
        return;
      }

      final farm = await ref
          .read(completedFarmProvider.future)
          .timeout(const Duration(seconds: 5), onTimeout: () => null);
      if (!mounted) return;
      context.go(farm == null ? '/farm-setup' : '/dashboard');
    } catch (_) {
      if (!mounted) return;
      context.go('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartCollarScaffold(
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
                  'S',
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
              'Smart Collar',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              'Intelligent PPR Early Detection',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
            ),
            const SizedBox(height: 24),
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.2),
            ),
          ],
        ),
      ),
    );
  }
}
