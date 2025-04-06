import { Router } from 'express';
import {
  getMembershipApplicationById,
  getMembershipApplications,
  getUsers,
  updateHeroContent,
  updateMembershipApplicationStatus,
} from '../controllers/admin.controller.js';

const router = Router();

router.patch('/content/hero', updateHeroContent);

router.get('/membership-applications', getMembershipApplications);
router.get('/membership-applications/:id', getMembershipApplicationById);
router.patch('/membership-applications/:id', updateMembershipApplicationStatus);

router.get('/users', getUsers);

export default router;
