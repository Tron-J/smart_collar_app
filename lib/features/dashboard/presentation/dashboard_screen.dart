import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/features/dashboard/data/models/sensor_reading.dart';
import 'package:smart_collar_app/features/dashboard/domain/animal_state.dart';
import 'package:smart_collar_app/features/dashboard/presentation/widgets/activity_bar_widget.dart';
import 'package:smart_collar_app/features/dashboard/presentation/widgets/hr_chart_widget.dart';
import 'package:smart_collar_app/features/dashboard/presentation/widgets/ppr_risk_card.dart';
import 'package:smart_collar_app/features/dashboard/presentation/widgets/sensor_card.dart';
import 'package:smart_collar_app/features/dashboard/presentation/widgets/temp_chart_widget.dart';
import 'package:smart_collar_app/features/dashboard/providers/live_readings_provider.dart';
import 'package:smart_collar_app/features/dashboard/providers/realtime_refresh_provider.dart';
import 'package:smart_collar_app/features/dashboard/providers/websocket_provider.dart';
import 'package:smart_collar_app/features/herd/providers/herd_provider.dart';
import 'package:smart_collar_app/features/onboarding/data/models/collar.dart';
import 'package:smart_collar_app/core/providers/session_provider.dart';
import 'package:smart_collar_app/shared/widgets/error_view.dart';
import 'package:smart_collar_app/shared/widgets/loading_shimmer.dart';
import 'package:smart_collar_app/shared/widgets/primary_button.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmValue = ref.watch(currentFarmIdProvider);
    final collarsValue = ref.watch(farmCollarsProvider);

    return farmValue.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(20),
        child: LoadingShimmer(height: 220),
      ),
      error: (error, _) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(currentFarmIdProvider),
          ),
        ],
      ),
      data: (farmId) {
        if (farmId == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) context.go('/farm-setup');
          });
          return const SizedBox.shrink();
        }
        return _DashboardContent(collarsValue: collarsValue);
      },
    );
  }
}

class _DashboardContent extends ConsumerWidget {
  const _DashboardContent({required this.collarsValue});

  final AsyncValue<List<Collar>> collarsValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(realtimeRefreshTickProvider, (_, _) {
      invalidateRealtimeFarmData(ref);
    });
    ref.watch(websocketStreamProvider);
    ref.watch(farmLatestReadingsProvider);
    final readingsState = ref.watch(liveReadingsProvider);
    final collarReadings = readingsState.latestByCollar.values.toList();
    final averagePulse = _averageInt(collarReadings.map((r) => r.heartRateBpm));
    final averageTemp = _averageDouble(collarReadings.map((r) => r.tempC));
    final averageActivity = _averageInt(
      collarReadings.map((r) => r.activityIndex),
    );
    final averageRisk = _averageInt(collarReadings.map((r) => r.pprRiskScore));
    final averageBattery = _averageInt(collarReadings.map((r) => r.batteryPct));
    final averageWifi = _averageInt(collarReadings.map((r) => r.wifiRssi));
    final updatedLabel = readingsState.lastUpdated == null
        ? 'Waiting for data'
        : 'Live now';

