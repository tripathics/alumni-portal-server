import db from '../config/db.config.js';
import ApiError from '../utils/ApiError.util.js';

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

    // only allow NIT Arunachal Pradesh education as first insert for a user
    const existingEducation = await this.findByUserId(userId);
    if (!educationData.id && !existingEducation.length && educationData.institute !== 'National Institute of Technology, Arunachal Pradesh') {
      throw new ApiError(400, 'Education', 'First education should be of National Institute of Technology, Arunachal Pradesh');
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
