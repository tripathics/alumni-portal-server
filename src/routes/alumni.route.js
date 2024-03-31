import { Router } from 'express';
import { updateSignFile } from '../middlewares/media.middleware.js';
import {
  prefillMembershipForm, submitMembershipForm, getPastApplications, getApplication,
} from '../controllers/alumni.controller.js';

const router = Router();

router.get('/membership-prefill', prefillMembershipForm);
router.post('/membership', updateSignFile, submitMembershipForm);

router.get('/past-applications', getPastApplications);
router.get('/past-applications/:id', getApplication);

export default router;
