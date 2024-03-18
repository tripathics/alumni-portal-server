import { Router } from 'express';
import userRoute from './user.route.js';
import otpRoute from './otp.route.js';
import mediaRoute from './media.route..js';
import alumniRoute from './alumni.route.js';

const router = Router();

router.use('/media', mediaRoute);
router.use('/api/users', userRoute);
router.use('/api/otp', otpRoute);
router.use('/api/alumni', alumniRoute);

export default router;
