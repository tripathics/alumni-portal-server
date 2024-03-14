import { Router } from 'express';
import userRoute from './user.route.js';
import otpRoute from './otp.route.js';

const router = Router();

router.use('/users', userRoute);
router.use('/otp', otpRoute);

export default router;
