
import mqtt from 'mqtt';
import { config } from './config.js';
import { firstRow, query } from './db.js';
import { evaluateAlerts, getThreshold } from './alerts.js';
import { broadcastToFarm } from './wsHub.js';

const mqttStatus = {
  configuredUrl: config.mqttUrl,
  isConnected: false,
  isSubscribed: false,
  lastConnectedAt: null,
  lastMessageAt: null,
  lastMessageCount: 0,
  lastError: null
};

export function getMqttStatus() {
  return { ...mqttStatus };
}

export function startMqttWorker() {
  console.log(`[MQTT] Connecting to ${config.mqttUrl}...`);

  const client = mqtt.connect(config.mqttUrl, {
    username: config.mqttUsername,
    password: config.mqttPassword,
    reconnectPeriod: 5000,
    connectTimeout: 10000,
    clean: true
  });

  client.on('connect', () => {
    mqttStatus.isConnected = true;
    mqttStatus.lastConnectedAt = new Date().toISOString();
    mqttStatus.lastError = null;
    console.log('[MQTT] Connected successfully');

    client.subscribe(['collars/+/telemetry', 'collars/+/status'], (error) => {
      mqttStatus.isSubscribed = !error;
      if (error) {
        mqttStatus.lastError = error.message;
        console.error('[MQTT] Subscribe error:', error.message);
      } else {
        console.log('[MQTT] Subscribed to topics: collars/+/telemetry, collars/+/status');
      }
    });
  });

  client.on('close', () => {
    mqttStatus.isConnected = false;
    mqttStatus.isSubscribed = false;
    console.log('[MQTT] Connection closed');
  });

  client.on('offline', () => {
    mqttStatus.isConnected = false;
    mqttStatus.isSubscribed = false;
    console.log('[MQTT] Client is offline');
  });

  client.on('reconnect', () => {
    console.log('[MQTT] Attempting to reconnect...');
  });

  client.on('error', (error) => {
    mqttStatus.lastError = error.message;
    console.error('[MQTT] Connection error:', error.message);
  });

  client.on('message', async (topic, payload) => {
    try {
      mqttStatus.lastMessageAt = new Date().toISOString();
      mqttStatus.lastMessageCount++;
      const data = JSON.parse(payload.toString());

      // Log telemetry messages periodically (every 100th message)
      if (topic.endsWith('/telemetry') && mqttStatus.lastMessageCount % 100 === 0) {
        console.log(`[MQTT] Telemetry received from ${topic}: temp=${data.temp_c}°C, hr=${data.heart_rate_bpm}bpm`);
      }

      if (topic.endsWith('/telemetry')) await handleTelemetry(topic, data);
      if (topic.endsWith('/status')) await handleStatus(topic, data);
    } catch (error) {
      mqttStatus.lastError = error.message;
      console.error('[MQTT] Message processing failed:', error.message);
    }
  });
}

async function handleTelemetry(topic, data) {
  const telemetry = normalizeTelemetry(data, topic);
  const collar = firstRow(
    await query('SELECT * FROM collars WHERE device_id = $1', [
      telemetry.device_id
    ])
  );
  if (!collar) {
    console.log(`[MQTT] Unknown collar device: ${telemetry.device_id} - adding to inventory`);
    await upsertCollarInventory(telemetry);
    return;
  }
  if (!collar.farm_id || !collar.animal_id) {
    console.log(`[MQTT] Collar ${telemetry.device_id} not assigned to farm/animal`);
    await upsertCollarInventory(telemetry);
    return;
  }

  await query(
    `UPDATE collars SET
     battery_pct = $2, wifi_rssi = $3, firmware_version = $4,
     last_seen = NOW(), is_online = TRUE
     WHERE id = $1`,
    [
      collar.id,
      telemetry.battery_pct,
      telemetry.wifi_rssi,
      telemetry.firmware
    ]
  );

  const reading = firstRow(
    await query(
      `INSERT INTO sensor_readings (
        collar_id, animal_id, temp_c, heart_rate_bpm, spo2_pct,
        accel_x, accel_y, accel_z, activity_index, mcu_temp_c,
        behavior, ppr_risk_score, is_anomaly, battery_pct, wifi_rssi,
        recorded_at
       )
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,COALESCE(to_timestamp($16), NOW()))
       RETURNING *`,
      [
        collar.id,
        collar.animal_id,
        telemetry.temp_c,
        telemetry.heart_rate_bpm,
        telemetry.spo2_pct,
        telemetry.accel_x,
        telemetry.accel_y,
        telemetry.accel_z,
        telemetry.activity_index,
        telemetry.mcu_temp_c,
        telemetry.behavior,
        telemetry.ppr_risk_score,
        telemetry.is_anomaly,
        telemetry.battery_pct,
        telemetry.wifi_rssi,
        telemetry.ts
      ]
    )
  );

  // Broadcast to all clients subscribed to this farm
  broadcastToFarm(collar.farm_id, { type: 'reading', data: reading });

  // Evaluate alerts
  const threshold = await getThreshold(collar);
  await evaluateAlerts({ collar, reading, threshold });
}

