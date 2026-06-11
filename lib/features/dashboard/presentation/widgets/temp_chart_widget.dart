import 'package:flutter/material.dart';
import 'package:smart_collar_app/core/constants/colors.dart';

class TempChartWidget extends StatelessWidget {
  const TempChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: kBgCardLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          'No temperature data yet',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: kTextMuted),
        ),
      ),
    );
  }
}
