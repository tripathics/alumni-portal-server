import { Router } from 'express';
import authenticate from '../middlewares/authenticate.middleware.js';
import { updateSignFile } from '../middlewares/media.middleware.js';
import { prefillMembershipForm, submitMembershipForm } from '../controllers/alumni.controller.js';

const router = Router();

router.get('/membership-prefill', authenticate, prefillMembershipForm);
router.post('/membership', authenticate, updateSignFile, submitMembershipForm);

export default router;
