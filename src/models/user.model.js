import * as db from '../config/db.config.js';
import ApiError from '../utils/ApiError.util.js';

class User {
  static async find() {
    const { rows } = await db.query('SELECT id, email, role FROM users');
    return rows;
  }

  static async findWithBasicProfile() {
    const { rows } = await db.query(`
    SELECT users.*, 
    profiles.title, profiles.first_name, profiles.last_name, profiles.avatar
    FROM users LEFT JOIN profiles ON users.id = profiles.user_id`);
    return rows;
  }

  static async findById(id) {
    const result = await db.query(
      `
    SELECT users.*,
    EXISTS (
      SELECT 1 FROM membership_applications 
      WHERE users.id = membership_applications.user_id AND status = 'pending'
    ) as "profile_locked"
    FROM users LEFT JOIN membership_applications ON users.id = membership_applications.user_id 
    WHERE users.id = $1
    `,
      [id],
    );
    return result.rows[0];
  }

  static async findByEmail(email) {
    const result = await db.query('SELECT * FROM users WHERE email = $1', [
      email,
    ]);
    return result.rows[0];
  }

  static async findByEmailWithProfile(email) {
    const result = await db.query(
      `
      SELECT users.*, profiles.title, profiles.first_name, profiles.last_name, profiles.avatar, profiles.sign,
      EXISTS (
        SELECT 1 FROM membership_applications 
        WHERE users.id = membership_applications.user_id AND status = 'pending'
      ) as "profile_locked"
      FROM users
      LEFT JOIN profiles ON users.id = profiles.user_id
      LEFT JOIN membership_applications ON users.id = membership_applications.user_id
      WHERE users.email = $1
    `,
      [email],
    );

    return result.rows[0];
  }

  static async create({ email, password, role = 'user' }) {
    const result = await db.query(
      `
      INSERT INTO users (email, password, role) 
      VALUES ($1, $2, ARRAY[$3]) RETURNING *
    `,
      [email, password, role],
    );
    return result.rows[0];
  }

  static async updatePassword(email, password) {
    const result = await db.query(
      `
      UPDATE users SET password = $1, updated_at = NOW() WHERE email = $2 RETURNING *
    `,
      [password, email],
    );
    return result.rows[0];
  }

  static async addRoles(id, roles) {
    const { rows: userRecords } = await db.query(
      'SELECT * FROM users WHERE id = $1',
      [id],
    );

    const currentRoles = userRecords[0].role;
    const newRoles = roles.filter((role) => !currentRoles.includes(role));

    if (newRoles.length === 0) return userRecords[0];

    const placeholders = newRoles.map((_, i) => `$${i + 1}`).join(', ');
    const queryString = `
      UPDATE users SET role = array_cat(role, ARRAY[${placeholders}]) 
      WHERE id = $${newRoles.length + 1} RETURNING *
    `;
    const { rows: updatedUserRecords } = await db.query(queryString, [
      ...newRoles,
      id,
    ]);
    return updatedUserRecords[0];
  }

  static async removeRoles(id, roles) {
    console.log(id, roles);
    throw new ApiError(500, 'DB', 'TODO: Implete remove roles');
  }

  static async delete(id) {
    const { rowCount } = await db.query('DELETE FROM users WHERE id = $1', [
      id,
    ]);
    return rowCount > 0;
  }
}

export default User;
