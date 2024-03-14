import bcrypt from 'bcrypt';
import User from '../models/user.model.js';
import Profile from '../models/profile.model.js';
import OTP from '../models/otp.model.js';
import { generateToken } from '../utils/jwt.util.js';

export const register = async (req, res, next) => {
  try {
    const { email, password, confirmPassword } = req.body;
    if (password !== confirmPassword) {
      return res.status(400).json({ message: 'Passwords do not match' });
    }
    const existingUser = await User.findByEmail(email);
    if (existingUser) {
      return res.status(400).json({ message: 'User already exists' });
    }

    // check if email is otp verified before signup
    const otpRecord = await OTP.findOTPByEmail(email);
    if (!otpRecord || !otpRecord.verified) {
      return res.status(400).json({ message: 'Email not verified' });
    }
    // check if otp verified is expired
    if (new Date() - new Date(otpRecord.updated_at) > 5 * 60 * 1000) {
      OTP.deleteOTP(email, true); // delete expired verified otp
      return res.status(400).json({ message: 'Session expired, please retry the signup process' });
    }

    // hash password and create user
    const hashedPassword = await bcrypt.hash(password, 10);
    const user = await User.create({ email, password: hashedPassword });
    delete user.password;
    res.status(201).json(user);
  } catch (error) {
    next(error);
  }
};

export const login = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    const userProfile = await Profile.findByEmail(email);
    if (!userProfile) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    const isPasswordValid = await bcrypt.compare(password, userProfile.password);
    if (!isPasswordValid) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }
    delete userProfile.password;
    const secretToken = generateToken(userProfile);

    res.cookie('auth', secretToken, { maxAge: 60 * 60 * 1000, httpOnly: true }).json({
      message: 'User logged in', user: userProfile, success: true,
    });
  } catch (error) {
    next(error);
  }
};

export const getUsers = async (req, res, next) => {
  try {
    const users = await User.find();
    res.status(200).json(users);
  } catch (error) {
    next(error);
  }
};
