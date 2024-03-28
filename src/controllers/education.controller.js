import Educations from '../models/education.model.js';
import ApiError from '../utils/ApiError.util.js';

export const getEducations = async (req, res, next) => {
  const userId = req.user.id;
  try {
    const educationRecords = await Educations.findByUserId(userId);
    res.status(200).json({ success: true, educationRecords });
  } catch (err) {
    next(err);
  }
};

export const createUpdateEducation = async (req, res, next) => {
  const { user, body } = req;
  if (user.profile_locked) {
    return res.status(400).json({ success: false, message: 'Profile is locked' });
  }
  try {
    await Educations.createOrUpdate(user.id, body);
    res.status(200).json({ success: true, message: 'Education updated' });
  } catch (err) {
    next(err);
  }
};

export const deleteEducation = async (req, res, next) => {
  const { user, query: { id } } = req;
  if (user.profile_locked) {
    return res.status(400).json({ success: false, message: 'Profile is locked' });
  }
  try {
    const educationRecord = await Educations.findById(id);
    if (educationRecord.user_id !== user.id && !user.role.includes('admin')) {
      throw new ApiError(403, 'Unauthorized');
    }
    await Educations.delete(id);
    res.status(200).json({ success: true, message: 'Education deleted' });
  } catch (err) {
    next(err);
  }
};
