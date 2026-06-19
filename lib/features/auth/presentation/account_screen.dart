import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/core/providers/app_services.dart';
import 'package:smart_collar_app/features/auth/providers/auth_provider.dart';
import 'package:smart_collar_app/features/onboarding/providers/onboarding_provider.dart';
import 'package:smart_collar_app/shared/widgets/app_loading_overlay.dart';
import 'package:smart_collar_app/shared/widgets/smart_collar_scaffold.dart';
import 'package:smart_collar_app/shared/widgets/primary_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  String? _errorMessage;
  bool _isRouting = false;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    try {
      _authSubscription = Supabase.instance.client.auth.onAuthStateChange
          .listen((event) {
            if (!mounted) return;
            if (event.session != null) {
              _goToNextStep();
            }
          });
    } catch (_) {}
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading || _isRouting;

    return SmartCollarScaffold(
      body: AppLoadingOverlay(
        isLoading: isLoading,
        message: authState.isLoading
            ? 'Opening Google account selector...'
            : 'Checking your farm setup...',
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Center(
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: const BoxDecoration(
                      color: kAccentPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'S',
                        style: TextStyle(
                          color: kBgDeep,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Create your farm account',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Use Google to securely access your herd dashboard and collar telemetry.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                if (_errorMessage != null) ...[
                  Text(
                    _errorMessage!,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: kDanger),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                ],
                PrimaryButton.filled(
                  label: isLoading
                      ? 'Opening Google...'
                      : 'Continue with Google',
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() => _errorMessage = null);
                          try {
                            await ref
                                .read(authControllerProvider.notifier)
                                .continueWithGoogle();
                            if (!context.mounted) return;
                            await _goToNextStep();
                          } catch (error) {
                            if (!mounted) return;
                            setState(() => _errorMessage = error.toString());
                          }
                        },
                ),
                const SizedBox(height: 14),
                Text(
                  'Authentication is handled by Supabase.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: kTextMuted),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _goToNextStep() async {
    if (_isRouting) return;
    setState(() {
      _isRouting = true;
      _errorMessage = null;
    });

    try {
      final farmId = await ref.read(secureStorageProvider).readCurrentFarmId();
      if (!mounted) return;
      if (farmId != null) {
        context.go('/dashboard');
        return;
      }

      ref.invalidate(userFarmsProvider);
      ref.invalidate(completedFarmProvider);
      final farm = await ref.read(completedFarmProvider.future);
      if (!mounted) return;
      context.go(farm == null ? '/farm-setup' : '/dashboard');
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = error.toString());
    } finally {
      if (mounted) {
        setState(() => _isRouting = false);
      }
    }
  }
}
