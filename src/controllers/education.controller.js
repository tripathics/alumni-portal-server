import Educations from '../models/education.model.js';
import ApiError from '../utils/ApiError.util.js';

export const getEducations = async (req, res, next) => {
  const userId = req.tokenPayload.id;
  try {
    const educationRecords = await Educations.findByUserId(userId);
    res.status(200).json({ success: true, educationRecords });
  } catch (err) {
    next(err);
  }
};

export const getEducationsAtNitap = async (req, res, next) => {
  const userId = req.tokenPayload.id;
  try {
    const educationRecords = await Educations.findNITAPByUserId(userId);
    res.status(200).json({ success: true, educationRecords });
  } catch (err) {
    next(err);
  }
};

export const createUpdateEducation = async (req, res, next) => {
  const { tokenPayload, body } = req;
  try {
    await Educations.createOrUpdate(tokenPayload.id, body);
    res.status(200).json({ success: true, message: 'Education updated' });
  } catch (err) {
    next(err);
  }
};

export const deleteEducation = async (req, res, next) => {
  const {
    tokenPayload,
    query: { id },
  } = req;
  try {
    const educationRecord = await Educations.findById(id);
    if (
      educationRecord.user_id !== tokenPayload.id &&
      !tokenPayload.role.includes('admin')
    ) {
      throw new ApiError(403, 'Unauthorized');
    }
    await Educations.delete(id);
    res.status(200).json({ success: true, message: 'Education deleted' });
  } catch (err) {
    next(err);
  }
};
