import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/features/dashboard/presentation/widgets/activity_bar_widget.dart';
import 'package:smart_collar_app/features/dashboard/presentation/widgets/collar_status_bar.dart';
import 'package:smart_collar_app/features/dashboard/presentation/widgets/hr_chart_widget.dart';
import 'package:smart_collar_app/features/dashboard/presentation/widgets/ppr_risk_card.dart';
import 'package:smart_collar_app/features/dashboard/presentation/widgets/sensor_card.dart';
import 'package:smart_collar_app/features/dashboard/presentation/widgets/temp_chart_widget.dart';
import 'package:smart_collar_app/features/dashboard/providers/live_readings_provider.dart';
import 'package:smart_collar_app/features/dashboard/providers/websocket_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(websocketStreamProvider);
    final readingsState = ref.watch(liveReadingsProvider);
    final latest = readingsState.latest;
    final updatedLabel = readingsState.lastUpdated == null
        ? 'Waiting for data'
        : 'Updated just now';
    final accelDetail = latest == null
        ? 'X: --  Y: --  Z: --'
        : 'X: ${latest.accelX}  Y: ${latest.accelY}  Z: ${latest.accelZ}';

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
          _TopBar(
            onDashboard: () {},
            onSensors: () => context.go('/sensors'),
            onAlerts: () => context.go('/alerts'),
            onAbout: () => context.go('/about'),
          ),
          const SizedBox(height: 16),
          PprRiskCard(score: latest?.pprRiskScore),
          const SizedBox(height: 20),
          CollarStatusBar(isConnected: readingsState.isConnected),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sensor readings',
                style: Theme.of(context).textTheme.titleMedium,
              ),
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
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: kTextMuted),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SensorCard(
            title: 'Body Temperature',
            subtitle: 'DS18B20',
            value: latest?.tempC,
            unit: '°C',
            detail: 'Normal range 38.5–39.7°C',
            chart: const TempChartWidget(),
          ),
          const SizedBox(height: 12),
          SensorCard(
            title: 'Heart Rate',
            subtitle: 'MAX30102 PULSE SENSOR',
            value: latest?.heartRateBpm,
            unit: 'bpm',
            detail: 'Typical resting: 70–90 bpm',
            chart: const HrChartWidget(),
          ),
          const SizedBox(height: 12),
          SensorCard(
            title: 'Activity Level',
            subtitle: 'MPU6050 ACCELEROMETER',
            value: latest?.activityIndex,
            unit: '%',
            detail: 'Composite motion intensity',
            chart: const ActivityBarWidget(),
          ),
          const SizedBox(height: 12),
          SensorCard(
            title: 'Accelerometer Axes',
            subtitle: 'MPU6050 · M/S²',
            value: latest?.accelZ,
            unit: 'z-axis g',
            detail: accelDetail,
          ),
          const SizedBox(height: 12),
          SensorCard(
            title: 'Battery',
            subtitle: '3.7V LIPO · 1200MAH',
            value: latest?.batteryPct,
            unit: '%',
            detail: 'Deep-sleep enabled',
          ),
          const SizedBox(height: 12),
          SensorCard(
            title: 'Wi-Fi Signal',
            subtitle: 'ESP32 ONBOARD',
            value: latest?.wifiRssi,
            unit: '%',
            detail: 'Edge alerts work offline too',
          ),
        ],
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.onDashboard,
    required this.onSensors,
    required this.onAlerts,
    required this.onAbout,
  });

  final VoidCallback onDashboard;
  final VoidCallback onSensors;
  final VoidCallback onAlerts;
  final VoidCallback onAbout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: kAccentPrimary,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'J',
                  style: TextStyle(
                    color: kBgDeep,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Julius Collar',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'PPR Early Detection · ESP32',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: kTextSecond),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: [
            _NavChip(label: 'Dashboard', isActive: true, onTap: onDashboard),
            _NavChip(label: 'Sensors', isActive: false, onTap: onSensors),
            _NavChip(label: 'Alerts', isActive: false, onTap: onAlerts),
            _NavChip(label: 'About', isActive: false, onTap: onAbout),
          ],
        ),
      ],
    );
  }
}

class _NavChip extends StatelessWidget {
  const _NavChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
