import { verifyToken } from '../utils/jwt.util.js';
import User from '../models/user.model.js';
import logger from '../config/logger.config.js';

export const authenticate = async (req, res, next) => {
  const token = req.cookies.auth;
  if (!token) {
    return res.status(401).json({ message: 'Token not found' });
  }

  try {
    const payload = verifyToken(token);
    const user = await User.findById(payload.id);
    if (!user) {
      return res.clearCookie('auth').status(401).json({ message: 'Invalid token' });
    }
    req.user = user;
    next();
  } catch (err) {
    if (err.message === 'Token expired') {
      return res.clearCookie('auth').status(401).json({ message: 'Token expired' });
    }
    logger.error(err.message);
    res.clearCookie('auth').status(401).json({ message: 'Invalid token' });
  }
};

export const authenticateAdmin = async (req, res, next) => {
  authenticate(req, res, () => {
    if (!req.user.role.includes('admin')) {
      return res.status(403).json({ message: 'Forbidden' });
    }
    next();
  });
};
