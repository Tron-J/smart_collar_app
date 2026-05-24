import 'package:flutter/material.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/core/constants/typography.dart';

class SensorCard extends StatelessWidget {
  const SensorCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.unit,
    required this.detail,
    this.chart,
  });

  final String title;
  final String subtitle;
  final num? value;
  final String unit;
  final String detail;
  final Widget? chart;

  @override
  Widget build(BuildContext context) {
    final valueText = value == null ? '--' : value!.toString();

    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: kTextMuted),
                  ),
                ],
              ),
              Text(
                '$valueText $unit',
                style: monoTextStyle(
                  Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: kAccentPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            detail,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: kTextSecond),
          ),
          if (chart != null) ...[
            const SizedBox(height: 12),
            chart!,
          ],
        ],
      ),
    );
  }
}
