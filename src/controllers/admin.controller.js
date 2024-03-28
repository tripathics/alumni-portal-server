import MembershipApplications from '../models/membershipApplication.model.js';
import User from '../models/user.model.js';

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
    const { id } = req.params;
    const membershipApplicationRecord = await MembershipApplications.findById(id);
    res.json(membershipApplicationRecord);
  } catch (err) {
    next(err);
  }
};

export const updateMembershipApplicationStatus = async (req, res, next) => {
  try {
    const { body: { status }, params: { id } } = req;
    const membershipApplicationRecord = await MembershipApplications.updateStatus(id, status);
    if (membershipApplicationRecord.status === 'approved') {
      // append 'alumni' role to user
      const userRecord = await User.addRole(membershipApplicationRecord.user_id, 'alumni');
      if (userRecord.role.includes('alumni')) {
        res.status(201).json({ message: 'Membership application status updated successfully', membershipApplicationRecord, userRecord });
      }
    }
  } catch (err) {
    next(err);
  }
};
