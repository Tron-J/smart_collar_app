import { WebSocketServer } from 'ws';
import { verifyToken } from './auth.js';

const clientsByUser = new Map();
const clientsByFarm = new Map();

export function attachWebSocket(server) {
  const wss = new WebSocketServer({ server, path: '/ws' });

  wss.on('connection', async (socket, request) => {
    const url = new URL(request.url, 'http://localhost');
    const token = url.searchParams.get('token');
    try {
      const payload = await verifyToken(token);
      socket.userId = payload.sub;
      addClient(clientsByUser, socket.userId, socket);
      console.log(`[WS] User ${socket.userId} connected (${clientsByUser.size} total users)`);
    } catch {
      console.log('[WS] Connection rejected: invalid token');
      socket.close(1008, 'Invalid token');
      return;
    }

    socket.on('message', (message) => {
      try {
        const event = JSON.parse(message.toString());
        if (event.type === 'subscribe_farm' && event.farm_id) {
          socket.farmId = event.farm_id;
          addClient(clientsByFarm, event.farm_id, socket);
          console.log(`[WS] User ${socket.userId} subscribed to farm ${event.farm_id} (${clientsByFarm.get(event.farm_id)?.size || 0} clients)`);
        }
      } catch {
        socket.send(JSON.stringify({ type: 'error', message: 'Invalid JSON' }));
      }
    });

    socket.on('close', () => {
      console.log(`[WS] User ${socket.userId} disconnected`);
      removeClient(clientsByUser, socket.userId, socket);
      if (socket.farmId) {
        removeClient(clientsByFarm, socket.farmId, socket);
        console.log(`[WS] User unsubscribed from farm ${socket.farmId}`);
      }
    });
  });
}

export function broadcastToFarm(farmId, event) {
  const clients = clientsByFarm.get(farmId);
  if (!clients || clients.size === 0) {
    // Uncomment for verbose logging: console.log(`[WS] No clients for farm ${farmId}`);
    return;
  }
  const payload = JSON.stringify(event);
  let sentCount = 0;
  for (const client of clients) {
    if (client.readyState === client.OPEN) {
      client.send(payload);
      sentCount++;
    }
  }
  // Log every 50th broadcast to avoid spam
  if (broadcastCounter++ % 50 === 0) {
    console.log(`[WS] Broadcast ${event.type} to ${sentCount} clients for farm ${farmId}`);
  }
}

let broadcastCounter = 0;

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
