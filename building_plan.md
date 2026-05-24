# Julius Smart Collar — Full Production Flutter App Build Prompt
**Intelligent PPR Detection System | Nigerian Army University Biu**
*By Julius Joseph · SFE/23U/3489*

---

## Design System (Non-Negotiable)

Extract and use these exact values across every screen and widget:

```dart
// colors.dart
const kBgDeep       = Color(0xFF061A12);   // deepest background
const kBgCard       = Color(0xFF0D2318);   // card surfaces
const kBgCardLight  = Color(0xFF122B1E);   // elevated cards
const kAccentPrimary = Color(0xFF00E5A0);  // teal-green primary accent
const kAccentSecond  = Color(0xFF00C47D);  // mid teal
const kAccentSoft    = Color(0xFF1A4D35);  // muted teal for borders
const kTextPrimary   = Color(0xFFFFFFFF);
const kTextSecond    = Color(0xFFB0C4BA);  // muted body text
const kTextMuted     = Color(0xFF5A7A6A);
const kDanger        = Color(0xFFFF4D4D);  // alert / high risk
const kWarning       = Color(0xFFFFB547);  // moderate risk
const kHealthy       = Color(0xFF00E5A0);  // healthy status
```

```dart
// typography.dart
// Primary font: Google Fonts "Space Grotesk" (headings, values)
// Body font: Google Fonts "DM Sans" (labels, descriptions)
// Mono font: Google Fonts "JetBrains Mono" (sensor raw values)
```

---

## Phase 1 — Foundation: Auth, Backend Core & Collar Onboarding

**Goal:** A real, working app that can register a farmer, create a farm profile, pair a physical collar, and verify the MQTT connection. No demo data. Every screen talks to a real backend.

---

### 1.1 Backend Setup (Do this before writing Flutter code)

**Stack:** Node.js + Express + PostgreSQL + MQTT (Mosquitto) + Firebase Cloud Messaging

**Database Schema (PostgreSQL):**

```sql
-- Users / Farmers
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  phone TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Farms
CREATE TABLE farms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  location TEXT,
  farm_type TEXT CHECK (farm_type IN ('sheep','goat','mixed')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Animals
CREATE TABLE animals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  farm_id UUID REFERENCES farms(id) ON DELETE CASCADE,
  animal_tag TEXT NOT NULL,           -- e.g. "GT-014"
  species TEXT CHECK (species IN ('sheep','goat')),
  sex TEXT CHECK (sex IN ('male','female')),
  age_months INTEGER,
  weight_kg NUMERIC(5,2),
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Collars / Devices
CREATE TABLE collars (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  device_id TEXT UNIQUE NOT NULL,     -- e.g. "COL-001" printed on collar
  farm_id UUID REFERENCES farms(id),
  animal_id UUID REFERENCES animals(id),
  firmware_version TEXT,
  battery_pct INTEGER,
  wifi_rssi INTEGER,
  last_seen TIMESTAMPTZ,
  is_online BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Sensor readings (time-series — consider TimescaleDB extension)
CREATE TABLE sensor_readings (
  id BIGSERIAL PRIMARY KEY,
  collar_id UUID REFERENCES collars(id) ON DELETE CASCADE,
  animal_id UUID REFERENCES animals(id),
  temp_c NUMERIC(5,2) NOT NULL,
  heart_rate_bpm INTEGER,
  spo2_pct NUMERIC(4,1),
  accel_x NUMERIC(6,3),
  accel_y NUMERIC(6,3),
  accel_z NUMERIC(6,3),
  activity_index INTEGER,             -- 0-100 derived composite
  mcu_temp_c NUMERIC(5,2),
  behavior TEXT CHECK (behavior IN ('resting','grazing','running','unknown')),
  ppr_risk_score INTEGER DEFAULT 0,   -- 0-100 edge-computed
  is_anomaly BOOLEAN DEFAULT FALSE,
  recorded_at TIMESTAMPTZ DEFAULT NOW()
);

-- Alerts
CREATE TABLE alerts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  collar_id UUID REFERENCES collars(id),
  animal_id UUID REFERENCES animals(id),
  farm_id UUID REFERENCES farms(id),
  alert_type TEXT CHECK (alert_type IN ('high_temp','low_hr','high_hr','lethargy','ppr_risk','offline')),
  severity TEXT CHECK (severity IN ('info','warning','critical')),
  message TEXT NOT NULL,
  temp_at_alert NUMERIC(5,2),
  hr_at_alert INTEGER,
  risk_score INTEGER,
  is_resolved BOOLEAN DEFAULT FALSE,
  resolved_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- FCM tokens
CREATE TABLE fcm_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  token TEXT NOT NULL,
  platform TEXT CHECK (platform IN ('android','ios')),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Alert thresholds (per farm, overridable per animal)
CREATE TABLE alert_thresholds (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  farm_id UUID REFERENCES farms(id) ON DELETE CASCADE,
  animal_id UUID REFERENCES animals(id),  -- NULL = farm-wide default
  temp_high_c NUMERIC(5,2) DEFAULT 40.0,
  temp_low_c  NUMERIC(5,2) DEFAULT 37.0,
  hr_high_bpm INTEGER DEFAULT 120,
  hr_low_bpm  INTEGER DEFAULT 50,
  activity_low_pct INTEGER DEFAULT 10,
  ppr_risk_threshold INTEGER DEFAULT 60
);
```

