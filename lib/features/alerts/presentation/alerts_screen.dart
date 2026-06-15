import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/features/alerts/data/models/alert.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/features/alerts/presentation/widgets/alert_card.dart';
import 'package:smart_collar_app/features/alerts/providers/alerts_provider.dart';
import 'package:smart_collar_app/shared/widgets/error_view.dart';
import 'package:smart_collar_app/shared/widgets/loading_shimmer.dart';

class AlertsScreen extends ConsumerStatefulWidget {
  const AlertsScreen({super.key});

  @override
  ConsumerState<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends ConsumerState<AlertsScreen> {
  _AlertFilter _filter = _AlertFilter.all;

  @override
  Widget build(BuildContext context) {
    final alertsValue = ref.watch(alertsProvider);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Alerts', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 6),
        Text(
          'Monitor critical health events as they occur.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: [
            _FilterChip(
              label: 'All',
              isActive: _filter == _AlertFilter.all,
              onTap: () => setState(() => _filter = _AlertFilter.all),
            ),
            _FilterChip(
              label: 'Critical',
              isActive: _filter == _AlertFilter.critical,
              onTap: () => setState(() => _filter = _AlertFilter.critical),
            ),
            _FilterChip(
              label: 'Warning',
              isActive: _filter == _AlertFilter.warning,
              onTap: () => setState(() => _filter = _AlertFilter.warning),
            ),
            _FilterChip(
              label: 'Info',
              isActive: _filter == _AlertFilter.info,
              onTap: () => setState(() => _filter = _AlertFilter.info),
            ),
            _FilterChip(
              label: 'Resolved',
              isActive: _filter == _AlertFilter.resolved,
              onTap: () => setState(() => _filter = _AlertFilter.resolved),
            ),
          ],
        ),
        const SizedBox(height: 20),
        alertsValue.when(
          loading: () => const _LoadingList(),
          error: (error, _) => ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(alertsProvider),
          ),
          data: (alerts) {
            final filtered = _applyFilter(alerts, _filter);
            if (filtered.isEmpty) {
              return _EmptyState(filter: _filter);
            }
            return ListView.builder(
              itemCount: filtered.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final alert = filtered[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AlertCard(
                    alert: alert,
                    onTap: () => context.push('/alerts/${alert.id}'),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  List<Alert> _applyFilter(List<Alert> alerts, _AlertFilter filter) {
    switch (filter) {
      case _AlertFilter.critical:
        return alerts
            .where((alert) => alert.severity == AlertSeverity.critical)
            .toList();
      case _AlertFilter.warning:
        return alerts
            .where((alert) => alert.severity == AlertSeverity.warning)
            .toList();
      case _AlertFilter.info:
        return alerts
            .where((alert) => alert.severity == AlertSeverity.info)
            .toList();
      case _AlertFilter.resolved:
        return alerts.where((alert) => alert.isResolved).toList();
      case _AlertFilter.all:
        return alerts;
    }
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    this.isActive = false,
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

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        LoadingShimmer(height: 72),
        SizedBox(height: 12),
        LoadingShimmer(height: 72),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filter});

  final _AlertFilter filter;

  @override
  Widget build(BuildContext context) {
    final label = switch (filter) {
      _AlertFilter.critical => 'No critical alerts right now.',
      _AlertFilter.warning => 'No warning alerts right now.',
      _AlertFilter.info => 'No info alerts right now.',
      _AlertFilter.resolved => 'No resolved alerts yet.',
      _AlertFilter.all =>
        'No alerts yet. We will surface warnings as they occur.',
    };

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kAccentSoft),
      ),
      child: Column(
        children: [
          const Icon(Icons.notifications_off, color: kTextMuted, size: 32),
          const SizedBox(height: 12),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

enum _AlertFilter { all, critical, warning, info, resolved }
