import MembershipApplications from '../models/membershipApplication.model.js';
import User from '../models/user.model.js';
import HeroSection from '../models/heroSection.model.js';

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
    const membershipApplicationRecord =
      await MembershipApplications.findById(id);
    res.json(membershipApplicationRecord);
  } catch (err) {
    next(err);
  }
};

export const updateMembershipApplicationStatus = async (req, res, next) => {
  try {
    const {
      body: { status },
      params: { id },
    } = req;

    // if current status is !pending, return error
    const existingMembershipApplicationRecord =
      await MembershipApplications.findById(id);
    if (existingMembershipApplicationRecord.status !== 'pending') {
      return res.status(400).json({
        message: 'Cannot update status of resolved/rejected application',
      });
    }

    const membershipApplicationRecord =
      await MembershipApplications.updateStatus(id, status);
    if (membershipApplicationRecord.status === 'approved') {
      // add 'alumni' role to user
      const userRecord = await User.addRoles(
        membershipApplicationRecord.user_id,
        ['alumni'],
      );
      if (userRecord.role.includes('alumni')) {
        res.status(201).json({
          message: 'Membership application approved successfully',
          membershipApplicationRecord,
        });
      }
    } else {
      res.status(201).json({
        message: 'Membership application rejected successfully',
        membershipApplicationRecord,
      });
    }
  } catch (err) {
    next(err);
  }
};

// user management
export const getUsers = async (req, res, next) => {
  try {
    const users = await User.findWithBasicProfile();
    res.status(200).json({ users });
  } catch (err) {
    next(err);
  }
};

export const changeUserPassword = async (req, res) => {
  res.json({ message: 'TODO', payload: req.body });
};

export const deleteUserAccount = async (req, res, next) => {
  const { userId } = req.body;
  try {
    const result = await User.delete(userId);

    res.json({ deleted: result, message: 'Account deleted' });
  } catch (error) {
    next(error);
  }
};

export const assignUserRoles = async (req, res, next) => {
  try {
    const { userId, roles } = req.body;
    const result = await User.addRoles(userId, roles);
    res.json({ message: 'Role(s) assgined successfully', updatedUser: result });
  } catch (error) {
    next(error);
  }
};

export const revokeUserRoles = async (req, res, next) => {
  try {
    const { userId, roles } = req.body;
    const result = await User.removeRoles(userId, roles);
    res.json({ message: 'Role(s) revoked successfully', updatedUser: result });
  } catch (error) {
    next(error);
  }
};

// website content management
export const updateHeroContent = async (req, res, next) => {
  try {
    const formData = req.body;
    const result = HeroSection.update(formData);
    if (result) {
      res.status(200).json({ message: 'Hero section updated successfully' });
    } else {
      res.status(400).json({ message: 'Failed to update hero section' });
    }
  } catch (err) {
    next(err);
  }
};
