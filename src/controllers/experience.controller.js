import Experiences from '../models/experience.model.js';
import ApiError from '../utils/ApiError.util.js';

export const getExperiences = async (req, res, next) => {
  const userId = req.user.id;
  try {
    const experienceRecords = await Experiences.findByUserId(userId);
    res.status(200).json({ success: true, experienceRecords });
  } catch (err) {
    next(err);
  }
};

export const createUpdateExperience = async (req, res, next) => {
  const { user, body } = req;
  try {
    await Experiences.createOrUpdate(user.id, body);
    res.status(200).json({ success: true, message: 'Experience updated' });
  } catch (err) {
    next(err);
  }
};

export const deleteExperience = async (req, res, next) => {
  const { user, query: { id } } = req;
  try {
    const experienceRecord = await Experiences.findById(id);
    if (experienceRecord.user_id !== user.id && !user.role.includes('admin')) {
      throw new ApiError(403, 'Unauthorized');
    }
    await Experiences.delete(id);
    res.status(200).json({ success: true, message: 'Experience deleted' });
  } catch (err) {
    next(err);
  }
};
