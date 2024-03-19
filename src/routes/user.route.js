import { Router } from 'express';
import { authenticate } from '../middlewares/authenticate.middleware.js';
import {
  login, register, readProfile, updateProfile, logout, updateAvatar, checkEmailExists, readUser,
} from '../controllers/user.controller.js';
import { createUpdateEducation, deleteEducation, getEducations } from '../controllers/education.controller.js';
import { createUpdateExperience, deleteExperience, getExperiences } from '../controllers/experience.controller.js';
import { generate } from '../controllers/otp.controller.js';
import { updateAvatarFile } from '../middlewares/media.middleware.js';

const router = Router();

router.get('/u', authenticate, readUser);
router.post('/register-otp-gen', checkEmailExists, generate);
router.post('/register', register);
router.post('/login', login);
router.post('/logout', logout);
router.get('/profile', authenticate, readProfile);
router.post('/update-profile', authenticate, updateProfile);
router.patch('/update-avatar', authenticate, updateAvatarFile, updateAvatar);

router.get('/education', authenticate, getEducations);
router.post('/education', authenticate, createUpdateEducation);
router.delete('/education', authenticate, deleteEducation);

router.get('/experience', authenticate, getExperiences);
router.post('/experience', authenticate, createUpdateExperience);
router.delete('/experience', authenticate, deleteExperience);

export default router;
