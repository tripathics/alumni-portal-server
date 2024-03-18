import multer from 'multer';
import storage from '../config/storage.config.js';

export const updateAvatarFile = multer({
  storage,
  limits: { fileSize: 2 * 1024 * 1024 }, // 2MB
}).single('avatar');

export const updateSignFile = multer({
  storage,
  limits: { fileSize: 200 * 1024 }, // 200KB
}).single('sign');
