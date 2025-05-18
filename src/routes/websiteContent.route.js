import { Router } from 'express';
import {
  getHeroContent,
  getMessage,
} from '../controllers/websiteContent.controller.js';

const router = Router();

router.get('/hero', getHeroContent);
router.get('/messages', getMessage);

export default router;
