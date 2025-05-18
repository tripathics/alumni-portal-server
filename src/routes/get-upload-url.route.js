import { Router } from 'express';
import { getUploadUrl } from '../controllers/getUploadUrl.js';

const router = Router();

router.get('/:type', getUploadUrl);

export default router;
