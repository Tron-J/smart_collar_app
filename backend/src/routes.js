import express from 'express';
import { requireAuth } from './auth.js';
import { config } from './config.js';
import { firstRow, pool, query } from './db.js';
import { getMqttStatus } from './mqttWorker.js';

export const router = express.Router();

router.get('/health', (_req, res) => {
  res.json({ ok: true, mqtt: getMqttStatus() });
});

router.get('/health/mqtt', (_req, res) => {
  const mqtt = getMqttStatus();
  res.status(mqtt.isConnected && mqtt.isSubscribed ? 200 : 503).json({
    ok: mqtt.isConnected && mqtt.isSubscribed,
    data: mqtt
  });
});

router.get('/health/db', async (_req, res, next) => {
  try {
    const result = await query(
      `SELECT
        to_regclass('public.farms') AS farms,
        to_regclass('public.animals') AS animals,
        to_regclass('public.collars') AS collars,
        to_regclass('public.alert_thresholds') AS alert_thresholds,
        to_regclass('public.sensor_readings') AS sensor_readings,
        to_regclass('public.alerts') AS alerts`
    );
    res.json({ ok: true, data: firstRow(result) });
  } catch (error) {
    next(error);
  }
});

router.get('/health/farm-write', async (_req, res, next) => {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    await ensurePublicUser(client, {
      id: '00000000-0000-0000-0000-000000000000',
      email: 'health-check@smartcollar.local'
    });
    const result = await client.query(
      `INSERT INTO farms (user_id, name, location, farm_type)
       VALUES ($1,$2,$3,$4)
       RETURNING id, user_id, name, location, farm_type`,
      ['00000000-0000-0000-0000-000000000000', 'Health check farm', 'Health check', 'mixed']
    );
    await client.query('ROLLBACK');
    res.json({ ok: true, data: firstRow(result) });
  } catch (error) {
    try {
      await client.query('ROLLBACK');
    } catch {
      // Ignore rollback failures so the original database error is returned.
    }
    console.error('Farm write health check failed', {
      message: error?.message,
      code: error?.code,
      table: error?.table,
      column: error?.column,
      constraint: error?.constraint,
      detail: error?.detail
    });
    res.status(500).json({
      ok: false,
      error: {
        message: error?.message,
        code: error?.code,
        table: error?.table,
        column: error?.column,
        constraint: error?.constraint,
        detail: error?.detail
      }
    });
  } finally {
    client.release();
  }
});

router.get('/manufacturer/collars', requireManufacturerAccess, async (req, res, next) => {
  try {
    const status = req.query.status === 'all' ? 'all' : 'unpaired';
    const whereClause = status === 'all' ? '' : 'WHERE farm_id IS NULL';
    const result = await query(
      `SELECT
        id, device_id, is_online, last_seen, battery_pct, wifi_rssi,
        firmware_version, created_at, farm_id IS NOT NULL AS is_paired
       FROM collars
       ${whereClause}
       ORDER BY last_seen DESC NULLS LAST, created_at DESC
       LIMIT 200`
    );
    res.json({ data: result.rows });
  } catch (error) {
    next(error);
  }
});

router.use(requireAuth);
router.use(syncAuthenticatedUser);

router.get('/system/version', (_req, res) => {
  res.json({ data: { version: '1.0.0', minimum_supported_version: '1.0.0' } });
});

router.get('/farms', async (req, res, next) => {
  try {
    const result = await query('SELECT * FROM farms WHERE user_id = $1 ORDER BY created_at DESC', [
      req.user.id
    ]);
    res.json({ data: result.rows });
  } catch (error) {
    next(error);
  }
});

router.post('/farms', async (req, res, next) => {
  const client = await pool.connect();
  try {
    const { name, location, farm_type } = req.body;
    if (!name || !farm_type) {
      return res.status(400).json({ message: 'Farm name and type are required' });
    }
    await client.query('BEGIN');
    await ensurePublicUser(client, req.user);
    const result = await client.query(
      `INSERT INTO farms (user_id, name, location, farm_type)
       VALUES ($1,$2,$3,$4)
       RETURNING *`,
      [req.user.id, name, location ?? null, farm_type]
    );
    const farm = firstRow(result);
    await client.query('INSERT INTO alert_thresholds (farm_id) VALUES ($1)', [farm.id]);
    await client.query('COMMIT');
    res.status(201).json({ data: farm });
  } catch (error) {
    try {
      await client.query('ROLLBACK');
    } catch {
      // Ignore rollback failures so the original request error is reported.
    }
    next(error);
  } finally {
    client.release();
  }
});

