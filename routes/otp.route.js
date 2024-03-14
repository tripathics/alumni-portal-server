import { Router } from 'express';
import { generate, verify } from '../controllers/otp.controller.js';

const router = Router();

router.post('/generate', generate);
router.post('/verify', verify);

export default router;
