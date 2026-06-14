# Smart Collar Backend

Express/PostgreSQL/MQTT backend for the Flutter app.

Authentication is handled by Supabase. The backend validates Supabase access tokens and uses the Supabase user UUID as `farms.user_id`.

## Setup

1. Use your Supabase Postgres connection string for `DATABASE_URL`.
2. Run `schema.sql` against the Supabase database.
3. Copy `.env.example` to `.env`.
4. Set `DATABASE_URL`, `SUPABASE_URL`, `MQTT_URL`, `MQTT_USERNAME`, and `MQTT_PASSWORD`.
   - `SUPABASE_URL` is required for projects using the current Supabase JWT signing keys.
   - `SUPABASE_JWT_SECRET` is only needed as a fallback for legacy HS256 tokens.
5. Run `npm install`.
6. Run `npm run dev`.

The Flutter app should be started with:

```bash
flutter run --dart-define=API_BASE_URL=http://localhost:8080 --dart-define=WS_BASE_URL=ws://localhost:8080/ws --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your-supabase-anon-key
```
