import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/features/dashboard/providers/live_readings_provider.dart';
import 'package:smart_collar_app/features/dashboard/providers/websocket_provider.dart';
import 'package:smart_collar_app/features/sensors/presentation/widgets/sensor_row_card.dart';

class SensorsScreen extends ConsumerWidget {
  const SensorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(websocketStreamProvider);
    final readingsState = ref.watch(liveReadingsProvider);
    final latest = readingsState.latest;
    final updatedLabel = readingsState.lastUpdated == null
        ? 'Waiting for data'
        : 'Updated just now';

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Sensors', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 6),
        Text(
          'Live data streamed from the ESP32 collar at 1.5s intervals.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: kTextMuted,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              updatedLabel,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: kTextMuted),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SensorRowCard(
          name: 'Body Temperature',
          source: 'DS18B20 1-WIRE',
          value: latest?.tempC,
          unit: '°C',
        ),
        const SizedBox(height: 12),
        SensorRowCard(
          name: 'Heart Rate',
          source: 'MAX30102 PULSE',
          value: latest?.heartRateBpm,
          unit: 'beats/min',
        ),
        const SizedBox(height: 12),
        SensorRowCard(
          name: 'Activity Index',
          source: 'MPU6050 DERIVED',
          value: latest?.activityIndex,
          unit: '%',
        ),
        const SizedBox(height: 12),
        SensorRowCard(
          name: 'Accelerometer X',
          source: 'MPU6050',
          value: latest?.accelX,
          unit: 'm/s²',
        ),
        const SizedBox(height: 12),
        SensorRowCard(
          name: 'Accelerometer Y',
          source: 'MPU6050',
          value: latest?.accelY,
          unit: 'm/s²',
        ),
        const SizedBox(height: 12),
        SensorRowCard(
          name: 'Accelerometer Z',
          source: 'MPU6050',
          value: latest?.accelZ,
          unit: 'm/s²',
        ),
        const SizedBox(height: 12),
        SensorRowCard(
          name: 'MCU Temperature',
          source: 'ESP32 INTERNAL',
          value: latest?.mcuTempC,
          unit: '°C',
        ),
        const SizedBox(height: 12),
        SensorRowCard(
          name: 'Risk Score',
          source: 'EDGE INFERENCE',
          valueText: latest == null
              ? 'No data'
              : latest.pprRiskScore <= 30
              ? 'Healthy'
              : latest.pprRiskScore <= 59
              ? 'Warning'
              : latest.pprRiskScore <= 79
              ? 'At Risk'
              : 'Critical',
        ),
      ],
    );
  }
}
