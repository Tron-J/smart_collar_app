import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/shared/widgets/julius_scaffold.dart';
import 'package:smart_collar_app/shared/widgets/teal_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = const [
      _IntroPage(
        icon: Icons.health_and_safety,
        title: 'Detect PPR early',
        body: 'Track temperature, heart rate, and movement from each collar.',
      ),
      _IntroPage(
        icon: Icons.sensors,
        title: 'Live collar telemetry',
        body: 'ESP32 readings flow through MQTT and Supabase-backed services.',
      ),
      _IntroPage(
        icon: Icons.notifications_active,
        title: 'Act on alerts',
        body: 'Critical readings are surfaced quickly for farm decisions.',
      ),
    ];

    return JuliusScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: kAccentPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'J',
                      style: TextStyle(
                        color: kBgDeep,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (value) => setState(() => _index = value),
                  children: pages,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (dot) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: dot == _index ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: dot == _index ? kAccentPrimary : kAccentSoft,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TealButton.filled(
                label: _index == pages.length - 1 ? 'Continue' : 'Next',
                onPressed: () {
                  if (_index == pages.length - 1) {
                    context.go('/account');
                    return;
                  }
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOut,
                  );
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => context.go('/account'),
                child: const Text('Skip'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  const _IntroPage({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: kAccentPrimary, size: 58),
        const SizedBox(height: 22),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          body,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: kTextSecond),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
