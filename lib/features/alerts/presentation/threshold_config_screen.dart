import 'package:flutter/material.dart';
import 'package:smart_collar_app/core/constants/colors.dart';

class ThresholdConfigScreen extends StatelessWidget {
  const ThresholdConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Thresholds',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 6),
        Text(
          'Threshold sliders will appear once farm data is synced.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: kTextSecond),
        ),
        const SizedBox(height: 20),
        _SliderTile(label: 'Temperature high (°C)', valueLabel: '--'),
        _SliderTile(label: 'Temperature low (°C)', valueLabel: '--'),
        _SliderTile(label: 'Heart rate high (bpm)', valueLabel: '--'),
        _SliderTile(label: 'Heart rate low (bpm)', valueLabel: '--'),
        _SliderTile(label: 'Activity low (%)', valueLabel: '--'),
        _SliderTile(label: 'PPR risk threshold', valueLabel: '--'),
      ],
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({required this.label, required this.valueLabel});

  final String label;
  final String valueLabel;

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
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Text(
                valueLabel,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: kTextSecond),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: kBgCardLight,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ],
      ),
    );
  }
}
