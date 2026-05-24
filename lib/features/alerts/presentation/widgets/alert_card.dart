import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/features/alerts/data/models/alert.dart';

class AlertCard extends StatelessWidget {
  const AlertCard({super.key, required this.alert, required this.onTap});

  final Alert alert;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _colorForSeverity(alert.severity);
    final date = DateFormat('MMM d, HH:mm').format(alert.createdAt);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kBgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: color, width: 3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_iconForType(alert.alertType), color: color, size: 18),
                const SizedBox(width: 8),
                Text(
                  _labelForType(alert.alertType),
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: color),
                ),
                const Spacer(),
                Text(
                  date,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: kTextMuted),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              alert.message,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: kTextSecond),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Animal: ${_shortId(alert.animalId)}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: kTextMuted),
                ),
                const Spacer(),
                if (alert.tempAtAlert != null)
                  Text(
                    'Temp ${alert.tempAtAlert}°C',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: kTextMuted),
                  ),
                if (alert.hrAtAlert != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    'HR ${alert.hrAtAlert} bpm',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: kTextMuted),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _shortId(String id) {
    if (id.length <= 6) return id;
    return id.substring(0, 6).toUpperCase();
  }

  Color _colorForSeverity(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.info:
        return kAccentPrimary;
      case AlertSeverity.warning:
        return kWarning;
      case AlertSeverity.critical:
        return kDanger;
    }
  }

  IconData _iconForType(AlertType type) {
    switch (type) {
      case AlertType.highTemp:
        return Icons.thermostat;
      case AlertType.lowHr:
      case AlertType.highHr:
        return Icons.favorite;
      case AlertType.lethargy:
        return Icons.directions_walk;
      case AlertType.pprRisk:
        return Icons.shield;
      case AlertType.offline:
        return Icons.wifi_off;
    }
  }

  String _labelForType(AlertType type) {
    switch (type) {
      case AlertType.highTemp:
        return 'High temperature';
      case AlertType.lowHr:
        return 'Low heart rate';
      case AlertType.highHr:
        return 'High heart rate';
      case AlertType.lethargy:
        return 'Lethargy';
      case AlertType.pprRisk:
        return 'PPR risk';
      case AlertType.offline:
        return 'Collar offline';
    }
  }
}
