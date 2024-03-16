import { Router } from 'express';
import authenticate from '../middlewares/authenticate.middleware.js';
import {
  login, register, readProfile, updateProfile, logout, updateAvatar, checkEmailExists,
} from '../controllers/user.controller.js';
import { generate } from '../controllers/otp.controller.js';
import { updateAvatarFile } from '../middlewares/media.middleware.js';

const router = Router();

router.post('/register-otp-gen', checkEmailExists, generate);
router.post('/register', register);
router.post('/login', login);
router.post('/logout', logout);
router.get('/profile', authenticate, readProfile);
router.post('/update-profile', authenticate, updateProfile);
router.patch('/update-avatar', authenticate, updateAvatarFile, updateAvatar);

export default router;
