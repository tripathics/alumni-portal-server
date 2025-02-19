import db from '../config/db.config.js';
import ApiError from '../utils/ApiError.util.js';
import NITAP from '../utils/constants.util.js';
import MembershipApplications from './membershipApplication.model.js';

const educationColumns = [
  'id',
  'user_id',
  'type',
  'institute',
  'degree',
  'discipline',
  'start_date',
  'end_date',
  'description',
];

class Educations {
  static async createOrUpdate(userId, educationData) {
    const columns = educationColumns.filter((column) => educationData[column] !== undefined && column !== 'user_id');
    const values = [userId, ...columns.map((column) => educationData[column])];

    // don't allow to update education at NITAP
    if (educationData.id && educationData.institute === NITAP) {
      const membershipForms = await MembershipApplications.find({ 'membership_applications.user_id': userId });

      if (membershipForms.some((form) => form.status === 'approved' || form.status === 'pending')) {
        throw new ApiError(403, 'Education', `Updating education details at ${NITAP} is not allowed unless membership application is rejected`);
      }
    }

    // only allow NIT Arunachal Pradesh education as first insert for a user
    if (!educationData.id && educationData.institute !== NITAP) {
      const existingEducation = await this.findByUserId(userId);
      if (!existingEducation.length) {
        throw new ApiError(400, 'Education', `First education should be of ${NITAP}`);
      }
    }

    const sql = `
    INSERT INTO educations (user_id, ${columns.join(', ')})
    VALUES ($1, ${columns.map((_, i) => `$${i + 2}`).join(', ')})
    ON CONFLICT (id) DO UPDATE SET
    ${columns.map((column) => `${column} = EXCLUDED.${column}`).join(', ')}
    RETURNING *
    `;
    const result = await db.query(sql, values);
    return result.rows[0];
  }

  static async findByUserId(userId) {
    const result = await db.query('SELECT * FROM educations WHERE user_id = $1', [userId]);
    return result.rows;
  }

  static async findNITAPByUserId(userId) {
    const result = await db.query('SELECT * FROM educations WHERE user_id = $1 AND institute = $2', [userId, NITAP]);
    return result.rows;
  }

  static async findById(id) {
    const result = await db.query('SELECT * FROM educations WHERE id = $1', [id]);
    return result.rows[0];
  }

  static async delete(id) {
    const result = await db.query('DELETE FROM educations WHERE id = $1 RETURNING *', [id]);
    return result.rowCount > 0;
  }
}

export default Educations;
