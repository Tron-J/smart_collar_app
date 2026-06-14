import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/core/constants/typography.dart';
import 'package:smart_collar_app/features/auth/presentation/account_screen.dart';
import 'package:smart_collar_app/features/auth/presentation/login_screen.dart';
import 'package:smart_collar_app/features/auth/presentation/register_screen.dart';
import 'package:smart_collar_app/features/auth/presentation/splash_screen.dart';
import 'package:smart_collar_app/features/auth/presentation/verify_email_screen.dart';
import 'package:smart_collar_app/features/auth/presentation/welcome_screen.dart';
import 'package:smart_collar_app/features/alerts/presentation/alerts_screen.dart';
import 'package:smart_collar_app/features/alerts/presentation/alert_detail_screen.dart';
import 'package:smart_collar_app/features/alerts/presentation/threshold_config_screen.dart';
import 'package:smart_collar_app/features/chat/presentation/chat_screen.dart';
import 'package:smart_collar_app/features/collars/presentation/collar_detail_screen.dart';
import 'package:smart_collar_app/features/collars/presentation/collars_screen.dart';
import 'package:smart_collar_app/features/herd/presentation/animal_detail_screen.dart';
import 'package:smart_collar_app/features/herd/presentation/herd_screen.dart';
import 'package:smart_collar_app/features/onboarding/presentation/add_animal_screen.dart';
import 'package:smart_collar_app/features/onboarding/presentation/farm_setup_screen.dart';
import 'package:smart_collar_app/features/onboarding/presentation/pair_collar_screen.dart';
import 'package:smart_collar_app/features/onboarding/presentation/setup_complete_screen.dart';
import 'package:smart_collar_app/features/onboarding/presentation/wifi_config_screen.dart';
import 'package:smart_collar_app/features/dashboard/presentation/dashboard_screen.dart';
import 'package:smart_collar_app/features/history/presentation/history_screen.dart';
import 'package:smart_collar_app/features/settings/presentation/about_screen.dart';
import 'package:smart_collar_app/features/settings/presentation/data_privacy_screen.dart';
import 'package:smart_collar_app/features/settings/presentation/farm_settings_screen.dart';
import 'package:smart_collar_app/features/settings/presentation/notification_settings_screen.dart';
import 'package:smart_collar_app/features/settings/presentation/profile_settings_screen.dart';
import 'package:smart_collar_app/features/settings/presentation/settings_screen.dart';
import 'package:smart_collar_app/shared/widgets/smart_collar_shell.dart';

class SmartCollarApp extends StatelessWidget {
  SmartCollarApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/welcome', builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: '/account', builder: (_, _) => const AccountScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),
      GoRoute(
        path: '/verify-email',
        builder: (_, _) => const VerifyEmailScreen(),
      ),
      GoRoute(path: '/farm-setup', builder: (_, _) => const FarmSetupScreen()),
      GoRoute(path: '/add-animal', builder: (_, _) => const AddAnimalScreen()),
      GoRoute(
        path: '/pair-collar',
        builder: (_, state) => PairCollarScreen(
          initialDeviceId: state.uri.queryParameters['device_id'],
        ),
      ),
      GoRoute(
        path: '/wifi-config',
        builder: (_, _) => const WifiConfigScreen(),
      ),
      GoRoute(
        path: '/setup-complete',
        builder: (_, _) => const SetupCompleteScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            SmartCollarShell(location: state.uri.toString(), child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (_, _) => const DashboardScreen(),
          ),
          GoRoute(path: '/chat', builder: (_, _) => const ChatScreen()),
          GoRoute(path: '/collars', builder: (_, _) => const CollarsScreen()),
          GoRoute(
            path: '/collars/:id',
            builder: (_, state) =>
                CollarDetailScreen(collarId: state.pathParameters['id'] ?? ''),
          ),
          GoRoute(path: '/alerts', builder: (_, _) => const AlertsScreen()),
          GoRoute(
            path: '/alerts/thresholds',
            builder: (_, _) => const ThresholdConfigScreen(),
          ),
          GoRoute(
            path: '/alerts/:id',
            builder: (_, state) =>
                AlertDetailScreen(alertId: state.pathParameters['id'] ?? ''),
          ),
          GoRoute(path: '/herd', builder: (_, _) => const HerdScreen()),
          GoRoute(
            path: '/herd/:id',
            builder: (_, state) =>
                AnimalDetailScreen(animalId: state.pathParameters['id'] ?? ''),
          ),
          GoRoute(path: '/history', builder: (_, _) => const HistoryScreen()),
          GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
          GoRoute(
            path: '/settings/profile',
            builder: (_, _) => const ProfileSettingsScreen(),
          ),
          GoRoute(
            path: '/settings/farm',
            builder: (_, _) => const FarmSettingsScreen(),
          ),
          GoRoute(
            path: '/settings/notifications',
            builder: (_, _) => const NotificationSettingsScreen(),
          ),
          GoRoute(
            path: '/settings/privacy',
            builder: (_, _) => const DataPrivacyScreen(),
          ),
          GoRoute(path: '/about', builder: (_, _) => const AboutScreen()),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData.dark();
    final textTheme = buildTextTheme(baseTheme.textTheme);

    return MaterialApp.router(
      title: 'Smart Collar',
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
