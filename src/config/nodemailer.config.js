import nodemailer from 'nodemailer';
import ApiError from '../utils/ApiError.util.js';

const transporter = nodemailer.createTransport({
  service: 'Gmail',
  host: 'smtp.gmail.com',
  port: 465,
  secure: false,
  auth: {
    user: process.env.NODEMAILER_EMAIL,
    pass: process.env.NODEMAILER_PASSWORD,
  },
  tls: {
    ciphers: 'SSLv3',
    rejectUnauthorized: false,
  },
});

export const verifyTransporterConnection = async () => {
  try {
    await transporter.verify();
  } catch (err) {
    throw new ApiError(500, 'NODEMAILER', `SMTP connection failed: ${err.message}`);
  }
};

export default transporter;
