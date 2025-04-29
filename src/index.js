import './config/dotenv.config.js';
import app from './config/express.config.js';
import logger from './config/logger.config.js';
import { verifyDbConnection } from './config/db.config.js';
import * as db from './config/nodemailer.config.js';

const PORT = process.env.PORT || 3000;

app.listen(PORT, async () => {
  try {
    await verifyDbConnection();
    logger.info('Connected to the database');

    await db.verifyTransporterConnection();
    logger.info('SMTP connection verified! Ready for emails');

    logger.info(
      `Server is running on port ${PORT} on ${process.env.NODE_ENV} env`,
    );
  } catch (err) {
    logger.error(err.message);
  }
});
