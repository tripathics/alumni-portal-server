import multer from 'multer';
import storage from '../config/storage.config.js';

export const updateAvatarFile = multer({
  storage,
  limits: { fileSize: 200 * 200 * 5 },
}).single('avatar');

export const updateSignFile = multer({
  storage,
  limits: { fileSize: 200 * 200 * 5 },
}).single('sign');
