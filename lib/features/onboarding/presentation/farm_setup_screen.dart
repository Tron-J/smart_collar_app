import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/features/onboarding/providers/onboarding_provider.dart';
import 'package:smart_collar_app/shared/widgets/app_loading_overlay.dart';
import 'package:smart_collar_app/shared/widgets/smart_collar_scaffold.dart';
import 'package:smart_collar_app/shared/widgets/primary_button.dart';

class FarmSetupScreen extends ConsumerStatefulWidget {
  const FarmSetupScreen({super.key});

  @override
  ConsumerState<FarmSetupScreen> createState() => _FarmSetupScreenState();
}

class _FarmSetupScreenState extends ConsumerState<FarmSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  String _farmType = 'sheep';
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
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
        title: const Text('Farm setup'),
      ),
      body: AppLoadingOverlay(
        isLoading: isLoading,
        message: 'Saving your farm...',
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Text(
                  'Tell us about your farm',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 6),
                Text(
                  'Your farm profile helps configure alerts and reporting.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Farm name'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Farm name required'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                const SizedBox(height: 16),
                Text(
                  'Farm type',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _SegmentButton(
                      label: 'Sheep',
                      value: 'sheep',
                      groupValue: _farmType,
                      onChanged: (value) => setState(() => _farmType = value),
                    ),
                    _SegmentButton(
                      label: 'Goat',
                      value: 'goat',
                      groupValue: _farmType,
                      onChanged: (value) => setState(() => _farmType = value),
                    ),
                    _SegmentButton(
                      label: 'Mixed',
                      value: 'mixed',
                      groupValue: _farmType,
                      onChanged: (value) => setState(() => _farmType = value),
                    ),
                  ],
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
                  label: isLoading ? 'Saving farm...' : 'Continue',
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() => _errorMessage = null);
                            try {
                              await ref
                                  .read(onboardingControllerProvider.notifier)
                                  .createFarm(
                                    name: _nameController.text,
                                    location: _locationController.text,
                                    farmType: _farmType,
                                  );
                              if (!context.mounted) return;
                              context.go('/dashboard');
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

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? kAccentPrimary : kBgCardLight,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: kAccentSoft),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isSelected ? kBgDeep : kTextSecond,
          ),
        ),
      ),
    );
  }
}