**REST API Endpoints (Express):**

```
POST   /auth/register          — register new farmer
POST   /auth/login             — returns JWT
POST   /auth/refresh           — refresh token
POST   /auth/logout

GET    /farms                  — list farms for user
POST   /farms                  — create farm
PATCH  /farms/:id
DELETE /farms/:id

GET    /farms/:farmId/animals
POST   /farms/:farmId/animals
GET    /animals/:id
PATCH  /animals/:id
DELETE /animals/:id

GET    /farms/:farmId/collars
POST   /collars/pair           — pair collar to farm + animal
PATCH  /collars/:id
GET    /collars/:id/status     — online status + last ping

GET    /animals/:id/readings   — paginated, ?from=&to=&limit=
GET    /animals/:id/readings/latest
GET    /animals/:id/readings/aggregate  — min/max/avg per hour

GET    /farms/:farmId/alerts   — paginated, ?resolved=false
GET    /alerts/:id
PATCH  /alerts/:id/resolve
DELETE /alerts/:id

GET    /farms/:farmId/thresholds
POST   /farms/:farmId/thresholds
PATCH  /thresholds/:id

POST   /devices/fcm-token      — register FCM token

WebSocket: ws://yourserver/ws?token=JWT
  — server pushes { type: 'reading', data: {...} }
  — server pushes { type: 'alert', data: {...} }
  — server pushes { type: 'collar_status', data: {...} }
```

**MQTT Broker config (Mosquitto):**

```
Topic pattern: collars/{device_id}/telemetry
Topic pattern: collars/{device_id}/status
Topic pattern: collars/{device_id}/command   (app → collar: future use)

Expected JSON payload from ESP32:
{
  "device_id": "COL-001",
  "temp_c": 39.09,
  "heart_rate_bpm": 85,
  "spo2_pct": 97.4,
  "accel_x": -0.39,
  "accel_y": 0.54,
  "accel_z": 9.20,
  "activity_index": 41,
  "mcu_temp_c": 30.0,
  "behavior": "grazing",
  "ppr_risk_score": 0,
  "is_anomaly": false,
  "battery_pct": 87,
  "wifi_rssi": -55,
  "firmware": "1.0.2",
  "ts": 1717200000
}
```

**MQTT → DB worker (Node.js):**
- Subscribe to `collars/+/telemetry`
- Parse JSON, look up collar by device_id
- Insert into `sensor_readings`
- Run alert evaluation logic:
  - If `temp_c >= threshold.temp_high_c` AND `activity_index <= threshold.activity_low_pct` → insert alert, set severity = 'critical', trigger FCM push
  - If `ppr_risk_score >= threshold.ppr_risk_threshold` → insert alert, severity = 'critical'
  - If collar hasn't sent data in 10 minutes → insert `offline` alert
