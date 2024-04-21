import './src/config/dotenv.config.js';
import app from './src/config/express.config.js';
import logger from './src/config/logger.config.js';
import { verifyDbConnection } from './src/config/db.config.js';
import { verifyTransporterConnection } from './src/config/nodemailer.config.js';

const PORT = process.env.PORT || 3000;

app.listen(PORT, async () => {
  try {
    await verifyDbConnection();
    logger.info('Connected to the database');

    await verifyTransporterConnection();
    logger.info('SMTP connection verified! Ready for emails');

    logger.info(`Server is running on port ${PORT} on ${process.env.NODE_ENV} env`);
  } catch (err) {
    logger.error(err.message);
  }
});
