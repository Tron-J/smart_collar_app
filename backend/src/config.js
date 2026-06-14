import dotenv from 'dotenv';

dotenv.config();

export const config = {
  port: Number(process.env.PORT ?? 8080),
  databaseUrl: process.env.DATABASE_URL,
  supabaseUrl: process.env.SUPABASE_URL,
  supabaseJwtSecret: process.env.SUPABASE_JWT_SECRET,
  mqttUrl: process.env.MQTT_URL ?? 'mqtt://localhost:1883',
  mqttUsername: process.env.MQTT_USERNAME,
  mqttPassword: process.env.MQTT_PASSWORD,
  manufacturerKey: process.env.MANUFACTURER_KEY,
  corsOrigin: process.env.CORS_ORIGIN ?? '*'
};

if (!config.databaseUrl) throw new Error('DATABASE_URL is required');
if (!config.supabaseUrl && !config.supabaseJwtSecret) {
  throw new Error('SUPABASE_URL or SUPABASE_JWT_SECRET is required');
}