- Push new reading to all WebSocket clients subscribed to that farm

---

### 1.2 Flutter Project Setup

```bash
flutter create julius_collar --org com.juliuscollar --platforms android,ios
cd julius_collar
```

**pubspec.yaml dependencies:**

```yaml
dependencies:
  flutter:
    sdk: flutter
  # State management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Networking
  dio: ^5.4.3
  web_socket_channel: ^2.4.0
  mqtt_client: ^10.2.1       # optional direct MQTT on device

  # Local storage
  flutter_secure_storage: ^9.0.0
  hive_flutter: ^1.1.0
  hive: ^2.2.3

  # Firebase
  firebase_core: ^2.30.1
  firebase_messaging: ^14.9.2

  # Navigation
  go_router: ^13.2.5

  # Charts
  fl_chart: ^0.68.0

  # UI / Fonts
  google_fonts: ^6.2.1
  shimmer: ^3.0.0
  lottie: ^3.1.2
  flutter_svg: ^2.0.10+1
  gap: ^3.0.1

  # Utilities
  intl: ^0.19.0
  equatable: ^2.0.5
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0
  permission_handler: ^11.3.1
  local_auth: ^2.2.0         # optional biometric login

dev_dependencies:
  build_runner: ^2.4.9
  freezed: ^2.5.2
  json_serializable: ^6.8.0
  riverpod_generator: ^2.4.0
```

**Folder structure:**

```
lib/
├── main.dart
├── app.dart                    # MaterialApp + GoRouter root
├── core/
│   ├── constants/
│   │   ├── colors.dart
│   │   ├── typography.dart
│   │   └── thresholds.dart     # PPR default thresholds
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   ├── api_client.dart     # Dio instance + interceptors
│   │   ├── websocket_service.dart
│   │   └── endpoints.dart
│   ├── storage/
│   │   ├── secure_storage.dart
│   │   └── hive_service.dart
│   └── utils/
│       ├── ppr_risk_calculator.dart
│       └── behavior_classifier.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── auth_repository.dart
│   │   │   └── models/user_model.dart
│   │   ├── providers/
│   │   │   └── auth_provider.dart
│   │   └── presentation/
│   │       ├── splash_screen.dart
│   │       ├── welcome_screen.dart
│   │       ├── register_screen.dart
│   │       ├── login_screen.dart
│   │       └── verify_email_screen.dart
│   ├── onboarding/
│   │   ├── data/
│   │   ├── providers/
│   │   └── presentation/
│   │       ├── farm_setup_screen.dart
│   │       ├── add_animal_screen.dart
│   │       ├── pair_collar_screen.dart
│   │       ├── wifi_config_screen.dart   # BLE provisioning
│   │       └── setup_complete_screen.dart
│   ├── dashboard/
│   │   ├── data/
│   │   │   └── dashboard_repository.dart
│   │   ├── providers/
│   │   │   ├── live_readings_provider.dart
│   │   │   └── websocket_provider.dart
│   │   └── presentation/
│   │       ├── dashboard_screen.dart
│   │       └── widgets/
│   │           ├── ppr_risk_card.dart
│   │           ├── sensor_card.dart
│   │           ├── temp_chart_widget.dart
│   │           ├── hr_chart_widget.dart
│   │           ├── activity_bar_widget.dart
│   │           └── collar_status_bar.dart
│   ├── herd/
│   │   ├── data/
│   │   ├── providers/
│   │   └── presentation/
│   │       ├── herd_screen.dart
│   │       ├── animal_detail_screen.dart
│   │       └── add_animal_screen.dart
│   ├── sensors/
│   │   ├── data/
│   │   ├── providers/
│   │   └── presentation/
│   │       ├── sensors_screen.dart
│   │       └── widgets/
│   │           └── sensor_row_card.dart
│   ├── alerts/
│   │   ├── data/
│   │   ├── providers/
│   │   └── presentation/
│   │       ├── alerts_screen.dart
│   │       ├── alert_detail_screen.dart
│   │       └── threshold_config_screen.dart
│   ├── history/
│   │   ├── data/
│   │   ├── providers/
│   │   └── presentation/
│   │       ├── history_screen.dart
│   │       └── export_screen.dart
│   └── settings/
│       ├── data/
│       ├── providers/
│       └── presentation/
│           ├── settings_screen.dart
│           ├── profile_screen.dart
│           ├── collar_manager_screen.dart
│           └── notifications_screen.dart
└── shared/
    └── widgets/
        ├── julius_scaffold.dart    # common dark scaffold
        ├── loading_shimmer.dart
        ├── error_view.dart
        ├── status_badge.dart
        └── teal_button.dart
```

