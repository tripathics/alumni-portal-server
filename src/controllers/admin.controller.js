import MembershipApplications from '../models/membershipApplication.model.js';

export const getMembershipApplications = async (req, res, next) => {
  try {
    const membershipApplicationRecords = await MembershipApplications.findAll();
    res.json(membershipApplicationRecords);
  } catch (err) {
    next(err);
  }
};

export const getMembershipApplicationById = async (req, res, next) => {
  try {
    const { userId } = req.params;
    const membershipApplicationRecord = await MembershipApplications.findByUserId(userId);
    res.json(membershipApplicationRecord);
  } catch (err) {
    next(err);
  }
};
