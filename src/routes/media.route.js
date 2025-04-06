import { Router } from 'express';
import { authenticate } from '../middlewares/authenticate.middleware.js';
import { getS3Url } from '../utils/media.util.js';

const router = Router();

router.get('/sign/:filename', authenticate, (req, res) => {
  const { filename } = req.params;
  res.redirect(getS3Url(filename, 'sign'));
});
router.get('/avatar/:filename', (req, res) => {
  const { filename } = req.params;
  res.redirect(getS3Url(filename, 'avatar'));
});
router.get('/hero/:filename', (req, res) => {
  const { filename } = req.params;
  res.redirect(getS3Url(filename, 'hero'));
});

export default router;
