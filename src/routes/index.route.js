import { Router } from 'express';
import {
  authenticate,
  authenticateAdmin,
} from '../middlewares/authenticate.middleware.js';
import {
  errorHandler,
  notFoundErrorHandler,
} from '../middlewares/error.middleware.js';
import userRoute from './user.route.js';
import websiteContentRoute from './websiteContent.route.js';
import otpRoute from './otp.route.js';
import mediaRoute from './media.route.js';
import alumniRoute from './alumni.route.js';
import adminRoute from './admin.route.js';
import publicAlumniRoute from './public-alumni.route.js';
import { getUploadUrl } from '../controllers/getUploadUrl.js';

const router = Router();

router.use('/media', mediaRoute);
router.use('/api/nitapalumnicontent', websiteContentRoute);
router.use('/api/users', userRoute);
router.use('/api/otp', otpRoute);
router.get('/api/get-upload-url/:type', authenticate, getUploadUrl);
router.use('/api/alumni', authenticate, alumniRoute);
router.use('/api/public/alumni', publicAlumniRoute);
router.use('/api/admin', authenticateAdmin, adminRoute);

router.use('/media', notFoundErrorHandler);
router.use('/media', errorHandler);
router.use('/api', notFoundErrorHandler);
router.use('/api', errorHandler);

export default router;
