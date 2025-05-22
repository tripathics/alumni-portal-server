import express from 'express';
import morgan from 'morgan';
import cookieParser from 'cookie-parser';
import cors from 'cors';
import routes from '../routes/index.route.js';
import logger from './logger.config.js';

const app = express();

logger.stream = {
  write: (message) => logger.info(message.trim()),
};
app.use(morgan('dev', { stream: logger.stream }));

if (process.env.NODE_ENV === 'development') {
  app.use(
    cors({
      origin: (origin, callback) => {
        callback(null, true);
      },
      credentials: true,
    }),
  );
} else if (process.env.NODE_ENV === 'production') {
  app.use(
    cors({
      origin: process.env.CLIENT_URL,
      credentials: true,
    }),
  );
}

app.use(cookieParser());
app.use(express.json());
app.use(routes);

export default app;
