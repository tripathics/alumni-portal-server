import { MulterError } from 'multer';
import logger from '../config/logger.config.js';
import { MAX_AVATAR_SIZE, MAX_SIGN_SIZE } from '../config/storage.config.js';

export const notFoundErrorHandler = (req, res) => {
  res.status(404).json({
    message: `Not Found - ${req.method} ${req.originalUrl}`,
  });
};

export const errorHandler = (err, req, res, next) => {
  if (res.headersSent) return next(err);
  let statusCode = err.statusCode || 500;
  let { message } = err;

  if (err instanceof MulterError) {
    statusCode = 400;
    if (err.code === 'LIMIT_FILE_SIZE') {
      if (err.field === 'avatar') {
        message = `File size must be less than ${MAX_AVATAR_SIZE / 1024 / 1024}MB`;
      } else if (err.field === 'sign') {
        message = `File size must be less than ${MAX_SIGN_SIZE / 1024}kB`;
      }
    }
  }

  logger.error(err.message);

  res.status(statusCode).json({
    message,
    stack: process.env.NODE_ENV === 'production' ? null : err.stack,
  });
};
