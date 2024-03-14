import './src/config/dotenv.config.js';
import app from './src/config/express.config.js';
import db from './src/config/db.config.js';
import logger from './src/config/logger.config.js';
import transporter from './src/config/nodemailer.config.js';

const PORT = process.env.PORT || 3000;

app.listen(PORT, async () => {
  try {
    db.connect();
    logger.info('Connected to the database');

    transporter.verify((error) => {
      if (error) {
        logger.error(`SMTP connection failed: ${error.message}`);
        return;
      }
      logger.info('SMTP connection verified! Ready for emails');
    });

    logger.info(`Server is running on port ${PORT}`);
  } catch (err) {
    logger.error(`Database connection failed: ${err.message}`);
  }
});

app.get('/', (req, res) => {
  res.send('Hello World!');
});
