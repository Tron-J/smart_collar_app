import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/features/dashboard/data/models/sensor_reading.dart';

class TempChartWidget extends StatelessWidget {
  const TempChartWidget({super.key, required this.readings});

  final List<SensorReading> readings;

  @override
  Widget build(BuildContext context) {
    final values = readings.map((reading) => reading.tempC).toList();
    if (values.length < 2) {
      return const _EmptyTempChart();
    }

    return Container(
      height: 76,
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 4),
      decoration: BoxDecoration(
        color: kBgCardLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: LineChart(
        LineChartData(
          minY: 35,
          maxY: 42,
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: values
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                  .toList(),
              color: kAccentSecond,
              barWidth: 2.2,
              isCurved: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: kAccentSecond.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyTempChart extends StatelessWidget {
  const _EmptyTempChart();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: kBgCardLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          'Temperature trend appears after live readings',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: kTextMuted),
        ),
      ),
    );
  }
}