async function handleStatus(topic, data) {
  const topicDeviceId = topic.split('/')[1];
  const status = {
    device_id: data.device_id ?? topicDeviceId,
    is_online: data.is_online ?? true,
    battery_pct: numberOrNull(data.battery_pct),
    wifi_rssi: numberOrNull(data.wifi_rssi),
    firmware: data.firmware ?? data.firmware_version ?? null
  };
  const collar = firstRow(
    await query(
      `INSERT INTO collars (
        device_id, is_online, last_seen, battery_pct, wifi_rssi, firmware_version
       )
       VALUES ($1,$2,NOW(),$3,$4,$5)
       ON CONFLICT (device_id) DO UPDATE SET
        is_online = EXCLUDED.is_online,
        last_seen = NOW(),
        battery_pct = COALESCE(EXCLUDED.battery_pct, collars.battery_pct),
        wifi_rssi = COALESCE(EXCLUDED.wifi_rssi, collars.wifi_rssi),
        firmware_version = COALESCE(EXCLUDED.firmware_version, collars.firmware_version)
       RETURNING *`,
      [
        status.device_id,
        status.is_online,
        status.battery_pct,
        status.wifi_rssi,
        status.firmware
      ]
    )
  );
  if (collar?.farm_id) {
    broadcastToFarm(collar.farm_id, { type: 'collar_status', data: collar });
  }
}

async function upsertCollarInventory(telemetry) {
  await query(
    `INSERT INTO collars (
      device_id, is_online, last_seen, battery_pct, wifi_rssi, firmware_version
     )
     VALUES ($1,TRUE,NOW(),$2,$3,$4)
     ON CONFLICT (device_id) DO UPDATE SET
      is_online = TRUE,
      last_seen = NOW(),
      battery_pct = COALESCE(EXCLUDED.battery_pct, collars.battery_pct),
      wifi_rssi = COALESCE(EXCLUDED.wifi_rssi, collars.wifi_rssi),
      firmware_version = COALESCE(EXCLUDED.firmware_version, collars.firmware_version)`,
    [
      telemetry.device_id,
      telemetry.battery_pct,
      telemetry.wifi_rssi,
      telemetry.firmware
    ]
  );
}

function normalizeTelemetry(data, topic) {
  const topicDeviceId = topic.split('/')[1];
  const tempC = numberOrNull(data.temp_c ?? data.temperature);
  const heartRate = numberOrNull(data.heart_rate_bpm ?? data.heart_rate);
  const spo2 = numberOrNull(data.spo2_pct ?? data.spo2);
  const acceleration = numberOrNull(data.acceleration);
  const accelX = numberOrNull(data.accel_x) ?? 0;
  const accelY = numberOrNull(data.accel_y) ?? 0;
  const accelZ = numberOrNull(data.accel_z) ?? acceleration ?? 0;
  const activityIndex =
    numberOrNull(data.activity_index) ?? activityFromMotion(data.steps, acceleration);
  const riskScore =
    numberOrNull(data.ppr_risk_score) ??
    calculateRiskScore({
      tempC,
      heartRate,
      activityIndex,
      highTemp: data.high_temp,
      highHeartRate: data.high_heart_rate,
      lowHeartRate: data.low_heart_rate
    });

  return {
    device_id: data.device_id ?? topicDeviceId,
    temp_c: tempC ?? 0,
    heart_rate_bpm: heartRate ?? 0,
    spo2_pct: spo2 ?? -1,
    accel_x: accelX,
    accel_y: accelY,
    accel_z: accelZ,
    activity_index: activityIndex,
    mcu_temp_c: numberOrNull(data.mcu_temp_c) ?? 0,
    behavior: data.behavior ?? behaviorFromActivity(activityIndex),
    ppr_risk_score: riskScore,
    is_anomaly: Boolean(data.is_anomaly ?? riskScore >= 60),
    battery_pct: numberOrNull(data.battery_pct),
    wifi_rssi: numberOrNull(data.wifi_rssi),
    firmware: data.firmware ?? data.firmware_version ?? null,
    ts: numberOrNull(data.ts)
  };
}

function numberOrNull(value) {
  if (value === null || value === undefined || value === '') return null;
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : null;
}

function activityFromMotion(steps, acceleration) {
  const stepCount = numberOrNull(steps) ?? 0;
  const accel = numberOrNull(acceleration) ?? 0;
  return Math.max(0, Math.min(100, Math.round(stepCount * 2 + Math.max(0, accel - 9.8) * 8)));
}

function behaviorFromActivity(activityIndex) {
  if (activityIndex <= 15) return 'resting';
  if (activityIndex <= 65) return 'grazing';
  return 'running';
}

function calculateRiskScore({
  tempC,
  heartRate,
  activityIndex,
  highTemp,
  highHeartRate,
  lowHeartRate
}) {
  let score = 0;
  if (highTemp || tempC >= 40) score += 45;
  else if (tempC >= 39.7) score += 25;
  if (highHeartRate || lowHeartRate || heartRate >= 120 || heartRate <= 50) {
    score += 25;
  }
  if (activityIndex <= 10) score += 30;
  else if (activityIndex <= 20) score += 15;
  return Math.max(0, Math.min(100, score));
}
