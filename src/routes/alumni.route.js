import { Router } from 'express';
// import { updateSignFile } from '../middlewares/media.middleware.js';
import {
  prefillMembershipForm, submitMembershipForm, getPastApplications, getApplication,
} from '../controllers/alumni.controller.js';
import { ensureProfileUnlocked, profileLockStatus } from '../middlewares/profileLockStatus.middleware.js';

const router = Router();

router.get('/membership-prefill', profileLockStatus, prefillMembershipForm);
router.post('/membership', ensureProfileUnlocked, submitMembershipForm);

router.get('/past-applications', getPastApplications);
router.get('/past-applications/:id', getApplication);

export default router;
