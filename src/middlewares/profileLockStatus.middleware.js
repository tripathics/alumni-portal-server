import Profile from '../models/profile.model.js';
import ApiError from '../utils/ApiError.util.js';

export const profileLockStatus = async (req, res, next) => {
  const {
    tokenPayload: { id: userId },
  } = req;
  try {
    const profileLocked = await Profile.profileStatus(userId);
    req.profile_locked = profileLocked;
    next();
  } catch (error) {
    next(error);
  }
};

export const ensureProfileUnlocked = async (req, res, next) => {
  profileLockStatus(req, res, () => {
    if (req.profile_locked) {
      throw new ApiError(403, 'Profile', 'Profile is locked');
    }
    next();
  });
};
