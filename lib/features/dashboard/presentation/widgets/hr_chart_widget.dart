import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/features/dashboard/data/models/sensor_reading.dart';

class HrChartWidget extends StatelessWidget {
  const HrChartWidget({super.key, required this.readings});

  final List<SensorReading> readings;

  @override
  Widget build(BuildContext context) {
    final values = readings
        .map((reading) => reading.heartRateBpm.toDouble())
        .where((value) => value > 0)
        .toList();

    if (values.length < 2) {
      return const _EmptyPulseChart();
    }

    return Container(
      height: 86,
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 4),
      decoration: BoxDecoration(
        color: kBgCardLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: LineChart(
        LineChartData(
          minY: 40,
          maxY: 150,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 30,
            getDrawingHorizontalLine: (_) =>
                const FlLine(color: kAccentSoft, strokeWidth: 0.6),
          ),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: true),
          lineBarsData: [
            LineChartBarData(
              spots: values
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                  .toList(),
              color: kAccentPrimary,
              barWidth: 2.4,
              isCurved: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: kAccentPrimary.withValues(alpha: 0.14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyPulseChart extends StatelessWidget {
  const _EmptyPulseChart();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      decoration: BoxDecoration(
        color: kBgCardLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          'Pulse chart appears after live readings',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: kTextMuted),
        ),
      ),
    );
  }
}
