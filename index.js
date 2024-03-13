import dotenv from 'dotenv';
import db from './config/db.config.js';
import app from './config/express.config.js';
import logger from './config/logger.config.js';

dotenv.config();

const PORT = process.env.PORT || 3000;

app.listen(PORT, async () => {
  try {
    db.connect();
    logger.info('Connected to the database');
    logger.info(`Server is running on port ${PORT}`);
  } catch (err) {
    logger.error(`Database connection failed: ${err.message}`);
  }
});

app.get('/', (req, res) => {
  res.send('Hello World!');
});
