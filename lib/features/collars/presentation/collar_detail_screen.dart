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
import 'package:smart_collar_app/shared/widgets/error_view.dart';
import 'package:smart_collar_app/shared/widgets/loading_shimmer.dart';
import 'package:smart_collar_app/shared/widgets/status_badge.dart';

class CollarDetailScreen extends ConsumerWidget {
  const CollarDetailScreen({super.key, required this.collarId});

  final String collarId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(realtimeRefreshTickProvider, (_, _) {
      invalidateRealtimeFarmData(ref);
    });
    ref.watch(websocketStreamProvider);
    ref.watch(farmLatestReadingsProvider);
    final collarsValue = ref.watch(farmCollarsProvider);
    final readingsState = ref.watch(liveReadingsProvider);
    final reading = readingsState.latestByCollar[collarId];
    final recent = readingsState.recent
        .where((item) => item.collarId == collarId)
        .toList();

    return collarsValue.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(20),
        child: LoadingShimmer(height: 260),
      ),
      error: (error, _) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(farmCollarsProvider),
          ),
        ],
      ),
      data: (collars) {
        final collar = collars.cast<Collar?>().firstWhere(
          (item) => item?.id == collarId,
          orElse: () => null,
        );
        if (collar == null) {
          return const _MissingCollarState();
        }

        return RefreshIndicator(
          color: kAccentPrimary,
          backgroundColor: kBgCard,
          onRefresh: () => refreshRealtimeFarmData(ref),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/collars');
                      }
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          collar.deviceId,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          'Animal ${collar.animalId ?? 'not assigned'}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: kTextSecond),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(
                    label: collar.isOnline ? 'Online' : 'Offline',
                    color: collar.isOnline ? kAccentPrimary : kTextMuted,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _CollarStatusRow(collar: collar),
              const SizedBox(height: 16),
              _AnimalStateCard(reading: reading),
              const SizedBox(height: 16),
              PprRiskCard(score: reading?.pprRiskScore),
              const SizedBox(height: 20),
              Text(
                'Collar readings',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              SensorCard(
                title: 'Pulse',
                subtitle: 'Heart health',
                value: reading?.heartRateBpm,
                unit: 'bpm',
                detail: 'Pulse trend for this animal',
                chart: HrChartWidget(readings: recent),
              ),
              const SizedBox(height: 12),
              SensorCard(
                title: 'Body Temperature',
                subtitle: 'Health check',
                value: reading?.tempC,
                unit: 'C',
                detail: 'Normal range 38.5-39.7 C',
                chart: TempChartWidget(readings: recent),
              ),
              const SizedBox(height: 12),
              SensorCard(
                title: 'Movement',
                subtitle: 'Behavior signal',
                value: reading?.activityIndex,
                unit: '%',
                detail: animalStateDetail(reading),
                chart: const ActivityBarWidget(),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () => _confirmDisconnect(context, ref, collar),
                icon: const Icon(Icons.link_off_rounded),
                label: const Text('Disconnect collar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kDanger,
                  side: const BorderSide(color: kDanger),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Future<void> _confirmDisconnect(
  BuildContext context,
  WidgetRef ref,
  Collar collar,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Disconnect collar?'),
      content: Text(
        'This will remove ${collar.deviceId} from this farm. It can then be paired by another account.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Disconnect'),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;

  try {
    await ref.read(herdRepositoryProvider).disconnectCollar(collar.id);
    ref.invalidate(farmCollarsProvider);
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Collar disconnected')));
    context.go('/collars');
  } catch (error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(error.toString())));
  }
}

class _CollarStatusRow extends StatelessWidget {
  const _CollarStatusRow({required this.collar});

  final Collar collar;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.battery_5_bar_rounded,
            label: 'Battery',
            value: '${collar.batteryPct ?? 0}%',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MetricCard(
            icon: Icons.wifi_rounded,
            label: 'Wi-Fi',
            value: '${collar.wifiRssi ?? 0}%',
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

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
          Icon(icon, color: kAccentPrimary),
          const SizedBox(height: 10),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 2),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}

class _AnimalStateCard extends StatelessWidget {
  const _AnimalStateCard({required this.reading});

  final SensorReading? reading;

  @override
  Widget build(BuildContext context) {
    final state = animalStateLabel(reading);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kAccentSoft),
      ),
      child: Row(
        children: [
          const Icon(Icons.monitor_heart_rounded, color: kAccentPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Animal state',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  animalStateDetail(reading),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: kTextSecond),
                ),
              ],
            ),
          ),
          Text(
            state,
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

class _MissingCollarState extends StatelessWidget {
  const _MissingCollarState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Collar not found', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'This collar is not in the current farm list.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
        ),
      ],
    );
  }
}
