import { Router } from 'express';
import { authenticateAdmin } from '../middlewares/authenticate.middleware.js';
import userRoute from './user.route.js';
import otpRoute from './otp.route.js';
import mediaRoute from './media.route..js';
import alumniRoute from './alumni.route.js';
import adminRoute from './admin.route.js';

const router = Router();

router.use('/media', mediaRoute);
router.use('/api/users', userRoute);
router.use('/api/otp', otpRoute);
router.use('/api/alumni', alumniRoute);
router.use('/api/admin', authenticateAdmin, adminRoute);

export default router;
