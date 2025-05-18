import { Router } from 'express';
import {
  assignUserRoles,
  changeUserPassword,
  deleteUserAccount,
  getMembershipApplicationById,
  getMembershipApplications,
  getUsers,
  revokeUserRoles,
  updateHeroContent,
  updateMembershipApplicationStatus,
  updateMessages,
} from '../controllers/admin.controller.js';

const router = Router();

router.patch('/content/hero', updateHeroContent);
// TODO: director message and president messages (with designation)
router.patch('/content/messages', updateMessages);
// TODO: Alumni office details (address, phone, email)

router.get('/membership-applications', getMembershipApplications);
router.get('/membership-applications/:id', getMembershipApplicationById);
router.patch('/membership-applications/:id', updateMembershipApplicationStatus);

router.get('/users', getUsers);
router.patch('/users/change-password', changeUserPassword);
router.patch('/users/delete-account', deleteUserAccount);
router.patch('/users/assign-roles', assignUserRoles);
router.patch('/users/revoke-roles', revokeUserRoles);

export default router;
