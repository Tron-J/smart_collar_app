import 'package:flutter/material.dart';
import 'package:smart_collar_app/core/constants/colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'About Smart Collar',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        Text(
          'Smart Collar - Intelligent Livestock Monitoring\n'
          'Version: 1.0.0\n\n'
          'Smart Collar helps farms monitor livestock health in real time '
          'using wearable IoT collars and cloud dashboards.\n\n'
          'The system tracks pulse, body temperature, movement, battery, '
          'connection strength, and PPR risk signals so farm owners '
          'can respond earlier to health changes.\n\n'
          'Built for animal health monitoring, farm collar management, '
          'and real-time alerting.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: kTextSecond, height: 1.4),
        ),
      ],
    );
  }
}
