import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/features/onboarding/providers/onboarding_provider.dart';
import 'package:smart_collar_app/shared/widgets/app_loading_overlay.dart';
import 'package:smart_collar_app/shared/widgets/smart_collar_scaffold.dart';
import 'package:smart_collar_app/shared/widgets/primary_button.dart';

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

    return SmartCollarScaffold(
      appBar: AppBar(
        backgroundColor: kBgDeep,
        elevation: 0,
        title: const Text('Pair collar'),
      ),
      body: AppLoadingOverlay(
        isLoading: isLoading,
        message: 'Pairing collar...',
        child: Padding(
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
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kBgCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kAccentSoft),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Connection guide',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 10),
                      _GuideLine(
                        text:
                            'Power on the collar and keep it close to your phone.',
                      ),
                      _GuideLine(
                        text:
                            'Use the same Device ID printed on the collar or given during setup.',
                      ),
                      _GuideLine(
                        text:
                            'After pairing, connect the collar to Wi-Fi and keep it within network range.',
                      ),
                      _GuideLine(
                        text:
                            'Return to Collars to confirm Online status and live readings.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
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
                PrimaryButton.filled(
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
      ),
    );
  }
}

class _GuideLine extends StatelessWidget {
  const _GuideLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: kAccentPrimary, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: kTextSecond, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
