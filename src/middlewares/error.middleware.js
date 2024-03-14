import logger from '../config/logger.config.js';

const errorHandler = (err, req, res) => {
  const statusCode = err.statusCode || 500;

  logger.error(err.message);

  res.status(statusCode).json({
    message: err.message,
    stack: process.env.NODE_ENV === 'production' ? null : err.stack,
  });
};

export default errorHandler;
