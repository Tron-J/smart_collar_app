import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/core/constants/typography.dart';
import 'package:smart_collar_app/features/auth/presentation/login_screen.dart';
import 'package:smart_collar_app/features/auth/presentation/register_screen.dart';
import 'package:smart_collar_app/features/auth/presentation/splash_screen.dart';
import 'package:smart_collar_app/features/auth/presentation/verify_email_screen.dart';
import 'package:smart_collar_app/features/auth/presentation/welcome_screen.dart';
import 'package:smart_collar_app/features/alerts/presentation/alerts_screen.dart';
import 'package:smart_collar_app/features/alerts/presentation/alert_detail_screen.dart';
import 'package:smart_collar_app/features/alerts/presentation/threshold_config_screen.dart';
import 'package:smart_collar_app/features/onboarding/presentation/add_animal_screen.dart';
import 'package:smart_collar_app/features/onboarding/presentation/farm_setup_screen.dart';
import 'package:smart_collar_app/features/onboarding/presentation/pair_collar_screen.dart';
import 'package:smart_collar_app/features/onboarding/presentation/setup_complete_screen.dart';
import 'package:smart_collar_app/features/onboarding/presentation/wifi_config_screen.dart';
import 'package:smart_collar_app/features/dashboard/presentation/dashboard_screen.dart';
import 'package:smart_collar_app/features/history/presentation/history_screen.dart';
import 'package:smart_collar_app/features/settings/presentation/about_screen.dart';
import 'package:smart_collar_app/features/settings/presentation/settings_screen.dart';
import 'package:smart_collar_app/features/sensors/presentation/sensors_screen.dart';
import 'package:smart_collar_app/shared/widgets/julius_shell.dart';

class JuliusApp extends StatelessWidget {
  JuliusApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(
        path: '/verify-email',
        builder: (_, __) => const VerifyEmailScreen(),
      ),
      GoRoute(path: '/farm-setup', builder: (_, __) => const FarmSetupScreen()),
      GoRoute(path: '/add-animal', builder: (_, __) => const AddAnimalScreen()),
      GoRoute(path: '/pair-collar', builder: (_, __) => const PairCollarScreen()),
      GoRoute(path: '/wifi-config', builder: (_, __) => const WifiConfigScreen()),
      GoRoute(
        path: '/setup-complete',
        builder: (_, __) => const SetupCompleteScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            JuliusShell(location: state.location, child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (_, __) => const DashboardScreen(),
          ),
          GoRoute(path: '/sensors', builder: (_, __) => const SensorsScreen()),
          GoRoute(path: '/alerts', builder: (_, __) => const AlertsScreen()),
          GoRoute(
            path: '/alerts/:id',
            builder: (_, state) => AlertDetailScreen(
              alertId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: '/alerts/thresholds',
            builder: (_, __) => const ThresholdConfigScreen(),
          ),
          GoRoute(path: '/history', builder: (_, __) => const HistoryScreen()),
          GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
          GoRoute(path: '/about', builder: (_, __) => const AboutScreen()),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData.dark();
    final textTheme = buildTextTheme(baseTheme.textTheme);

    return MaterialApp.router(
      title: 'Julius Collar',
      theme: baseTheme.copyWith(
        scaffoldBackgroundColor: kBgDeep,
        colorScheme: baseTheme.colorScheme.copyWith(
          primary: kAccentPrimary,
          secondary: kAccentSecond,
          error: kDanger,
          surface: kBgCard,
        ),
        textTheme: textTheme.apply(
          bodyColor: kTextPrimary,
          displayColor: kTextPrimary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kBgCardLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kAccentSoft),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kAccentSoft),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kAccentPrimary),
          ),
          hintStyle: const TextStyle(color: kTextMuted),
          labelStyle: const TextStyle(color: kTextSecond),
        ),
      ),
      routerConfig: _router,
    );
  }
}
