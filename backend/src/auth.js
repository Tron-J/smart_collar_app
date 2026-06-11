import jwt from 'jsonwebtoken';
import { config } from './config.js';

export function verifyToken(token) {
  return jwt.verify(token, config.supabaseJwtSecret);
}

export function requireAuth(req, res, next) {
  const header = req.headers.authorization ?? '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  if (!token) return res.status(401).json({ message: 'Missing token' });
  try {
    const payload = verifyToken(token);
    req.user = {
      id: payload.sub,
      email: payload.email,
      role: payload.role,
    };
    next();
  } catch {
    res.status(401).json({ message: 'Invalid Supabase token' });
  }
}
