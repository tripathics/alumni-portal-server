import { Router } from 'express';
import { getAlumni } from '../controllers/alumni.controller.js';

const router = Router();

router.get('/', getAlumni);

export default router;
