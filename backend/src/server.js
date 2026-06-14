import http from 'http';
import cors from 'cors';
import express from 'express';
import helmet from 'helmet';
import { config } from './config.js';
import { router } from './routes.js';
import { attachWebSocket } from './wsHub.js';
import { startMqttWorker } from './mqttWorker.js';

const app = express();
app.use(helmet());
app.use(cors({ origin: config.corsOrigin }));
app.use(express.json({ limit: '1mb' }));
app.use(router);
app.use((error, _req, res, _next) => {
  console.error(error);
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
