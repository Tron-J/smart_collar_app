import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/features/onboarding/providers/onboarding_provider.dart';
import 'package:smart_collar_app/shared/widgets/julius_scaffold.dart';
import 'package:smart_collar_app/shared/widgets/teal_button.dart';

class PairCollarScreen extends ConsumerStatefulWidget {
  const PairCollarScreen({super.key});

  @override
  ConsumerState<PairCollarScreen> createState() => _PairCollarScreenState();
}

class _PairCollarScreenState extends ConsumerState<PairCollarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _deviceIdController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _deviceIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingControllerProvider);
    final isLoading = onboardingState.isLoading;

    return JuliusScaffold(
      appBar: AppBar(
        backgroundColor: kBgDeep,
        elevation: 0,
        title: const Text('Pair collar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Pair a collar device',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                'Scan the QR code on the collar or enter the device ID.',
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
                  children: [
                    const Icon(Icons.qr_code_scanner, color: kAccentPrimary),
                    const SizedBox(height: 8),
                    Text(
                      'QR scanning will be enabled with camera access.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: kTextSecond),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deviceIdController,
                decoration: const InputDecoration(labelText: 'Device ID'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Device ID required'
                    : null,
              ),
              const SizedBox(height: 24),
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: kDanger),
                ),
                const SizedBox(height: 12),
              ],
              TealButton.filled(
                label: isLoading ? 'Pairing collar...' : 'Pair collar',
                onPressed: isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          setState(() => _errorMessage = null);
                          try {
                            await ref
                                .read(onboardingControllerProvider.notifier)
                                .pairCollar(_deviceIdController.text);
                            if (!context.mounted) return;
                            context.go('/wifi-config');
                          } catch (error) {
                            if (!mounted) return;
                            setState(() => _errorMessage = error.toString());
                          }
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
