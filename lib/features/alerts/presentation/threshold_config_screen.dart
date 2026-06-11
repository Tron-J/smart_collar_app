import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/features/alerts/data/models/alert_threshold.dart';
import 'package:smart_collar_app/features/alerts/providers/alerts_provider.dart';
import 'package:smart_collar_app/shared/widgets/error_view.dart';
import 'package:smart_collar_app/shared/widgets/loading_shimmer.dart';
import 'package:smart_collar_app/shared/widgets/teal_button.dart';

class ThresholdConfigScreen extends ConsumerStatefulWidget {
  const ThresholdConfigScreen({super.key});

  @override
  ConsumerState<ThresholdConfigScreen> createState() =>
      _ThresholdConfigScreenState();
}

class _ThresholdConfigScreenState extends ConsumerState<ThresholdConfigScreen> {
  AlertThreshold? _draft;

  @override
  Widget build(BuildContext context) {
    final thresholdValue = ref.watch(thresholdProvider);
    final saveState = ref.watch(thresholdControllerProvider);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Thresholds', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 6),
        Text(
          'Per-farm alert thresholds synced with the backend.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
        ),
        const SizedBox(height: 20),
        thresholdValue.when(
          loading: () => const LoadingShimmer(height: 320),
          error: (error, _) => ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(thresholdProvider),
          ),
          data: (threshold) {
            if (threshold == null) {
              return const _EmptyThresholdState();
            }
            _draft ??= threshold;
            final draft = _draft!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SliderTile(
                  label: 'Temperature high (C)',
                  value: draft.tempHighC,
                  min: 38,
                  max: 42,
                  divisions: 40,
                  onChanged: (value) =>
                      setState(() => _draft = draft.copyWith(tempHighC: value)),
                ),
                _SliderTile(
                  label: 'Temperature low (C)',
                  value: draft.tempLowC,
                  min: 34,
                  max: 39,
                  divisions: 50,
                  onChanged: (value) =>
                      setState(() => _draft = draft.copyWith(tempLowC: value)),
                ),
                _SliderTile(
                  label: 'Heart rate high (bpm)',
                  value: draft.hrHighBpm.toDouble(),
                  min: 80,
                  max: 160,
                  divisions: 80,
                  onChanged: (value) => setState(
                    () => _draft = draft.copyWith(hrHighBpm: value.round()),
                  ),
                ),
                _SliderTile(
                  label: 'Heart rate low (bpm)',
                  value: draft.hrLowBpm.toDouble(),
                  min: 30,
                  max: 80,
                  divisions: 50,
                  onChanged: (value) => setState(
                    () => _draft = draft.copyWith(hrLowBpm: value.round()),
                  ),
                ),
                _SliderTile(
                  label: 'Activity low (%)',
                  value: draft.activityLowPct.toDouble(),
                  min: 0,
                  max: 40,
                  divisions: 40,
                  onChanged: (value) => setState(
                    () =>
                        _draft = draft.copyWith(activityLowPct: value.round()),
                  ),
                ),
                _SliderTile(
                  label: 'PPR risk threshold',
                  value: draft.pprRiskThreshold.toDouble(),
                  min: 30,
                  max: 90,
                  divisions: 60,
                  onChanged: (value) => setState(
                    () => _draft = draft.copyWith(
                      pprRiskThreshold: value.round(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TealButton.filled(
                  label: saveState.isLoading ? 'Saving...' : 'Save thresholds',
                  onPressed: saveState.isLoading
                      ? null
                      : () async {
                          await ref
                              .read(thresholdControllerProvider.notifier)
                              .save(_draft!);
                        },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              Expanded(child: Text(label)),
              Text(
                value.toStringAsFixed(
                  value.truncateToDouble() == value ? 0 : 1,
                ),
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: kAccentPrimary),
              ),
            ],
          ),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            activeColor: kAccentPrimary,
            inactiveColor: kAccentSoft,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _EmptyThresholdState extends StatelessWidget {
  const _EmptyThresholdState();

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
        'No threshold record exists for this farm yet.',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
      ),
    );
  }
}
