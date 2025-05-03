import { Router } from 'express';
import { authenticate } from '../middlewares/authenticate.middleware.js';
import {
  login,
  register,
  readProfile,
  updateProfile,
  getProfileCompletionStatus,
  logout,
  updateAvatar,
  checkEmailNotExists,
  readUser,
  checkEmailExists,
  updatePassword,
  validateSession,
} from '../controllers/user.controller.js';
import {
  createUpdateEducation,
  deleteEducation,
  getEducationsAtNitap,
  getEducations,
} from '../controllers/education.controller.js';
import {
  createUpdateExperience,
  deleteExperience,
  getExperiences,
} from '../controllers/experience.controller.js';
import { generate } from '../controllers/otp.controller.js';
import { ensureProfileUnlocked } from '../middlewares/profileLockStatus.middleware.js';

const router = Router();

router.get('/auth', authenticate, validateSession);
router.get('/u', authenticate, readUser);
router.get(
  '/profile-completion-status',
  authenticate,
  getProfileCompletionStatus,
);
router.post('/register-otp-gen', checkEmailNotExists, generate);
router.post('/auth-otp-gen', checkEmailExists, generate);
router.post('/update-password', updatePassword);
router.post('/register', register);
router.post('/login', login);
router.post('/logout', logout);
router.get('/profile', authenticate, readProfile);
router.post(
  '/update-profile',
  authenticate,
  ensureProfileUnlocked,
  updateProfile,
);
// router.patch('/update-avatar', authenticate, updateAvatarFile, updateAvatar);
router.patch('/update-avatar', authenticate, updateAvatar);

router.get('/education', authenticate, getEducations);
router.get('/education/nitap', authenticate, getEducationsAtNitap);
router.post(
  '/education',
  authenticate,
  ensureProfileUnlocked,
  createUpdateEducation,
);
router.delete(
  '/education',
  authenticate,
  ensureProfileUnlocked,
  deleteEducation,
);

router.get('/experience', authenticate, getExperiences);
router.post(
  '/experience',
  authenticate,
  ensureProfileUnlocked,
  createUpdateExperience,
);
router.delete(
  '/experience',
  authenticate,
  ensureProfileUnlocked,
  deleteExperience,
);

export default router;
