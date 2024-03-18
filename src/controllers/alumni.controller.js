import MembershipApplications from '../models/membershipApplication.model.js';
import Profile from '../models/profile.model.js';

export const prefillMembershipForm = async (req, res, next) => {
  try {
    const profile = await Profile.findProfileWithEducationAtNITAP(req.user.email);
    if (!profile) {
      return res.status(404).json({ message: 'Complete your profile with education details at NIT Arunachal Pradesh to apply for membership' });
    }
    if (profile.profile_locked) {
      return res.status(403).json({ message: 'Membership application is already pending for approval' });
    }
    res.status(200).json(profile);
  } catch (error) {
    next(error);
  }
};

export const submitMembershipForm = async (req, res, next) => {
  const { user: { id: userId, email }, body: membershipFormData } = req;
  const sign = req.file?.filename;

  if (!sign) {
    return res.status(400).json({ message: 'Signature is required' });
  }
  try {
    const profile = await Profile.findByEmail(email);
    if (profile.profile_locked) {
      return res.status(403).json({ message: 'Profile is locked' });
    }

    await MembershipApplications.create(userId, { ...membershipFormData, sign });
    res.status(201).json({ message: 'Membership application submitted' });
  } catch (error) {
    next(error);
  }
};
