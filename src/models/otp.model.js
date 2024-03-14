import db from '../config/db.config.js';

class OTP {
  static async createOTP({ email, otp }) {
    const otpResult = await db.query(`
    INSERT INTO otp_email (email, otp, verified) VALUES ($1, $2, false) 
    ON CONFLICT (email) DO UPDATE SET otp = $2, verified = false, updated_at = NOW() RETURNING *
    `, [email, otp]);

    // Increment the number of attempts
    const attemptsResult = await db.query(`
    INSERT INTO otp_email_attempts (email, attempts) VALUES ($1, 1) 
    ON CONFLICT (email) DO UPDATE SET attempts = otp_email_attempts.attempts + 1, updated_at = NOW() RETURNING *
    `, [email]);

    return { otp: otpResult.rows[0], attempts: attemptsResult.rows[0] };
  }

  static async markVerified(email) {
    const result = await db.query('UPDATE otp_email SET verified = true, updated_at = NOW() WHERE email = $1', [email]);
    return result.rowCount > 0;
  }

  static async deleteOTP(email, verified = false) {
    const result = await db.query('DELETE FROM otp_email WHERE email = $1 AND verified = $2', [email, verified]);
    return result.rowCount > 0;
  }

  static async findOTPByEmail(email) {
    const otpResult = await db.query('SELECT * FROM otp_email WHERE email = $1', [email]);
    return otpResult.rows[0];
  }

  static async findAttemptByEmail(email) {
    const result = await db.query('SELECT * FROM otp_email_attempts WHERE email = $1', [email]);
    return result.rows[0];
  }

  static async incrementAttempts(email) {
    const result = await db.query('UPDATE otp_email_attempts SET attempts = attempts + 1, updated_at = NOW() WHERE email = $1 RETURNING *', [email]);
    return result.rows[0];
  }

  static async resetAttempts(email) {
    const result = await db.query('UPDATE otp_email_attempts SET attempts = 0 WHERE email = $1', [email]);
    return result.rows[0];
  }
}

export default OTP;
