import { Router } from 'express';
import { getMembershipApplicationByUserId, getMembershipApplications } from '../controllers/admin.controller.js';

const router = Router();

router.get('/membership-applications', getMembershipApplications);
router.get('/membership-applications/:userId', getMembershipApplicationByUserId);

export default router;