---

### 1.3 Flutter Screens to Build in Phase 1

**Splash screen (`splash_screen.dart`):**
- Dark background `kBgDeep`
- Animated Julius Collar logo (Lottie or custom AnimatedWidget)
- Check for stored JWT → if valid, navigate to Dashboard; if not, navigate to Welcome
- Check app version against `/system/version` endpoint

**Welcome screen (`welcome_screen.dart`):**
- Full-screen dark background
- Julius Collar logo + tagline: *"Intelligent PPR Early Detection for your herd"*
- Two buttons: "Create account" (filled teal) and "Sign in" (outlined)
- No demo bypasses

**Register screen (`register_screen.dart`):**
- Fields: Full name, Email, Password (with show/hide), Phone (optional)
- Real-time validation: email format, password min 8 chars
- On submit → POST `/auth/register` → navigate to Email Verification
- Show inline API error messages (e.g. "Email already in use")

**Email verification screen (`verify_email_screen.dart`):**
- OTP input (6-digit, auto-focus next field)
- Resend OTP button with 60s cooldown timer
- On success → navigate to Farm Setup

**Login screen (`login_screen.dart`):**
- Email + Password fields
- "Forgot password?" link → separate reset flow
- Google Sign-In option (Firebase Auth)
- On success → store JWT in FlutterSecureStorage → navigate to Dashboard (or Farm Setup if onboarding incomplete)

**Farm setup screen (`farm_setup_screen.dart`):**
- Farm name, Location (text or GPS pick), Farm type (Sheep / Goat / Mixed) — segmented control
- POST `/farms` on submit

**Add animal screen (`add_animal_screen.dart`):**
- Animal tag ID (e.g. GT-014), Species, Sex, Age (months), Weight (optional)
- "Add another" vs "Continue to collar pairing"

**Pair collar screen (`pair_collar_screen.dart`):**
- Camera QR code scanner (scan the device_id from the collar sticker)
- OR manual text entry field for device_id
- On submit → POST `/collars/pair` with `{ device_id, farm_id, animal_id }`
- Server validates device_id exists and is unclaimed
- Show success state with collar ID confirmed

**Wi-Fi config screen (`wifi_config_screen.dart`):**
- Explain to farmer: *"Connect your phone to the collar's Bluetooth to configure its Wi-Fi"*
- Use `flutter_blue_plus` to scan for BLE device with name pattern "JuliusCollar-XXXX"
- On connect, send SSID + password as BLE characteristic write
- Show connection status indicator (Searching → Found → Configuring → Connected)
- On success → navigate to Setup Complete

**Setup complete screen (`setup_complete_screen.dart`):**
- Animated checkmark (Lottie)
- Summary: Farm name, animal tag, collar ID, connection status
- "Go to Dashboard" button

---

## Phase 2 — Core Dashboard & Live Sensor Display

**Goal:** Real-time data flowing from the collar through the server to the app. The dashboard and sensors tab must display live data with WebSocket updates.

---

### 2.1 WebSocket Provider

```dart
// lib/core/network/websocket_service.dart
// Connect on app launch with JWT auth
// ws://yourserver/ws?token={JWT}
// On message: parse { type, data }
//   type == 'reading'        → update LiveReadingsNotifier
//   type == 'alert'          → show local notification + update alerts badge
//   type == 'collar_status'  → update collar online/offline state
// Auto-reconnect with exponential backoff (1s, 2s, 4s, 8s, max 30s)
// Expose stream as Riverpod StreamProvider
```

