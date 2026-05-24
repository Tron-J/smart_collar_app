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
          'About Julius Collar',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        Text(
          'Julius Collar — Intelligent Livestock Monitoring\n'
          'Version: 1.0.0\n\n'
          'A final year project by:\n'
          'Julius Joseph (SFE/23U/3489)\n'
          'Department of Software Engineering\n'
          'Nigerian Army University Biu\n\n'
          'Supervisor: Dr. Ali Garba Jakwa\n\n'
          'Hardware: ESP32 + DS18B20 + MAX30102 + MPU6050\n'
          'Communication: MQTT over Wi-Fi → Cloud Server → Flutter\n\n'
          'This system detects early signs of Peste des Petits Ruminants\n'
          '(PPR) by continuously monitoring body temperature, heart rate,\n'
          'and physical activity of livestock in real time.\n\n'
          'Contact: [email]\n'
          'GitHub: [link]',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: kTextSecond, height: 1.4),
        ),
      ],
    );
  }
}
