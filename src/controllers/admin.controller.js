import MembershipApplications from '../models/membershipApplication.model.js';
import User from '../models/user.model.js';

export const getMembershipApplications = async (req, res, next) => {
  try {
    const membershipApplicationRecords = await MembershipApplications.find({
      'membership_applications.status': 'pending',
    });
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

    // if current status is !pending, return error
    const existingMembershipApplicationRecord = await MembershipApplications.findById(id);
    if (existingMembershipApplicationRecord.status !== 'pending') {
      return res.status(400).json({ message: 'Cannot update status of resolved/rejected application' });
    }

    const membershipApplicationRecord = await MembershipApplications.updateStatus(id, status);
    if (membershipApplicationRecord.status === 'approved') {
      // add 'alumni' role to user
      const userRecord = await User.addRole(membershipApplicationRecord.user_id, 'alumni');
      if (userRecord.role.includes('alumni')) {
        res.status(201).json({ message: 'Membership application status approved successfully', membershipApplicationRecord });
      }
    } else {
      res.status(201).json({ message: 'Membership application rejected successfully', membershipApplicationRecord });
    }
  } catch (err) {
    next(err);
  }
};

export const getUsers = async (req, res, next) => {
  try {
    const users = await User.findWithBasicProfile();
    res.status(200).json({ users });
  } catch (err) {
    next(err);
  }
};
