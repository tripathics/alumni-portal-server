import { Router } from 'express';
import { authenticate } from '../middlewares/authenticate.middleware.js';
import { getSign } from '../controllers/media.controller.js';

const router = Router();

router.get('/sign/:filename', authenticate, getSign);
router.get('/avatar/:filename', (req, res) => {
  const { filename } = req.params;
  res.redirect(`https://${process.env.AWS_S3_BUCKET}.s3.${process.env.AWS_REGION}.amazonaws.com/avatar/${filename}?id=${Date.now()}`);
});

export default router;
