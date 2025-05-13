import Experiences from '../models/experience.model.js';
import ApiError from '../utils/ApiError.util.js';

export const getExperiences = async (req, res, next) => {
  const userId = req.tokenPayload.id;
  try {
    const experienceRecords = await new Experiences().findByUserId(userId);
    res.status(200).json({ success: true, experienceRecords });
  } catch (err) {
    next(err);
  }
};

export const createUpdateExperience = async (req, res, next) => {
  const { tokenPayload, body } = req;
  try {
    await new Experiences().createOrUpdate(tokenPayload.id, body);
    res.status(200).json({ success: true, message: 'Experience updated' });
  } catch (err) {
    next(err);
  }
};

export const deleteExperience = async (req, res, next) => {
  const {
    tokenPayload,
    query: { id },
  } = req;
  try {
    const experienceRecord = await new Experiences().findById(id);
    if (
      experienceRecord.user_id !== tokenPayload.id &&
      !tokenPayload.role.includes('admin')
    ) {
      throw new ApiError(403, 'Unauthorized');
    }
    await new Experiences().delete(id);
    res.status(200).json({ success: true, message: 'Experience deleted' });
  } catch (err) {
    next(err);
  }
};
