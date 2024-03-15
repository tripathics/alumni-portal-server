import { Router } from 'express';
import authenticate from '../middlewares/authenticate.middleware.js';
import {
  login, register, readProfile, updateProfile, logout,
} from '../controllers/user.controller.js';

const router = Router();

router.post('/register', register);
router.post('/login', login);
router.post('/logout', logout);
router.get('/profile', authenticate, readProfile);
router.post('/update-profile', authenticate, updateProfile);

export default router;