router.get('/farms/:farmId/animals', async (req, res, next) => {
  try {
    const result = await query(
      `SELECT animals.* FROM animals
       JOIN farms ON farms.id = animals.farm_id
       WHERE animals.farm_id = $1 AND farms.user_id = $2
       ORDER BY animals.created_at DESC`,
      [req.params.farmId, req.user.id]
    );
    res.json({ data: result.rows });
  } catch (error) {
    next(error);
  }
});

router.post('/farms/:farmId/animals', async (req, res, next) => {
  try {
    const { animal_tag, species, sex, age_months, weight_kg, notes } = req.body;
    const result = await query(
      `INSERT INTO animals (farm_id, animal_tag, species, sex, age_months, weight_kg, notes)
       VALUES ($1,$2,$3,$4,$5,$6,$7)
       RETURNING *`,
      [req.params.farmId, animal_tag, species, sex, age_months ?? null, weight_kg ?? null, notes ?? null]
    );
    res.status(201).json({ data: firstRow(result) });
  } catch (error) {
    next(error);
  }
});

router.post('/farms/:farmId/animals-with-collar', async (req, res, next) => {
  const client = await pool.connect();
  try {
    const {
      species,
      sex,
      age_months,
      weight_kg,
      notes,
      device_id
    } = req.body;

    if (!species || !sex || !device_id) {
      return res.status(400).json({ message: 'Animal details and collar ID are required' });
    }
    const deviceId = device_id.trim();

    await client.query('BEGIN');

    const farm = firstRow(
      await client.query('SELECT id FROM farms WHERE id = $1 AND user_id = $2', [
        req.params.farmId,
        req.user.id
      ])
    );
    if (!farm) {
      await client.query('ROLLBACK');
      return res.status(404).json({ message: 'Farm not found for this account' });
    }

    const existingCollar = firstRow(
      await client.query('SELECT * FROM collars WHERE device_id = $1 FOR UPDATE', [
        deviceId
      ])
    );
    if (existingCollar?.farm_id && existingCollar.farm_id !== req.params.farmId) {
      await client.query('ROLLBACK');
      return res.status(409).json({ message: 'Collar is already paired to another farm' });
    }

    const animal = firstRow(
      await client.query(
        `INSERT INTO animals (farm_id, animal_tag, species, sex, age_months, weight_kg, notes)
         VALUES ($1,$2,$3,$4,$5,$6,$7)
         RETURNING *`,
        [
          req.params.farmId,
          deviceId,
          species,
          sex,
          age_months ?? null,
          weight_kg ?? null,
          notes ?? null
        ]
      )
    );

    const collar = firstRow(
      existingCollar
        ? await client.query(
            `UPDATE collars
             SET farm_id = $1, animal_id = $2
             WHERE device_id = $3
             RETURNING *`,
            [req.params.farmId, animal.id, deviceId]
          )
        : await client.query(
            `INSERT INTO collars (device_id, farm_id, animal_id)
             VALUES ($1,$2,$3)
             RETURNING *`,
            [deviceId, req.params.farmId, animal.id]
          )
    );

    await client.query('COMMIT');
    res.status(201).json({ data: { animal, collar } });
  } catch (error) {
    try {
      await client.query('ROLLBACK');
    } catch {
      // Ignore rollback failures so the original request error is reported.
    }
    next(error);
  } finally {
    client.release();
  }
});

router.get('/animals/:id', async (req, res, next) => {
  try {
    const result = await query('SELECT * FROM animals WHERE id = $1', [req.params.id]);
    const animal = firstRow(result);
    if (!animal) return res.status(404).json({ message: 'Animal not found' });
    res.json({ data: animal });
  } catch (error) {
    next(error);
  }
});

router.get('/farms/:farmId/collars', async (req, res, next) => {
  try {
    const result = await query('SELECT * FROM collars WHERE farm_id = $1 ORDER BY created_at DESC', [
      req.params.farmId
    ]);
    res.json({ data: result.rows });
  } catch (error) {
    next(error);
  }
});

