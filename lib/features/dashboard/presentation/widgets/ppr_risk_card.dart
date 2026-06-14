import 'package:flutter/material.dart';
import 'package:smart_collar_app/core/constants/colors.dart';

class PprRiskCard extends StatelessWidget {
  const PprRiskCard({super.key, required this.score});

  final int? score;

  @override
  Widget build(BuildContext context) {
    final status = _statusFromScore(score);
    final statusColor = _colorFromScore(score);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kAccentSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'LIVE MONITORING',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: kTextMuted,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status: $status',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      score == null ? '--' : score.toString(),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Risk score out of 100',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: kTextMuted),
                    ),
                  ],
                ),
              ),
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  status == 'Healthy'
                      ? Icons.verified
                      : status == 'Warning'
                      ? Icons.warning_amber_rounded
                      : Icons.warning_rounded,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Health risk estimate based on body temperature, pulse, and movement patterns.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: kTextSecond),
          ),
          if (score == null) ...[
            const SizedBox(height: 10),
            Text(
              'Waiting for the collar to stream live data.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: kTextMuted),
            ),
          ],
        ],
      ),
    );
  }

  String _statusFromScore(int? score) {
    if (score == null) return 'No data';
    if (score <= 30) return 'Healthy';
    if (score <= 59) return 'Warning';
    if (score <= 79) return 'At Risk';
    return 'Critical';
  }

  Color _colorFromScore(int? score) {
    if (score == null) return kTextMuted;
    if (score <= 30) return kHealthy;
    if (score <= 59) return kWarning;
    return kDanger;
  }
}
