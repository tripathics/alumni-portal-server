import MembershipApplications from '../models/membershipApplication.model.js';
import User from '../models/user.model.js';
import * as db from '../config/db.config.js';
import HeroSection from '../models/heroSection.model.js';
import bcrypt from 'bcrypt';
import ApiError from '../utils/ApiError.util.js';
import Profile from '../models/profile.model.js';
import { deleteObject, extractKeyFromUrl } from '../utils/s3.util.js';

export const getMembershipApplications = async (req, res, next) => {
  try {
    const membershipApplicationRecords =
      await new MembershipApplications().find({
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
      await new MembershipApplications().findById(id);
    res.json(membershipApplicationRecord);
  } catch (err) {
    next(err);
  }
};

const approveMembershipApplication = async (id) => {
  const client = await db.getClient();
  try {
    client.query('BEGIN');
    // approve application
    const membershipApplicationRecord = await new MembershipApplications(
      client,
    ).updateStatus(id, 'approved');
    // assign 'alumni' role
    await new User(client).addRoles(membershipApplicationRecord.user_id, [
      'alumni',
    ]);
    client.query('COMMIT');
  } catch (e) {
    client.query('ROLLBACK');
    throw new ApiError(500, 'DB', 'Approving application failed!');
  } finally {
    client.release();
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
      await new MembershipApplications().findById(id);
    if (existingMembershipApplicationRecord.status !== 'pending') {
      return res.status(400).json({
        message: 'Cannot update status of resolved/rejected application',
      });
    }
    if (status === 'rejected') {
      const membershipApplicationRecord =
        await new MembershipApplications().updateStatus(id, status);
      res.status(201).json({
        message: 'Membership application rejected successfully',
        membershipApplicationRecord,
      });
    } else if (status === 'approved') {
      const membershipApplicationRecord =
        await approveMembershipApplication(id);
      res.status(201).json({
        message: 'Membership application approved successfully',
        membershipApplicationRecord,
      });
    } else {
      throw new ApiError(400, 'Usage', `Invalid status value: ${status}`);
    }
  } catch (err) {
    next(err);
  }
};

// user management
export const getUsers = async (req, res, next) => {
  try {
    const users = await new User().findWithBasicProfile();
    res.status(200).json({ users });
  } catch (err) {
    next(err);
  }
};

export const changeUserPassword = async (req, res, next) => {
  const { userId, password, confirmPassword } = req.body;
  try {
    if (password !== confirmPassword) {
      return res.status(400).json({ message: 'Passwords do not match' });
    }
    const hashedPassword = await bcrypt.hash(password, 10);
    const user = await new User().updatePasswordById(userId, hashedPassword);
    delete user.password;
    res.status(200).json(user);
  } catch (error) {
    next(error);
  }
};

export const deleteUserAccount = async (req, res, next) => {
  const { userId } = req.body;
  try {
    // get user avatar to delete from s3 once user is deleted
    const { avatar } = await new Profile().findByUserId(userId);
    const result = await new User().delete(userId);
    if (avatar) {
      const avatarKey = extractKeyFromUrl(avatar);
      await deleteObject(avatarKey);
    }

    res.json({ deleted: result, message: 'Account deleted' });
  } catch (error) {
    next(error);
  }
};

export const assignUserRoles = async (req, res, next) => {
  try {
    const { userId, roles } = req.body;
    const result = await new User().addRoles(userId, roles);
    res.json({ message: 'Role(s) assgined successfully', updatedUser: result });
  } catch (error) {
    next(error);
  }
};

export const revokeUserRoles = async (req, res, next) => {
  try {
    const { userId, roles } = req.body;
    const result = await new User().removeRoles(userId, roles);
    res.json({ message: 'Role(s) revoked successfully', updatedUser: result });
  } catch (error) {
    next(error);
  }
};

// website content management
export const updateHeroContent = async (req, res, next) => {
  try {
    const formData = req.body;
    const result = HeroSection().update(formData);
    if (result) {
      res.status(200).json({ message: 'Hero section updated successfully' });
    } else {
      res.status(400).json({ message: 'Failed to update hero section' });
    }
  } catch (err) {
    next(err);
  }
};