router.post('/collars/pair', async (req, res, next) => {
  try {
    const { device_id, farm_id, animal_id } = req.body;
    const animal = firstRow(
      await query(
        `SELECT animals.id FROM animals
         JOIN farms ON farms.id = animals.farm_id
         WHERE animals.id = $1 AND animals.farm_id = $2 AND farms.user_id = $3`,
        [animal_id, farm_id, req.user.id]
      )
    );
    if (!animal) {
      return res.status(404).json({ message: 'Animal or farm not found for this account' });
    }

    const existing = await query('SELECT * FROM collars WHERE device_id = $1', [device_id]);
    let collar = firstRow(existing);
    if (collar?.farm_id) {
      return res.status(409).json({ message: 'Collar is already paired' });
    }
    const result = collar
      ? await query(
          `UPDATE collars SET farm_id = $1, animal_id = $2 WHERE device_id = $3 RETURNING *`,
          [farm_id, animal_id, device_id]
        )
      : await query(
          `INSERT INTO collars (device_id, farm_id, animal_id)
           VALUES ($1,$2,$3)
           RETURNING *`,
          [device_id, farm_id, animal_id]
        );
    res.status(201).json({ data: firstRow(result) });
  } catch (error) {
    next(error);
  }
});

router.patch('/collars/:id/disconnect', async (req, res, next) => {
  try {
    const result = await query(
      `UPDATE collars SET farm_id = NULL, animal_id = NULL
       WHERE id = $1
       AND farm_id IN (SELECT id FROM farms WHERE user_id = $2)
       RETURNING *`,
      [req.params.id, req.user.id]
    );
    const collar = firstRow(result);
    if (!collar) return res.status(404).json({ message: 'Collar not found for this account' });
    res.json({ data: collar });
  } catch (error) {
    next(error);
  }
});

router.get('/collars/:id/status', async (req, res, next) => {
  try {
    const result = await query(
      'SELECT id, device_id, is_online, last_seen, battery_pct, wifi_rssi, firmware_version FROM collars WHERE id = $1',
      [req.params.id]
    );
    res.json({ data: firstRow(result) });
  } catch (error) {
    next(error);
  }
});

router.get('/animals/:id/readings/latest', async (req, res, next) => {
  try {
    const result = await query(
      'SELECT * FROM sensor_readings WHERE animal_id = $1 ORDER BY recorded_at DESC LIMIT 1',
      [req.params.id]
    );
    res.json({ data: firstRow(result) });
  } catch (error) {
    next(error);
  }
});

router.get('/animals/:id/readings', async (req, res, next) => {
  try {
    const limit = Math.min(Number(req.query.limit ?? 500), 1000);
    const result = await query(
      `SELECT * FROM sensor_readings
       WHERE animal_id = $1
       AND ($2::timestamptz IS NULL OR recorded_at >= $2)
       AND ($3::timestamptz IS NULL OR recorded_at <= $3)
       ORDER BY recorded_at ASC
       LIMIT $4`,
      [req.params.id, req.query.from ?? null, req.query.to ?? null, limit]
    );
    res.json({ data: result.rows });
  } catch (error) {
    next(error);
  }
});

router.get('/farms/:farmId/alerts', async (req, res, next) => {
  try {
    const resolved = req.query.resolved;
    const result = await query(
      `SELECT * FROM alerts
       WHERE farm_id = $1
       AND ($2::boolean IS NULL OR is_resolved = $2)
       ORDER BY created_at DESC`,
      [req.params.farmId, resolved ?? null]
    );
    res.json({ data: result.rows });
  } catch (error) {
    next(error);
  }
});

router.get('/alerts/:id', async (req, res, next) => {
  try {
    const result = await query('SELECT * FROM alerts WHERE id = $1', [req.params.id]);
    res.json({ data: firstRow(result) });
  } catch (error) {
    next(error);
  }
});

router.patch('/alerts/:id/resolve', async (req, res, next) => {
  try {
    const result = await query(
      `UPDATE alerts SET is_resolved = TRUE, resolved_at = NOW()
       WHERE id = $1
       RETURNING *`,
      [req.params.id]
    );
    res.json({ data: firstRow(result) });
  } catch (error) {
    next(error);
  }
});

