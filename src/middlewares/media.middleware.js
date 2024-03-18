import multer from 'multer';
import storage, { MAX_AVATAR_SIZE, MAX_SIGN_SIZE } from '../config/storage.config.js';

export const updateAvatarFile = multer({
  storage,
  limits: { fileSize: MAX_AVATAR_SIZE }, // 2MB
}).single('avatar');

export const updateSignFile = multer({
  storage,
  limits: { fileSize: MAX_SIGN_SIZE }, // 200KB
}).single('sign');
