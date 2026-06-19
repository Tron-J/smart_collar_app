import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/features/dashboard/providers/realtime_refresh_provider.dart';
import 'package:smart_collar_app/features/history/providers/history_provider.dart';
import 'package:smart_collar_app/shared/widgets/error_view.dart';
import 'package:smart_collar_app/shared/widgets/loading_shimmer.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(realtimeRefreshTickProvider, (_, _) {
      invalidateRealtimeFarmData(ref);
    });
    final readingsValue = ref.watch(historyReadingsProvider);
    final range = ref.watch(historyRangeProvider);

    return RefreshIndicator(
      color: kAccentPrimary,
      backgroundColor: kBgCard,
      onRefresh: () => refreshRealtimeFarmData(ref),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          Text('History', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 6),
          Text(
            'Temperature, heart rate, activity, and risk trends from the backend.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: HistoryRange.values
                .map(
                  (item) => _RangeChip(
                    label: _rangeLabel(item),
                    isActive: item == range,
                    onTap: () =>
                        ref.read(historyRangeProvider.notifier).state = item,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          readingsValue.when(
            loading: () => const LoadingShimmer(height: 360),
            error: (error, _) => ErrorView(
              message: error.toString(),
              onRetry: () => ref.invalidate(historyReadingsProvider),
            ),
            data: (readings) {
              if (readings.isEmpty) {
                return const _EmptyHistoryState();
              }
              return Column(
                children: [
                  _ChartCard(
                    title: 'Temperature',
                    unit: 'C',
                    color: kAccentPrimary,
                    values: readings.map((item) => item.tempC).toList(),
                  ),
                  _ChartCard(
                    title: 'Heart Rate',
                    unit: 'bpm',
                    color: kDanger,
                    values: readings
                        .map((item) => item.heartRateBpm.toDouble())
                        .toList(),
                  ),
                  _ChartCard(
                    title: 'Activity',
                    unit: '%',
                    color: kWarning,
                    values: readings
                        .map((item) => item.activityIndex.toDouble())
                        .toList(),
                  ),
                  _ChartCard(
                    title: 'Risk Score',
                    unit: '/100',
                    color: kDanger,
                    values: readings
                        .map((item) => item.pprRiskScore.toDouble())
                        .toList(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String _rangeLabel(HistoryRange range) {
    return switch (range) {
      HistoryRange.sixHours => '6h',
      HistoryRange.twentyFourHours => '24h',
      HistoryRange.sevenDays => '7d',
      HistoryRange.thirtyDays => '30d',
    };
  }
}

class _RangeChip extends StatelessWidget {
  const _RangeChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? kAccentPrimary : kBgCard,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: kAccentSoft),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isActive ? kBgDeep : kTextSecond,
          ),
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.unit,
    required this.color,
    required this.values,
  });

  final String title;
  final String unit;
  final Color color;
  final List<double> values;

  @override
  Widget build(BuildContext context) {
    final spots = values
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                '${values.last.toStringAsFixed(1)} $unit',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    color: color,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withValues(alpha: 0.12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHistoryState extends StatelessWidget {
  const _EmptyHistoryState();

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
        'No readings are available for this range.',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
      ),
    );
  }
}
