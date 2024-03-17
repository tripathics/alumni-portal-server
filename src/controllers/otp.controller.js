import ApiError from '../utils/ApiError.util.js';
import { generateOTP, sendOTPEmail, verifyOTP } from '../utils/otp.util.js';

const emailRegex = /^(?!.*@nitap\.ac\.in)[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

const generate = async (req, res, next) => {
  const { email } = req.body;
  if (!emailRegex.test(email)) {
    return res.status(400).json({
      success: false,
      message: 'Invalid email. Only personal email is allowed.',
    });
  }
  try {
    const generatedOTP = await generateOTP(email);
    if (!generatedOTP) {
      throw new ApiError(500, 'OTP', 'Error generating OTP');
    }
    sendOTPEmail(email, generatedOTP.otp);
    res.status(201).json({
      success: true,
      message: 'OTP sent to email',
    });
  } catch (err) {
    next(err);
  }
};

const verify = async (req, res, next) => {
  const { email, otp } = req.body;
  if (!emailRegex.test(email)) {
    return res.status(400).json({
      success: false,
      message: 'Invalid email',
    });
  }
  try {
    const result = await verifyOTP(email, otp);
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

export { generate, verify };
