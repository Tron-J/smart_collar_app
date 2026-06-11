# Julius Collar Backend

Express/PostgreSQL/MQTT backend for the Flutter app.

Authentication is handled by Supabase. The backend validates Supabase access tokens and uses the Supabase user UUID as `farms.user_id`.

## Setup

1. Use your Supabase Postgres connection string for `DATABASE_URL`.
2. Run `schema.sql` against the Supabase database.
3. Copy `.env.example` to `.env`.
4. Set `DATABASE_URL`, `SUPABASE_JWT_SECRET`, `MQTT_URL`, `MQTT_USERNAME`, and `MQTT_PASSWORD`.
5. Run `npm install`.
6. Run `npm run dev`.

The Flutter app should be started with:

```bash
flutter run --dart-define=API_BASE_URL=http://localhost:8080 --dart-define=WS_BASE_URL=ws://localhost:8080/ws --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your-supabase-anon-key
```
--dart-define=SUPABASE_URL=https://ezxsfdojhbkxxpspimoo.supabase.co/rest/v1/ --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV6eHNmZG9qaGJreHhwc3BpbW9vIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODExMjI5NzksImV4cCI6MjA5NjY5ODk3OX0.n9soLVSDreBBP_RdTr86xsY4SwLqQ0EPbL3T-b6QjkU