    return RefreshIndicator(
      color: kAccentPrimary,
      backgroundColor: kBgCard,
      onRefresh: () => refreshRealtimeFarmData(ref),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          _DashboardHeader(
            isConnected: readingsState.isConnected,
            batteryPct: averageBattery,
            wifiRssi: averageWifi,
            updatedLabel: updatedLabel,
            collarCount: readingsState.latestByCollar.length,
          ),
          const SizedBox(height: 16),
          collarsValue.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (collars) => collars.isEmpty
                ? const _ConnectCollarGuideCard()
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),
          _FarmSummaryCard(readings: collarReadings),
          const SizedBox(height: 16),
          PprRiskCard(score: averageRisk),
          const SizedBox(height: 20),
          Text(
            'Farm cumulative readings',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          SensorCard(
            title: 'Average Pulse',
            subtitle: 'Farm average',
            value: averagePulse,
            unit: 'bpm',
            detail: 'Average pulse from animals with active collars',
            chart: HrChartWidget(readings: readingsState.recent),
          ),
          const SizedBox(height: 12),
          SensorCard(
            title: 'Average Body Temperature',
            subtitle: 'Farm average',
            value: averageTemp,
            unit: 'C',
            detail: 'Average body temperature from active collars',
            chart: TempChartWidget(readings: readingsState.recent),
          ),
          const SizedBox(height: 12),
          SensorCard(
            title: 'Average Movement',
            subtitle: 'Behavior signal',
            value: averageActivity,
            unit: '%',
            detail: 'Used to estimate grazing, sleeping, and resting',
            chart: const ActivityBarWidget(),
          ),
        ],
      ),
    );
  }

  int? _averageInt(Iterable<int> values) {
    final list = values.toList();
    if (list.isEmpty) return null;
    return (list.reduce((a, b) => a + b) / list.length).round();
  }

  double? _averageDouble(Iterable<double> values) {
    final list = values.toList();
    if (list.isEmpty) return null;
    return list.reduce((a, b) => a + b) / list.length;
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({
    required this.isConnected,
    required this.batteryPct,
    required this.wifiRssi,
    required this.updatedLabel,
    required this.collarCount,
  });

  final bool isConnected;
  final int? batteryPct;
  final int? wifiRssi;
  final String updatedLabel;
  final int collarCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: kAccentPrimary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.memory_rounded, color: kTextPrimary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Smart Collar',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 2),
              Text(
                '$updatedLabel | $collarCount active collars',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: kTextSecond),
              ),
            ],
          ),
        ),
        _StatusPill(
          icon: isConnected ? Icons.wifi_rounded : Icons.wifi_off_rounded,
          label: isConnected ? _wifiLabel(wifiRssi) : 'Offline',
          color: isConnected ? kAccentPrimary : kTextMuted,
        ),
        const SizedBox(width: 8),
        _StatusPill(
          icon: Icons.battery_5_bar_rounded,
          label: batteryPct == null ? '--%' : '$batteryPct%',
          color: kAccentPrimary,
        ),
      ],
    );
  }

  String _wifiLabel(int? rssi) {
    if (rssi == null) return 'Online';
    return '$rssi%';
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: kAccentSoft),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: kTextPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FarmSummaryCard extends StatelessWidget {
  const _FarmSummaryCard({required this.readings});

  final List<SensorReading> readings;

  @override
  Widget build(BuildContext context) {
    final grazing = readings
        .where((r) => animalStateLabel(r) == 'Grazing')
        .length;
    final sleeping = readings
        .where((r) => animalStateLabel(r) == 'Sleeping')
        .length;
    final resting = readings
        .where((r) => animalStateLabel(r) == 'Resting')
        .length;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kAccentSoft),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: kAccentPrimary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.monitor_heart_rounded,
              color: kAccentPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Farm animal states',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  readings.isEmpty
                      ? 'Waiting for live collar readings from the farm.'
                      : '$grazing grazing, $sleeping sleeping, $resting resting.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: kTextSecond),
                ),
              ],
            ),
          ),
          Text(
            readings.isEmpty ? 'No data' : '${readings.length} collars',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: kAccentPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectCollarGuideCard extends StatelessWidget {
  const _ConnectCollarGuideCard();

  @override
  Widget build(BuildContext context) {
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
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: kAccentPrimary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.memory_rounded, color: kAccentPrimary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Register a collar to get started',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your farm is ready. Register an animal with its collar ID to start seeing readings.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: kTextSecond),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const _GuideStep(
            index: '1',
            text: 'Power on the collar and keep it close to your phone.',
          ),
          const _GuideStep(
            index: '2',
            text:
                'Add the animal details and use its collar ID as the identifier.',
          ),
          const _GuideStep(
            index: '3',
            text:
                'Enter the collar Device ID exactly as printed on the device.',
          ),
          const _GuideStep(
            index: '4',
            text:
                'Connect the collar to Wi-Fi, then wait for Online status and live readings.',
          ),
          const SizedBox(height: 14),
          PrimaryButton.filled(
            label: 'Add animal and collar',
            onPressed: () => context.push('/add-animal'),
          ),
        ],
      ),
    );
  }
}

class _GuideStep extends StatelessWidget {
  const _GuideStep({required this.index, required this.text});

  final String index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: kAccentPrimary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                index,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: kTextPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: kTextSecond, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
