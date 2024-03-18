import db from '../config/db.config.js';

class MembershipApplications {
  static async get() {
    const sql = `SELECT membership_applications.*, 
    profiles.registration_no, profiles.roll_no, profiles.avatar, profiles.title, profiles.first_name, profiles.last_name,
    educations.degree, educations.degree, educations.end_date as graduation_date, educations.start_date as enrollment_date, 
    FROM membership_applications
    LEFT JOIN profiles ON membership_applications.user_id = profiles.user_id
    LEFT JOIN educations ON membership_applications.user_id = educations.user_id
    WHERE membership_applications.status = 'pending' AND educations.institute = $1
    `;
    const { rows } = await db.query(sql, ['National Institute of Technology, Arunachal Pradesh']);
    return rows;
  }

  static async create(userId, data) {
    const { rows } = await db.query(
      'INSERT INTO membership_applications (user_id, membership_level, sign) VALUES ($1, $2, $3) RETURNING *',
      [userId, data.membership_level, data.sign],
    );
    return rows;
  }

  static async updateStatus(userId, status) {
    const { rowCount } = await db.query(
      'UPDATE membership_applications SET status = $1 WHERE user_id = $2 RETURNING *',
      [status, userId],
    );
    return rowCount > 0;
  }
}

export default MembershipApplications;
