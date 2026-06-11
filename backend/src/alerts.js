import { query, firstRow } from './db.js';
import { broadcastToFarm } from './wsHub.js';

export async function getThreshold(collar) {
  const animalThreshold = await query(
    `SELECT * FROM alert_thresholds
     WHERE animal_id = $1
     ORDER BY id
     LIMIT 1`,
    [collar.animal_id]
  );
  if (animalThreshold.rows.length) return firstRow(animalThreshold);

  const farmThreshold = await query(
    `SELECT * FROM alert_thresholds
     WHERE farm_id = $1 AND animal_id IS NULL
     ORDER BY id
     LIMIT 1`,
    [collar.farm_id]
  );
  if (farmThreshold.rows.length) return firstRow(farmThreshold);

  const created = await query(
    `INSERT INTO alert_thresholds (farm_id)
     VALUES ($1)
     RETURNING *`,
    [collar.farm_id]
  );
  return firstRow(created);
}

export async function evaluateAlerts({ collar, reading, threshold }) {
  const alerts = [];
  const temp = Number(reading.temp_c);
  const activity = Number(reading.activity_index ?? 100);
  const risk = Number(reading.ppr_risk_score ?? 0);

  if (temp >= Number(threshold.temp_high_c) && activity <= Number(threshold.activity_low_pct)) {
    alerts.push(await insertAlert({
      collar,
      type: 'high_temp',
      severity: 'critical',
      message: `Fever detected: ${temp.toFixed(1)}C with low activity (${activity}%).`,
      reading
    }));
  }

  if (risk >= Number(threshold.ppr_risk_threshold)) {
    alerts.push(await insertAlert({
      collar,
      type: 'ppr_risk',
      severity: 'critical',
      message: `PPR risk score ${risk}/100 crossed the configured threshold.`,
      reading
    }));
  }

  for (const alert of alerts) {
    broadcastToFarm(collar.farm_id, { type: 'alert', data: alert });
  }
}

async function insertAlert({ collar, type, severity, message, reading }) {
  const result = await query(
    `INSERT INTO alerts (
       collar_id, animal_id, farm_id, alert_type, severity, message,
       temp_at_alert, hr_at_alert, risk_score
     )
     VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9)
     RETURNING *`,
    [
      collar.id,
      collar.animal_id,
      collar.farm_id,
      type,
      severity,
      message,
      reading.temp_c,
      reading.heart_rate_bpm,
      reading.ppr_risk_score
    ]
  );
  return firstRow(result);
}
