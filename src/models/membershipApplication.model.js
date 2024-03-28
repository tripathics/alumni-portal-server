import db from '../config/db.config.js';
import NITAP from '../utils/constants.util.js';

class MembershipApplications {
  static async findAll() {
    const sql = `SELECT membership_applications.*, 
    profiles.roll_no, profiles.avatar, profiles.title, profiles.first_name, profiles.last_name,
    educations.degree, educations.discipline, educations.end_date as graduation_date, educations.start_date as enrollment_date
    FROM membership_applications
    LEFT JOIN profiles ON membership_applications.user_id = profiles.user_id
    LEFT JOIN educations ON membership_applications.user_id = educations.user_id
    WHERE educations.institute = '${NITAP}'
    `;
    const { rows } = await db.query(sql);
    return rows;
  }

  static async getSignByUserId(userId) {
    const { rows } = await db.query('SELECT sign FROM membership_applications WHERE user_id = $1', [userId]);
    return rows[0]?.sign;
  }

  /**
   * Find a list of membership applications given filters.
   */
  static async find(filters) {
    let sql = `
    SELECT membership_applications.*,
    profiles.*,
    users.email,
    educations.degree, educations.discipline, educations.end_date as graduation_date, educations.start_date as enrollment_date 
    FROM membership_applications 
    LEFT JOIN users ON membership_applications.user_id = users.id
    LEFT JOIN profiles ON membership_applications.user_id = profiles.user_id
    LEFT JOIN educations ON membership_applications.user_id = educations.user_id
    WHERE AND educations.institute = ${NITAP}`;

    const values = [];
    Object.entries(filters).forEach(([key, value], index) => {
      sql += ` AND ${key} = $${index + 1}`;
      values.push(value);
    });

    const { rows } = await db.query(sql, values);
    return rows[0];
  }

  static async findById(id) {
    const { rows } = await db.query(`
    SELECT membership_applications.*,
    profiles.*,
    users.email,
    educations.degree, educations.discipline, educations.end_date as graduation_date, educations.start_date as enrollment_date
    FROM membership_applications
    LEFT JOIN users ON membership_applications.user_id = users.id
    LEFT JOIN profiles ON membership_applications.user_id = profiles.user_id
    LEFT JOIN educations ON membership_applications.user_id = educations.user_id
    WHERE educations.institute = '${NITAP}'
    AND membership_applications.id = $1`, [id]);

    return rows[0];
  }

  static async create(userId, data) {
    const { rows } = await db.query(
      'INSERT INTO membership_applications (user_id, membership_level, sign) VALUES ($1, $2, $3) RETURNING *',
      [userId, data.membership_level, data.sign],
    );
    return rows;
  }

  static async updateStatus(id, status) {
    const { rows } = await db.query(
      'UPDATE membership_applications SET status = $1 WHERE id = $2 RETURNING *',
      [status, id],
    );
    return rows[0];
  }
}

export default MembershipApplications;
