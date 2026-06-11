import { WebSocketServer } from 'ws';
import { verifyToken } from './auth.js';

const clientsByUser = new Map();
const clientsByFarm = new Map();

export function attachWebSocket(server) {
  const wss = new WebSocketServer({ server, path: '/ws' });

  wss.on('connection', (socket, request) => {
    const url = new URL(request.url, 'http://localhost');
    const token = url.searchParams.get('token');
    try {
      const payload = verifyToken(token);
      socket.userId = payload.sub;
      addClient(clientsByUser, socket.userId, socket);
    } catch {
      socket.close(1008, 'Invalid token');
      return;
    }

    socket.on('message', (message) => {
      try {
        const event = JSON.parse(message.toString());
        if (event.type === 'subscribe_farm' && event.farm_id) {
          socket.farmId = event.farm_id;
          addClient(clientsByFarm, event.farm_id, socket);
        }
      } catch {
        socket.send(JSON.stringify({ type: 'error', message: 'Invalid JSON' }));
      }
    });

    socket.on('close', () => {
      removeClient(clientsByUser, socket.userId, socket);
      if (socket.farmId) removeClient(clientsByFarm, socket.farmId, socket);
    });
  });
}

export function broadcastToFarm(farmId, event) {
  const clients = clientsByFarm.get(farmId);
  if (!clients) return;
  const payload = JSON.stringify(event);
  for (const client of clients) {
    if (client.readyState === client.OPEN) client.send(payload);
  }
}

function addClient(map, key, socket) {
  if (!map.has(key)) map.set(key, new Set());
  map.get(key).add(socket);
}

function removeClient(map, key, socket) {
  const clients = map.get(key);
  if (!clients) return;
  clients.delete(socket);
  if (clients.size === 0) map.delete(key);
}
