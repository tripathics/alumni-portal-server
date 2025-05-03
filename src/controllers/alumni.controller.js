import MembershipApplications from '../models/membershipApplication.model.js';
import Alumni from '../models/alumni.model.js';

import Profile from '../models/profile.model.js';
import { createTimestampedSignUrl } from '../utils/media.util.js';

export const prefillMembershipForm = async (req, res, next) => {
  if (req.profile_locked) {
    return res
      .status(403)
      .json({ message: 'Membership application is pending for approval' });
  }
  try {
    const profile = await Profile.findProfileWithEducationAtNITAP(
      req.tokenPayload.email,
    );
    if (!profile) {
      res.status(403).json({ message: 'Profile is incomplete' });
    } else {
      res.status(200).json(profile);
    }
  } catch (error) {
    next(error);
  }
};

/**
 * Public API to GET alumni list
 */
export const getAlumni = async (req, res, next) => {
  try {
    const result = await Alumni.find();
    res.json(result);
  } catch (error) {
    next(error);
  }
};

export const submitMembershipForm = async (req, res, next) => {
  const { tokenPayload, body: membershipFormData } = req;

  if (!membershipFormData.sign) {
    return res.status(400).json({ message: 'Signature is required' });
  }
  membershipFormData.sign = createTimestampedSignUrl(membershipFormData.sign);
  try {
    const application = await MembershipApplications.create(
      tokenPayload.id,
      membershipFormData,
    );
    res.status(201).json({
      success: true,
      message: 'Application submitted successfully',
      application,
    });
  } catch (error) {
    next(error);
  }
};

export const getPastApplications = async (req, res, next) => {
  const { id } = req.tokenPayload;
  const filters = { 'membership_applications.user_id': id };
  try {
    const pastApplications = await MembershipApplications.find(filters);
    res.status(200).json(pastApplications);
  } catch (error) {
    next(error);
  }
};

export const getApplication = async (req, res, next) => {
  const {
    params: { id },
    tokenPayload: { id: userId },
  } = req;
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
