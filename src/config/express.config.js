import express from 'express';
import morgan from 'morgan';
import cookieParser from 'cookie-parser';
import cors from 'cors';
import routes from '../routes/index.route.js';
import logger from './logger.config.js';
import { CLIENT_DIR } from './storage.config.js';
import path from 'path';

const app = express();

logger.stream = {
  write: (message) => logger.info(message.trim()),
};
app.use(morgan('dev', { stream: logger.stream }));

if (process.env.NODE_ENV === 'development') {
  app.use(cors({
    origin: (origin, callback) => {
      callback(null, true);
    },
    credentials: true,
  }));
} else if (process.env.NODE_ENV === 'production') {
  app.use(express.static(CLIENT_DIR));
}

app.use(cookieParser());
app.use(express.json());
app.use(routes);

if (process.env.NODE_ENV === 'production') {
  app.get('*', (req, res) => {
    res.sendFile(path.join(CLIENT_DIR, 'index.html'));
  });
}

export default app;
