import { Router } from 'express';
import { getHeroContent } from '../controllers/websiteContent.controller.js';

const router = Router();

router.get('/hero', getHeroContent);

export default router;
