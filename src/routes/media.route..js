import { Router } from 'express';
import { authenticate } from '../middlewares/authenticate.middleware.js';
import { getAvatar, getSign } from '../controllers/media.controller.js';

const router = Router();

router.get('/sign/:filename', authenticate, getSign);
router.get('/avatars/:filename', getAvatar);

export default router;
