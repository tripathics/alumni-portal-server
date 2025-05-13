import Model from './model.js';
import NITAP from '../utils/constants.util.js';

class MembershipApplications extends Model {
  async verifyUserSign(userId, sign) {
    const { rowCount } = await this.queryExecutor.query(
      'SELECT * FROM membership_applications WHERE user_id = $1 AND sign = $2',
      [userId, sign],
    );
    return rowCount > 0;
  }

  /**
   * Find a list of membership applications given filters.
   */
  async find(filters = {}) {
    let sql = `
    SELECT membership_applications.*, users.email,
    profiles.roll_no, profiles.avatar, profiles.title, profiles.first_name, profiles.last_name,
    educations.degree, educations.discipline, educations.end_date as graduation_date, educations.start_date as enrollment_date 
    FROM membership_applications 
    LEFT JOIN users ON membership_applications.user_id = users.id
    LEFT JOIN profiles ON membership_applications.user_id = profiles.user_id
    LEFT JOIN educations ON membership_applications.user_id = educations.user_id
    WHERE educations.institute = $1`;

    const values = [NITAP];
    Object.entries(filters).forEach(([key, value], index) => {
      sql += ` AND ${key} = $${index + 2}`;
      values.push(value);
    });

    sql += ' ORDER BY membership_applications.created_at DESC';

    const { rows } = await this.queryExecutor.query(sql, values);
    return rows;
  }

  async findById(id) {
    const { rows } = await this.queryExecutor.query(
      `
    SELECT membership_applications.*,
    profiles.*,
    users.email,
    educations.degree, educations.discipline, educations.end_date as graduation_date, educations.start_date as enrollment_date
    FROM membership_applications
    LEFT JOIN users ON membership_applications.user_id = users.id
    LEFT JOIN profiles ON membership_applications.user_id = profiles.user_id
    LEFT JOIN educations ON membership_applications.user_id = educations.user_id
    WHERE educations.institute = '${NITAP}'
    AND membership_applications.id = $1`,
      [id],
    );

    return rows[0];
  }

  async create(userId, data) {
    const { rows } = await this.queryExecutor.query(
      'INSERT INTO membership_applications (user_id, membership_level, sign) VALUES ($1, $2, $3) RETURNING *',
      [userId, data.membership_level, data.sign],
    );
    return rows[0];
  }

  async updateStatus(id, status) {
    const { rows } = await this.queryExecutor.query(
      'UPDATE membership_applications SET status = $1 WHERE id = $2 RETURNING *',
      [status, id],
    );
    return rows[0];
  }
}

export default MembershipApplications;