### 2.2 Dashboard Screen (`dashboard_screen.dart`)

Matches the design in Image 1 exactly:

**Top app bar:**
- "J" avatar teal circle (first letter of farm name)
- "Julius Collar" title + "PPR Early Detection · ESP32" subtitle
- Top nav: Dashboard (active, pill-shaped teal bg) | Sensors | Alerts | About

**PPR Risk card (full width):**
- Dark card `kBgCard`, green dot + "LIVE MONITORING · ANIMAL #GT-014"
- Large text: "Status: **Healthy**" (kHealthy green) or "Status: **At Risk**" (kDanger red) or "Status: **Warning**" (kWarning amber)
- Shield icon with checkmark (animated pulse when healthy)
- PPR Risk score: large number 0–100 out of 100
- Subtitle: *"Edge-computed risk score combining body temperature, heart rate and motion to detect early signs of Peste des Petits Ruminants."*

**"Sensor readings" header:**
- Left: "Sensor readings" title
- Right: "Updating every 1.5s" muted label (blinks dot while connected)

**Sensor cards (scrollable list, each full width):**

1. **Body Temperature card:**
   - Icon: thermometer, label "Body Temperature", subtitle "DS18B20"
   - Large value: `39.09 °C` (Space Grotesk / JetBrains Mono)
   - Subtitle: "Normal range 38.5–39.7°C"
   - Mini sparkline chart (fl_chart LineChart, last 20 readings)
   - Card color changes: kBgCard (normal), kWarning-tinted (39.7–40.0°C), kDanger-tinted (>40.0°C)

2. **Heart Rate card:**
   - Icon: heart-pulse, label "Heart Rate", subtitle "MAX30102 PULSE SENSOR"
   - Large value: `85 bpm`
   - Subtitle: "Typical resting: 70–90 bpm"
   - Mini sparkline (red line as in Image 1)
   - Tap → navigate to Heart Rate detail in History

3. **Activity Level card:**
   - Icon: activity wave, label "Activity Level", subtitle "MPU6050 ACCELEROMETER"
   - Large value: `41 %`
   - Subtitle: "Composite motion intensity"
   - Linear progress bar: Resting → Grazing → Running (color: kAccentPrimary)

4. **Accelerometer Axes card:**
   - Label "Accelerometer Axes", subtitle "MPU6050 · M/S²"
   - Large value: `9.20 z-axis g`
   - Three-column mini display: X / Y / Z with values
   - Values in JetBrains Mono

5. **Battery card:**
   - Icon: battery, label "Battery", subtitle "3.7V LIPO · 1200MAH"
   - Large value: `87 %`
   - Subtitle: "Deep-sleep enabled"
   - Full-width green progress bar

6. **Wi-Fi Signal card:**
   - Icon: wifi bars, label "Wi-Fi Signal", subtitle "ESP32 ONBOARD"
   - Large value: `77 %` (derived from RSSI)
   - Subtitle: "Edge alerts work offline too"
   - Signal strength bar

**Bottom tab bar (custom dark):**
- 4 tabs: Dashboard, Sensors, Alerts, History, Settings
- Active tab: teal icon + teal underline indicator
- Tab bar background: `kBgCard`

---

### 2.3 Sensors Screen (`sensors_screen.dart`)

Matches Image 2 exactly:

**Header:**
- "Sensors" large title (Space Grotesk, 32px, white)
- Subtitle: "Live data streamed from the ESP32 collar at 1.5s intervals."
- Updating indicator dot

**Sensor list — one `SensorRowCard` per sensor:**

Each card: dark bg, icon in teal circle, sensor name (teal), sensor source (muted), value right-aligned (large, teal, JetBrains Mono), unit below value.