router.get('/farms/:farmId/thresholds', async (req, res, next) => {
  try {
    const result = await query('SELECT * FROM alert_thresholds WHERE farm_id = $1 ORDER BY animal_id NULLS FIRST', [
      req.params.farmId
    ]);
    res.json({ data: result.rows });
  } catch (error) {
    next(error);
  }
});

router.patch('/thresholds/:id', async (req, res, next) => {
  try {
    const result = await query(
      `UPDATE alert_thresholds SET
       temp_high_c = $2, temp_low_c = $3, hr_high_bpm = $4, hr_low_bpm = $5,
       activity_low_pct = $6, ppr_risk_threshold = $7
       WHERE id = $1
       RETURNING *`,
      [
        req.params.id,
        req.body.temp_high_c,
        req.body.temp_low_c,
        req.body.hr_high_bpm,
        req.body.hr_low_bpm,
        req.body.activity_low_pct,
        req.body.ppr_risk_threshold
      ]
    );
    res.json({ data: firstRow(result) });
  } catch (error) {
    next(error);
  }
});

function requireManufacturerAccess(req, res, next) {
  if (!config.manufacturerKey) return next();
  const providedKey = req.headers['x-manufacturer-key'] ?? req.query.key;
  if (providedKey === config.manufacturerKey) return next();
  res.status(401).json({ message: 'Manufacturer key is required' });
}

async function syncAuthenticatedUser(req, _res, next) {
  const client = await pool.connect();
  try {
    await ensurePublicUser(client, req.user);
    next();
  } catch (error) {
    next(error);
  } finally {
    client.release();
  }
}

async function ensurePublicUser(client, user) {
  const tableResult = await client.query("SELECT to_regclass('public.users') AS users_table");
  if (!firstRow(tableResult)?.users_table) return;

  const columnsResult = await client.query(
    `SELECT column_name, is_nullable, column_default, data_type
     FROM information_schema.columns
     WHERE table_schema = 'public' AND table_name = 'users'`
  );
  const columns = columnsResult.rows;
  const columnNames = new Set(columns.map((column) => column.column_name));
  if (!columnNames.has('id')) return;

  const values = { id: user.id };
  if (columnNames.has('email')) values.email = user.email ?? null;
  if (columnNames.has('full_name')) values.full_name = user.email ?? 'Smart Collar user';
  if (columnNames.has('name')) values.name = user.email ?? 'Smart Collar user';
  if (columnNames.has('display_name')) values.display_name = user.email ?? 'Smart Collar user';
  if (columnNames.has('password_hash')) values.password_hash = 'supabase-auth';
  if (columnNames.has('auth_provider')) values.auth_provider = 'supabase';
  if (columnNames.has('provider')) values.provider = 'google';
  if (columnNames.has('username')) values.username = user.email ?? user.id;
  if (columnNames.has('created_at')) values.created_at = new Date();
  if (columnNames.has('updated_at')) values.updated_at = new Date();

  for (const column of columns) {
    if (
      column.column_name !== 'id' &&
      column.is_nullable === 'NO' &&
      column.column_default == null &&
      !Object.hasOwn(values, column.column_name)
    ) {
      values[column.column_name] = fallbackUserValue(column, user);
    }
  }

  const insertColumns = Object.keys(values);
  const placeholders = insertColumns.map((_, index) => `$${index + 1}`);
  const updateColumns = insertColumns.filter((column) => column !== 'id' && column !== 'created_at');
  const conflictAction = updateColumns.length
    ? `DO UPDATE SET ${updateColumns.map((column) => `${column} = EXCLUDED.${column}`).join(', ')}`
    : 'DO NOTHING';

  await client.query(
    `INSERT INTO users (${insertColumns.join(', ')})
     VALUES (${placeholders.join(', ')})
     ON CONFLICT (id) ${conflictAction}`,
    insertColumns.map((column) => values[column])
  );
}

function fallbackUserValue(column, user) {
  if (column.column_name.endsWith('_at') || column.data_type.includes('timestamp')) return new Date();
  if (column.data_type === 'boolean') return false;
  if (column.data_type === 'integer' || column.data_type === 'bigint' || column.data_type === 'smallint') return 0;
  if (column.data_type === 'numeric' || column.data_type === 'real' || column.data_type === 'double precision') return 0;
  if (column.data_type === 'uuid') return user.id;
  return user.email ?? 'supabase-auth';
}
