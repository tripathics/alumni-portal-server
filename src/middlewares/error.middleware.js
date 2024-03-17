import logger from '../config/logger.config.js';

export const notFoundErrorHandler = (req, res) => {
  res.status(404).json({
    message: `Not Found - ${req.originalUrl}`,
  });
};

export const errorHandler = (err, req, res, next) => {
  if (res.headersSent) return next(err);
  const statusCode = err.statusCode || 500;

  logger.error(err.message);

  res.status(statusCode).json({
    message: err.message,
    stack: process.env.NODE_ENV === 'production' ? null : err.stack,
  });
};
