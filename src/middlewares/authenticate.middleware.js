import { verifyToken } from '../utils/jwt.util.js';
import User from '../models/user.model.js';
import logger from '../config/logger.config.js';

const authenticate = async (req, res, next) => {
  const token = req.cookies.auth;
  if (!token) {
    return res.status(401).json({ message: 'Token not found' });
  }

  try {
    const payload = verifyToken(token);
    const user = await User.findById(payload.id);
    if (!user) {
      throw new Error('Invalid JWT');
    }
    req.user = user;
    next();
  } catch (err) {
    if (err.message === 'Token expired') {
      return res.status(401).json({ message: 'Token expired' });
    }
    logger.error(err.message);
    res.status(401).json({ message: 'Invalid token' });
  }
};

export default authenticate;
