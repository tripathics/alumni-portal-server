import { Router } from 'express';
import userRoute from './user.route.js';
import otpRoute from './otp.route.js';
import mediaRoute from './media.route..js';

const router = Router();

router.use('/api/users', userRoute);
router.use('/api/otp', otpRoute);
router.use('/media', mediaRoute);

export default router;