Sensors to show:
1. Body Temperature — DS18B20 1-WIRE — value °C
2. Heart Rate — MAX30102 PULSE — value beats/min
3. Activity Index — MPU6050 DERIVED — value %
4. Accelerometer X — MPU6050 — value m/s²
5. Accelerometer Y — MPU6050 — value m/s²
6. Accelerometer Z — MPU6050 — value m/s²
7. MCU Temperature — ESP32 INTERNAL — value °C
8. Risk Score — EDGE INFERENCE — value: "Healthy" / "Warning" / "Critical"

Each card animates its value when it updates (brief scale pop: 1.0 → 1.08 → 1.0 in 200ms).

---

### 2.4 Data Flow Implementation

```dart
// lib/features/dashboard/providers/live_readings_provider.dart
// Riverpod StateNotifierProvider<LiveReadingsNotifier, ReadingsState>
// State holds: latest SensorReading, isConnected, lastUpdated
// Updated by WebSocket stream (Phase 2) AND initial REST GET on load

// lib/features/dashboard/data/models/sensor_reading.dart
@freezed
class SensorReading with _$SensorReading {
  const factory SensorReading({
    required String collarId,
    required String animalId,
    required double tempC,
    required int heartRateBpm,
    required double spo2Pct,
    required double accelX,
    required double accelY,
    required double accelZ,
    required int activityIndex,
    required double mcuTempC,
    required String behavior,
    required int pprRiskScore,
    required bool isAnomaly,
    required int batteryPct,
    required int wifiRssi,
    required DateTime recordedAt,
  }) = _SensorReading;

  factory SensorReading.fromJson(Map<String, dynamic> json) =>
      _$SensorReadingFromJson(json);
}
```

---

## Phase 3 — Alerts System, History & Herd Management

**Goal:** Fully functional alerts pipeline, animal health history with charts, and complete herd CRUD management.

---

### 3.1 Alerts Screen (`alerts_screen.dart`)

**Alert inbox:**
- Top filter chips: All | Critical | Warning | Info | Resolved
- Each alert card:
  - Colored left border (red = critical, amber = warning, teal = info)
  - Alert type icon + type label
  - Animal tag (e.g. "GT-014") + timestamp (relative: "3 min ago")
  - Message text (e.g. "Fever detected: 40.8°C with severe lethargy (Activity: 8%)")
  - Temp + HR at time of alert
  - Tap → Alert Detail

**Alert Detail screen:**
- Full context: animal info, exact readings at time of alert
- Mini snapshot chart (temp + HR at ±30 min around alert)
- "Mark as Resolved" button → PATCH `/alerts/:id/resolve`
- "View animal history" button

**Alert notification (FCM):**
- On app foreground: show in-app snackbar (red, dismissible)
- On app background: system notification with alert message
- Tap notification → deep-link to Alert Detail

**Threshold Config screen:**
- Per-farm defaults, overridable per animal
- Sliders for: Temp high (°C), Temp low (°C), HR high (bpm), HR low (bpm), Activity low (%), PPR risk threshold
- Real values from database, PATCH `/thresholds/:id` on save

---

### 3.2 History Screen (`history_screen.dart`)

**Date range picker** (default: last 24h, options: 6h / 24h / 7d / 30d / custom)

**Tabs within history:**
- Temperature — LineChart (fl_chart), y-axis 35–42°C, danger zone shaded red above 40°C
- Heart Rate — LineChart, y-axis 40–140 bpm
- Activity — AreaChart, behavior segments colored by type
- Risk Score — LineChart, threshold line at configured value

**Charts requirements:**
- X-axis: time labels (HH:mm or date depending on range)
- Y-axis: clean labeled grid lines
- Tap a data point → show tooltip with exact value + timestamp
- Pull from GET `/animals/:id/readings?from=&to=&limit=500`
- Loading shimmer while fetching

**Export screen:**
- Date range selector
- Format selector: CSV or PDF
- "Export" button → call GET `/animals/:id/readings/export?format=csv&from=&to=` → download file
- Share sheet on success

---

### 3.3 Herd Screen (`herd_screen.dart`)

