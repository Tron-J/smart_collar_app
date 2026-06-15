import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/features/onboarding/providers/onboarding_provider.dart';
import 'package:smart_collar_app/shared/widgets/app_loading_overlay.dart';
import 'package:smart_collar_app/shared/widgets/smart_collar_scaffold.dart';
import 'package:smart_collar_app/shared/widgets/primary_button.dart';

class AddAnimalScreen extends ConsumerStatefulWidget {
  const AddAnimalScreen({super.key, this.initialDeviceId});

  final String? initialDeviceId;

  @override
  ConsumerState<AddAnimalScreen> createState() => _AddAnimalScreenState();
}

class _AddAnimalScreenState extends ConsumerState<AddAnimalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _deviceIdController = TextEditingController();
  String _species = 'sheep';
  String _sex = 'female';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final initialDeviceId = widget.initialDeviceId?.trim();
    if (initialDeviceId != null && initialDeviceId.isNotEmpty) {
      _deviceIdController.text = initialDeviceId;
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
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
        title: const Text('Add animal'),
      ),
      body: AppLoadingOverlay(
        isLoading: isLoading,
        message: 'Adding animal profile...',
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Text(
                  'Register an animal',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 6),
                Text(
                  'Use the collar ID to identify this animal and connect its live readings.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
                ),
                const SizedBox(height: 24),
                _SegmentedRow(
                  label: 'Species',
                  value: _species,
                  options: const ['sheep', 'goat'],
                  onChanged: (value) => setState(() => _species = value),
                ),
                const SizedBox(height: 16),
                _SegmentedRow(
                  label: 'Sex',
                  value: _sex,
                  options: const ['female', 'male'],
                  onChanged: (value) => setState(() => _sex = value),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Age (months)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _deviceIdController,
                  decoration: const InputDecoration(labelText: 'Collar ID'),
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Collar ID required'
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
                  label: isLoading
                      ? 'Registering animal...'
                      : 'Register animal and collar',
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() => _errorMessage = null);
                            try {
                              await ref
                                  .read(onboardingControllerProvider.notifier)
                                  .createAnimalWithCollar(
                                    species: _species,
                                    sex: _sex,
                                    ageMonths: int.tryParse(
                                      _ageController.text,
                                    ),
                                    weightKg: double.tryParse(
                                      _weightController.text,
                                    ),
                                    deviceId: _deviceIdController.text,
                                  );
                              if (!context.mounted) return;
                              context.go('/setup-complete');
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

class _SegmentedRow extends StatelessWidget {
  const _SegmentedRow({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: options
              .map(
                (option) => _SegmentButton(
                  label: option.toUpperCase(),
                  value: option,
                  groupValue: value,
                  onChanged: onChanged,
                ),
              )
              .toList(),
        ),
      ],
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
