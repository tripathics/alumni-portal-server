import { Router } from 'express';
import { getMembershipApplicationById, getMembershipApplications } from '../controllers/admin.controller.js';

const router = Router();

router.get('/membership-applications', getMembershipApplications);
router.get('/membership-application/:userId', getMembershipApplicationById);

export default router;
