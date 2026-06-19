import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/features/dashboard/providers/realtime_refresh_provider.dart';
import 'package:smart_collar_app/features/herd/providers/herd_provider.dart';
import 'package:smart_collar_app/shared/widgets/error_view.dart';
import 'package:smart_collar_app/shared/widgets/loading_shimmer.dart';
import 'package:smart_collar_app/shared/widgets/status_badge.dart';

class HerdScreen extends ConsumerStatefulWidget {
  const HerdScreen({super.key});

  @override
  ConsumerState<HerdScreen> createState() => _HerdScreenState();
}

class _HerdScreenState extends ConsumerState<HerdScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    ref.listen(realtimeRefreshTickProvider, (_, _) {
      invalidateRealtimeFarmData(ref);
    });
    final animalsValue = ref.watch(herdAnimalsProvider);

    return RefreshIndicator(
      color: kAccentPrimary,
      backgroundColor: kBgCard,
      onRefresh: () => refreshRealtimeFarmData(ref),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          Text('Herd', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 6),
          Text(
            'Search and manage animals by collar ID.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search collar ID or species',
            ),
            onChanged: (value) => setState(() => _query = value.toLowerCase()),
          ),
          const SizedBox(height: 16),
          animalsValue.when(
            loading: () => const LoadingShimmer(height: 220),
            error: (error, _) => ErrorView(
              message: error.toString(),
              onRetry: () => ref.invalidate(herdAnimalsProvider),
            ),
            data: (animals) {
              final filtered = animals.where((animal) {
                return animal.animalTag.toLowerCase().contains(_query) ||
                    animal.species.toLowerCase().contains(_query);
              }).toList();
              if (filtered.isEmpty) {
                return const _EmptyHerdState();
              }
              return Column(
                children: filtered
                    .map(
                      (animal) => _AnimalCard(
                        tag: animal.animalTag,
                        species: animal.species,
                        subtitle:
                            '${animal.sex} | ${animal.ageMonths ?? '--'} months | ${animal.weightKg ?? '--'} kg',
                        onTap: () => context.push('/herd/${animal.id}'),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AnimalCard extends StatelessWidget {
  const _AnimalCard({
    required this.tag,
    required this.species,
    required this.subtitle,
    required this.onTap,
  });

  final String tag;
  final String species;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kBgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kAccentSoft),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: kAccentSoft,
              child: Text(tag.characters.first.toUpperCase()),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tag, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: kTextSecond),
                  ),
                ],
              ),
            ),
            StatusBadge(label: species),
          ],
        ),
      ),
    );
  }
}

class _EmptyHerdState extends StatelessWidget {
  const _EmptyHerdState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kAccentSoft),
      ),
      child: Text(
        'No animals are registered for this farm yet.',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
      ),
    );
  }
}
