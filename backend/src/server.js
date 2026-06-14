import http from 'http';
import cors from 'cors';
import express from 'express';
import helmet from 'helmet';
import path from 'path';
import { fileURLToPath } from 'url';
import { config } from './config.js';
import { router } from './routes.js';
import { attachWebSocket } from './wsHub.js';
import { startMqttWorker } from './mqttWorker.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
app.use(
  helmet({
    contentSecurityPolicy: {
      directives: {
        ...helmet.contentSecurityPolicy.getDefaultDirectives(),
        'img-src': ["'self'", 'data:', 'https://api.qrserver.com'],
        'script-src': ["'self'", "'unsafe-inline'"],
        'style-src': ["'self'", "'unsafe-inline'"]
      }
    }
  })
);
app.use(cors({ origin: config.corsOrigin }));
app.use(express.json({ limit: '1mb' }));
app.use('/manufacturer', express.static(path.join(__dirname, '..', 'public', 'manufacturer')));
app.use((req, _res, next) => {
  console.log(`${req.method} ${req.path}`);
  next();
});
app.use(router);
app.use((error, _req, res, _next) => {
  console.error('Request failed', {
    message: error?.message,
    code: error?.code,
    table: error?.table,
    column: error?.column,
    constraint: error?.constraint,
    detail: error?.detail
  });
  if (error?.code === '23514') {
    return res.status(400).json({ message: 'Invalid value submitted' });
  }
  if (error?.code === '22P02') {
    return res.status(400).json({ message: 'Invalid ID format submitted' });
  }
  res.status(500).json({
    message: 'Internal server error',
    ...(process.env.NODE_ENV !== 'production' && error?.message
      ? { detail: error.message }
      : {})
  });
});

const server = http.createServer(app);
attachWebSocket(server);

server.listen(config.port, () => {
  console.log(`Julius Collar API listening on ${config.port}`);
  startMqttWorker();
});
