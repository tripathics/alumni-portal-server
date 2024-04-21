import multer from 'multer';
import path from 'path';
import url from 'url';
import fs from 'fs';
import ApiError from '../utils/ApiError.util.js';

const FILENAME = url.fileURLToPath(import.meta.url);
const DIRNAME = path.dirname(FILENAME);

// Ensure the directories for avatars and signs exist
export const CLIENT_DIR = path.join(DIRNAME, '../../dist');
export const AVATAR_DIR = path.join(DIRNAME, '../../media/avatars');
export const SIGN_DIR = path.join(DIRNAME, '../../media/signs');

export const MAX_AVATAR_SIZE = 1024 * 1024 * 2; // 2MB
export const MAX_SIGN_SIZE = 1024 * 200; // 200kB

if (!fs.existsSync(AVATAR_DIR)) fs.mkdirSync(AVATAR_DIR, { recursive: true });
if (!fs.existsSync(SIGN_DIR)) fs.mkdirSync(SIGN_DIR, { recursive: true });

if (process.env.NODE_ENV === 'production' && !fs.existsSync(CLIENT_DIR)) {
  throw new ApiError(500, 'CLIENT', 'Client directory not found!');
}

const storage = multer.diskStorage({
  destination(req, file, cb) {
    if (file.fieldname === 'avatar') {
      cb(null, AVATAR_DIR);
    } else if (file.fieldname === 'sign') {
      cb(null, SIGN_DIR);
    } else {
      cb('Error: Invalid fieldname!');
    }
  },
  filename(req, file, cb) {
    const now = new Date();
    const userId = req.user.id; // Assuming you have the user ID available in the request object
    const extname = path.extname(file.originalname).toLowerCase();
    cb(null, userId + now.getTime() + extname);
  },
  fileFilter(req, file, cb) {
    const filetypes = /png|jpg|jpeg|webp/;
    const mimetype = filetypes.test(file.mimetype);
    const extname = filetypes.test(path.extname(file.originalname).toLowerCase());

    if (mimetype && extname) {
      return cb(null, true);
    }
    cb('Error: Only .png, .jpg, and .webp files are allowed!');
  },
});

export default storage;
