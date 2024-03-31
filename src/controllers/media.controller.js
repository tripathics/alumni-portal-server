import { join } from 'path';
import { existsSync } from 'fs';
import { AVATAR_DIR, SIGN_DIR } from '../config/storage.config.js';
import MembershipApplications from '../models/membershipApplication.model.js';

export const getSign = async (req, res, next) => {
  const { params: { filename }, user: { id: userId } } = req;
  try {
    // if user is not admin, check if it's their own sign
    if (!req.user.role.includes('admin')) {
      const isUserSign = await MembershipApplications.verifyUserSign(userId, filename);
      if (!isUserSign) {
        return res.status(403).send('Forbidden');
      }
    }

    const filepath = join(SIGN_DIR, filename);
    if (existsSync(filepath)) {
      res.sendFile(filepath);
    } else {
      res.status(404).send('File not found');
    }
  } catch (err) {
    next(err);
  }
};

export const getAvatar = async (req, res) => {
  const { filename } = req.params;
  const filepath = join(AVATAR_DIR, filename);

  if (existsSync(filepath)) {
    res.sendFile(filepath);
  } else {
    res.status(404).send('File not found');
  }
};
