import { Router } from 'express';
import { updateSignFile } from '../middlewares/media.middleware.js';
import { prefillMembershipForm, submitMembershipForm } from '../controllers/alumni.controller.js';

const router = Router();

router.get('/membership-prefill', prefillMembershipForm);
router.post('/membership', updateSignFile, submitMembershipForm);

export default router;
