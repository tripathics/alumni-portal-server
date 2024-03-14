import express from 'express';
import cookieParser from 'cookie-parser';
import routes from '../routes/index.route.js';
import errorHandler from '../middlewares/error.middleware.js';

const app = express();

app.use(cookieParser());
app.use(express.json());
app.use('/api', routes);
app.use(errorHandler);

export default app;
