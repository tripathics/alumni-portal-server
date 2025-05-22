import { Router } from 'express';
import { authenticate } from '../middlewares/authenticate.middleware.js';
import { getS3Url } from '../utils/media.util.js';
import MembershipApplications from '../models/membershipApplication.model.js';
import ApiError from '../utils/ApiError.util.js';

const router = Router();

router.get('/sign/:filename', authenticate, async (req, res, next) => {
  const {
    params: { filename },
    tokenPayload: { id: userId, role: userRole },
  } = req;
  if (!userRole.inclues('admin')) {
    const isUserSign = await new MembershipApplications().verifyUserSign(
      userId,
      filename,
    );
    if (!isUserSign) {
      return next(new ApiError(403, 'Media', 'Unauthorized'));
    }
  }

  res.redirect(getS3Url(filename, 'sign'));
});
router.get('/avatar/:filename', (req, res) => {
  const { filename } = req.params;
  res.redirect(getS3Url(filename, 'avatar'));
});
router.get('/director/:filename', (req, res) => {
  const { filename } = req.params;
  res.redirect(getS3Url(filename, 'director'));
});

router.get('/hero/:filename', (req, res) => {
  const { filename } = req.params;
  res.redirect(getS3Url(filename, 'hero'));
});

export default router;
