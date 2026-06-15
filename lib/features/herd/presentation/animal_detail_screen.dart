import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/features/herd/providers/herd_provider.dart';
import 'package:smart_collar_app/shared/widgets/error_view.dart';
import 'package:smart_collar_app/shared/widgets/loading_shimmer.dart';
import 'package:smart_collar_app/shared/widgets/status_badge.dart';

class AnimalDetailScreen extends ConsumerWidget {
  const AnimalDetailScreen({super.key, required this.animalId});

  final String animalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animalValue = ref.watch(animalDetailProvider(animalId));

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Collar animal detail',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        animalValue.when(
          loading: () => const LoadingShimmer(height: 240),
          error: (error, _) => ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(animalDetailProvider(animalId)),
          ),
          data: (animal) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kBgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kAccentSoft),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: kAccentPrimary,
                      child: Text(
                        animal.animalTag.characters.first.toUpperCase(),
                        style: const TextStyle(color: kBgDeep),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        animal.animalTag,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    StatusBadge(label: animal.species),
                  ],
                ),
                const SizedBox(height: 16),
                _Line(label: 'Sex', value: animal.sex),
                _Line(
                  label: 'Age',
                  value: '${animal.ageMonths ?? '--'} months',
                ),
                _Line(label: 'Weight', value: '${animal.weightKg ?? '--'} kg'),
                if (animal.notes != null)
                  _Line(label: 'Notes', value: animal.notes!),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: kTextMuted),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