**Animal list:**
- Search bar (filter by tag, species)
- Each animal card: tag, species icon, age, weight, collar status badge (Online / Offline / Unassigned), last temp + HR
- Tap → Animal Detail

**Animal Detail screen:**
- Header: avatar circle (species icon), name/tag, species, age, weight
- Collar assignment section: current collar ID, status, battery, signal
- Quick stats: last temp, last HR, risk score, behavior
- Mini chart (last 6h temp)
- Buttons: "View full history" | "Edit animal" | "Reassign collar"

**Add/Edit Animal screen:**
- Tag, species (dropdown), sex (segmented), age (number input), weight (number input), notes
- POST or PATCH accordingly

---

## Phase 4 — Settings, Notifications & Offline Resilience

**Goal:** Production-ready settings, push notifications fully wired, offline caching, and performance polish.

---

### 4.1 Settings Screen (`settings_screen.dart`)

Sections:
- **Profile** — name, email, phone, change password
- **Farm** — farm name, location, type; manage multiple farms
- **Collar management** — list all paired collars, status, battery, firmware version, unpair option
- **Notifications** — toggle: critical alerts, warning alerts, daily summary, collar offline; configure quiet hours
- **Alert thresholds** — redirect to threshold config
- **Data & Privacy** — delete account, export all data
- **About** — app version, firmware version, institution credit, contact

### 4.2 Push Notification Full Wiring

```dart
// lib/core/services/notification_service.dart

// 1. On login: request permission, get FCM token
// 2. POST /devices/fcm-token with { token, platform }
// 3. Refresh token on app resume (token can rotate)
// 4. Handle foreground messages: show custom in-app banner
// 5. Handle background tap: parse data payload, navigate to correct screen
//    data.type == 'alert' → navigate to /alerts/:alertId
//    data.type == 'collar_offline' → navigate to /settings/collars

// FCM payload from server:
{
  "notification": {
    "title": "⚠️ PPR Risk Detected — GT-014",
    "body": "Fever 40.8°C + Lethargy detected. Immediate attention required."
  },
  "data": {
    "type": "alert",
    "alert_id": "uuid",
    "animal_tag": "GT-014",
    "severity": "critical"
  }
}
```

### 4.3 Offline Caching (Hive)

```dart
// Cache strategy:
// - Last 50 sensor readings per animal (Hive box: 'readings_{animalId}')
// - Current alert list (Hive box: 'alerts_{farmId}')
// - Animal + collar metadata (Hive box: 'herd_{farmId}')
// - Auth token (FlutterSecureStorage only — never Hive)

// On app open with no network:
// - Show offline banner: "No connection — showing cached data"
// - Load from Hive boxes
// - Disable "Export" and threshold save actions
// - Queue failed PATCH requests (alert resolve, threshold update) and retry on reconnect
```

### 4.4 Performance & Polish

- All lists: use `ListView.builder` (never `.children` for large lists)
- Shimmer loading on every data screen (package: shimmer)
- Empty states: custom illustrated empty states (SVG) for no animals, no alerts, no history
- Error states: retry button + error message from server
- Connection state banner: persistent top banner when WebSocket disconnects
- Smooth page transitions: custom slide transitions via GoRouter
- All Dio requests: 30s timeout, retry on 5xx (max 3 attempts), token refresh on 401
- Sensor value animations: every sensor reading update animates with AnimatedSwitcher

---

## Phase 5 — PPR Risk Engine, Reporting & Production Hardening

**Goal:** The app's intelligent core — risk scoring display, automated health summaries, full PDF report generation, and production-level security and monitoring.

---

### 5.1 PPR Risk Score Display

The ESP32 sends `ppr_risk_score` (0–100). The app must visualise it clearly:

**Risk card states:**

| Score | Status | Color | Behaviour |
|-------|--------|-------|-----------|
| 0–30 | Healthy | kHealthy | Shield checkmark, no action |
| 31–59 | Monitor | kWarning | Warning triangle, amber |
| 60–79 | At Risk | kDanger | Alert icon, red pulse animation |
| 80–100 | Critical | kDanger | Flashing card, immediate alert |

