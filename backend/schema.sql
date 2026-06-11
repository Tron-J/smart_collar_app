CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS farms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  name TEXT NOT NULL,
  location TEXT,
  farm_type TEXT CHECK (farm_type IN ('sheep','goat','mixed')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS animals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  farm_id UUID REFERENCES farms(id) ON DELETE CASCADE,
  animal_tag TEXT NOT NULL,
  species TEXT CHECK (species IN ('sheep','goat')),
  sex TEXT CHECK (sex IN ('male','female')),
  age_months INTEGER,
  weight_kg NUMERIC(5,2),
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS collars (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  device_id TEXT UNIQUE NOT NULL,
  farm_id UUID REFERENCES farms(id),
  animal_id UUID REFERENCES animals(id),
  firmware_version TEXT,
  battery_pct INTEGER,
  wifi_rssi INTEGER,
  last_seen TIMESTAMPTZ,
  is_online BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS sensor_readings (
  id BIGSERIAL PRIMARY KEY,
  collar_id UUID REFERENCES collars(id) ON DELETE CASCADE,
  animal_id UUID REFERENCES animals(id),
  temp_c NUMERIC(5,2) NOT NULL,
  heart_rate_bpm INTEGER,
  spo2_pct NUMERIC(4,1),
  accel_x NUMERIC(6,3),
  accel_y NUMERIC(6,3),
  accel_z NUMERIC(6,3),
  activity_index INTEGER,
  mcu_temp_c NUMERIC(5,2),
  behavior TEXT CHECK (behavior IN ('resting','grazing','running','unknown')),
  ppr_risk_score INTEGER DEFAULT 0,
  is_anomaly BOOLEAN DEFAULT FALSE,
  battery_pct INTEGER,
  wifi_rssi INTEGER,
  recorded_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS alerts (
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

CREATE TABLE IF NOT EXISTS alert_thresholds (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  farm_id UUID REFERENCES farms(id) ON DELETE CASCADE,
  animal_id UUID REFERENCES animals(id),
  temp_high_c NUMERIC(5,2) DEFAULT 40.0,
  temp_low_c NUMERIC(5,2) DEFAULT 37.0,
  hr_high_bpm INTEGER DEFAULT 120,
  hr_low_bpm INTEGER DEFAULT 50,
  activity_low_pct INTEGER DEFAULT 10,
  ppr_risk_threshold INTEGER DEFAULT 60
);
