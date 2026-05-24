import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/shared/widgets/julius_scaffold.dart';
import 'package:smart_collar_app/shared/widgets/teal_button.dart';

class AddAnimalScreen extends StatefulWidget {
  const AddAnimalScreen({super.key});

  @override
  State<AddAnimalScreen> createState() => _AddAnimalScreenState();
}

class _AddAnimalScreenState extends State<AddAnimalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tagController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  String _species = 'sheep';
  String _sex = 'female';

  @override
  void dispose() {
    _tagController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return JuliusScaffold(
      appBar: AppBar(
        backgroundColor: kBgDeep,
        elevation: 0,
        title: const Text('Add animal'),
      ),
      body: Padding(
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
                'Add the animal tag and basic details for monitoring.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: kTextSecond),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _tagController,
                decoration: const InputDecoration(labelText: 'Animal tag ID'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Animal tag required'
                    : null,
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 24),
              TealButton.filled(
                label: 'Continue to collar pairing',
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    context.go('/pair-collar');
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
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: kTextSecond),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: options
              .map((option) => _SegmentButton(
                    label: option.toUpperCase(),
                    value: option,
                    groupValue: value,
                    onChanged: onChanged,
                  ))
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
