import MembershipApplications from '../models/membershipApplication.model.js';
import Profile from '../models/profile.model.js';

export const prefillMembershipForm = async (req, res, next) => {
  if (req.user.profile_locked) {
    return res.status(403).json({ message: 'Membership application is already pending for approval' });
  }
  try {
    const profile = await Profile.findProfileWithEducationAtNITAP(req.user.email);
    if (!profile) {
      return res.status(404).json({ message: 'Complete your profile with education details at NIT Arunachal Pradesh to apply for membership' });
    }
    res.status(200).json(profile);
  } catch (error) {
    next(error);
  }
};

export const submitMembershipForm = async (req, res, next) => {
  const { user, body: membershipFormData } = req;
  if (user.profile_locked) {
    return res.status(403).json({ message: 'Profile is locked' });
  }

  const sign = req.file?.filename;

  if (!sign) {
    return res.status(400).json({ message: 'Signature is required' });
  }
  try {
    await MembershipApplications.create(user.id, { ...membershipFormData, sign });
    res.status(201).json({ success: true, message: 'Application submitted successfully' });
  } catch (error) {
    next(error);
  }
};

export const getPastApplications = async (req, res, next) => {
  const { id } = req.user;
  const filters = { 'membership_applications.user_id': id };
  try {
    const pastApplications = await MembershipApplications.find(filters);
    res.status(200).json(pastApplications);
  } catch (error) {
    next(error);
  }
};

export const getApplication = async (req, res, next) => {
  const { params: { id }, user: { id: userId } } = req;
  try {
    const application = await MembershipApplications.findById(id);
    if (application.user_id !== userId) {
      return res.status(403).json({ message: 'Unauthorized' });
    }
    res.status(200).json(application);
  } catch (error) {
    next(error);
  }
};
