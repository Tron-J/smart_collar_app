import 'package:flutter/material.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/core/constants/typography.dart';

class SensorRowCard extends StatefulWidget {
  const SensorRowCard({
    super.key,
    required this.name,
    required this.source,
    this.value,
    this.unit,
    this.valueText,
  });

  final String name;
  final String source;
  final num? value;
  final String? unit;
  final String? valueText;

  @override
  State<SensorRowCard> createState() => _SensorRowCardState();
}

class _SensorRowCardState extends State<SensorRowCard>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final display = widget.valueText ??
        (widget.value == null
            ? '--'
            : '${widget.value} ${widget.unit ?? ''}'.trim());

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kAccentSoft),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: kAccentPrimary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.sensors, color: kBgDeep, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: kAccentPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.source,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: kTextMuted),
                ),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: Tween(begin: 1.0, end: 1.08).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: Text(
              display,
              key: ValueKey(display),
              style: monoTextStyle(
                Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: kAccentPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