**Risk breakdown tooltip (tap the risk score):**
- Show contributing factors:
  - Temperature: +X points (if elevated)
  - Heart Rate: +X points (if abnormal)
  - Activity: +X points (if lethargic)
- Plain language: "High fever combined with lethargy suggests early PPR symptoms."

### 5.2 Daily Health Summary

- Server generates daily summary at 8:00 AM farm local time
- Push notification: "Daily herd report — 3 animals monitored, 0 alerts today"
- In-app: "Today's summary" card at top of Dashboard (dismissible)

### 5.3 PDF Report Generation (in-app)

```dart
// package: pdf + printing
// Report content:
// - Farm name, date range
// - Animal summary table (tag, species, avg temp, avg HR, alert count)
// - Temperature chart (rendered as image from fl_chart)
// - Heart rate chart
// - Alert log table (timestamp, type, reading, resolved)
// - Risk score trend
// Share via share_plus
```

### 5.4 About Screen (`about_screen.dart`)

```
Julius Collar — Intelligent Livestock Monitoring
Version: 1.0.0

A final year project by:
Julius Joseph (SFE/23U/3489)
Department of Software Engineering
Nigerian Army University Biu

Supervisor: Dr. Ali Garba Jakwa

Hardware: ESP32 + DS18B20 + MAX30102 + MPU6050
Communication: MQTT over Wi-Fi → Cloud Server → Flutter

This system detects early signs of Peste des Petits Ruminants
(PPR) by continuously monitoring body temperature, heart rate,
and physical activity of livestock in real time.

Contact: [email]
GitHub: [link]
```

### 5.5 Security Hardening

- JWT stored in `flutter_secure_storage` (hardware-backed keystore on Android, Keychain on iOS)
- All API calls over HTTPS (TLS 1.3)
- Certificate pinning via Dio interceptor (pin your server cert SHA256)
- MQTT over TLS (port 8883)
- Biometric login option (local_auth) after first login
- Input sanitization on all form fields
- Rate limiting on login endpoint (backend: 5 attempts / 15 min)
- FCM token rotation handled gracefully

### 5.6 Production Checklist

**Android:**
- `minSdkVersion 23`, `targetSdkVersion 34`
- ProGuard rules for all packages
- Release signing config
- `android:usesCleartextTraffic="false"` (HTTPS only)

**iOS:**
- Deployment target iOS 13.0+
- Background modes: Remote notifications, Background fetch
- NSLocalNetworkUsageDescription (for BLE)
- NSBluetoothAlwaysUsageDescription

**Backend:**
- Environment variables for all secrets (never hardcode)
- PM2 process manager for Node.js
- Nginx reverse proxy with SSL
- Daily PostgreSQL backups
- Health check endpoint: GET `/health`
- Structured logging (Winston / Pino)

---

## Implementation Order (Within Each Phase)

Always build in this order within each phase:

1. **Data models first** (Freezed classes + JSON serialization)
2. **Repository layer** (raw API calls, no business logic)
3. **Providers** (Riverpod — wire repository to state)
4. **Screens** (consume providers, build UI)
5. **Tests** (unit test providers and repositories)

---

## Key Rules for the Entire Build

1. **Zero demo data.** Every number on every screen comes from the database. If there is no data, show a proper empty state.
2. **Every screen has three states:** loading (shimmer), error (retry view), and data.
3. **The design system is law.** Only `kBgDeep`, `kBgCard`, `kBgCardLight`, `kAccentPrimary` family, and semantic colours. No Material blue, no white backgrounds.
4. **Font hierarchy is strict:** Space Grotesk for headings + large values, DM Sans for body + labels, JetBrains Mono for raw sensor values.
5. **Sensor values always animate on update.** Use `AnimatedSwitcher` with a subtle fade+scale.
6. **The PPR risk card is always visible at the top of the dashboard.** It is the centrepiece of the product.
7. **Offline must degrade gracefully.** The app must open and show cached data even with zero network.
8. **The "About" screen must include Julius's name, matric number, university, and supervisor.** This is a final year project submission.