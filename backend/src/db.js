import pg from 'pg';
import { config } from './config.js';

export const pool = new pg.Pool({
  connectionString: config.databaseUrl,
  ssl: shouldUseSsl(config.databaseUrl) ? { rejectUnauthorized: false } : false,
  connectionTimeoutMillis: 10000
});

export async function query(text, params = []) {
  const result = await pool.query(text, params);
  return result;
}

export function firstRow(result) {
  return result.rows[0] ?? null;
}

function shouldUseSsl(databaseUrl) {
  return databaseUrl?.includes('supabase.co') || databaseUrl?.includes('sslmode=require');
}
