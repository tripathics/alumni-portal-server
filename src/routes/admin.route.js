import { Router } from 'express';
import { getMembershipApplicationById, getMembershipApplications, updateMembershipApplicationStatus } from '../controllers/admin.controller.js';

const router = Router();

router.get('/membership-applications', getMembershipApplications);
router.get('/membership-applications/:id', getMembershipApplicationById);
router.patch('/membership-applications/:id', updateMembershipApplicationStatus);

export default router;
