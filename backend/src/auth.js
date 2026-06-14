import crypto from 'crypto';
import jwt from 'jsonwebtoken';
import { config } from './config.js';

let jwksCache;

export async function verifyToken(token) {
  if (!token) throw new Error('Missing token');

  const decoded = jwt.decode(token, { complete: true });
  const alg = decoded?.header?.alg;

  if (alg === 'HS256') {
    if (!config.supabaseJwtSecret) {
      throw new Error('SUPABASE_JWT_SECRET is required for HS256 tokens');
    }
    return jwt.verify(token, config.supabaseJwtSecret, {
      algorithms: ['HS256']
    });
  }

  const key = await publicKeyForToken(decoded);
  return jwt.verify(token, key, {
    algorithms: ['ES256', 'RS256']
  });
}

export async function requireAuth(req, res, next) {
  const header = req.headers.authorization ?? '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  if (!token) return res.status(401).json({ message: 'Missing token' });
  try {
    const payload = await verifyToken(token);
    req.user = {
      id: payload.sub,
      email: payload.email,
      role: payload.role
    };
    next();
  } catch {
    res.status(401).json({ message: 'Invalid Supabase token' });
  }
}

async function publicKeyForToken(decoded) {
  const kid = decoded?.header?.kid;
  if (!kid) throw new Error('Token key id is missing');

  const jwks = await loadJwks();
  const jwk = jwks.keys?.find((key) => key.kid === kid);
  if (!jwk) throw new Error('Matching JWT signing key was not found');

  return crypto.createPublicKey({ key: jwk, format: 'jwk' });
}

async function loadJwks() {
  if (jwksCache) return jwksCache;

  const baseUrl = config.supabaseUrl?.replace(/\/$/, '');
  if (!baseUrl) {
    throw new Error('SUPABASE_URL is required for asymmetric JWT tokens');
  }

  const response = await fetch(`${baseUrl}/auth/v1/.well-known/jwks.json`);
  if (!response.ok) {
    throw new Error(`Failed to load Supabase JWKS: ${response.status}`);
  }
  jwksCache = await response.json();
  return jwksCache;
}
