# smart_collar_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


flutter build apk --release --split-per-abi \
  --dart-define=API_BASE_URL=https://http://smart-collar-app-backend.onrender.com \
  --dart-define=WS_BASE_URL=wss://http://smart-collar-app-backend.onrender.com/ws \
  --dart-define=SUPABASE_URL=https://ezxsfdojhbkxxpspimoo.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV6eHNmZG9qaGJreHhwc3BpbW9vIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODExMjI5NzksImV4cCI6MjA5NjY5ODk3OX0.n9soLVSDreBBP_RdTr86xsY4SwLqQ0EPbL3T-b6QjkU