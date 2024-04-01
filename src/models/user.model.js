import db from '../config/db.config.js';

class User {
  static async find() {
    const { rows } = await db.query('SELECT id, email, role FROM users');
    return rows;
  }

  static async findWithBasicProfile() {
    const { rows } = await db.query(`
    SELECT users.id, users.email, users.role, profiles.title, profiles.first_name, profiles.last_name, profiles.avatar
    FROM users LEFT JOIN profiles ON users.id = profiles.user_id`);
    return rows;
  }

  static async findById(id) {
    const result = await db.query(`
    SELECT users.*,
    EXISTS (
      SELECT 1 FROM membership_applications 
      WHERE users.id = membership_applications.user_id AND status = 'pending'
    ) as "profile_locked"
    FROM users LEFT JOIN membership_applications ON users.id = membership_applications.user_id 
    WHERE users.id = $1
    `, [id]);
    return result.rows[0];
  }

  static async findByEmail(email) {
    const result = await db.query('SELECT * FROM users WHERE email = $1', [email]);
    return result.rows[0];
  }

  static async findByEmailWithProfile(email) {
    const result = await db.query(`
      SELECT users.*, profiles.title, profiles.first_name, profiles.last_name, profiles.avatar, profiles.sign,
      EXISTS (
        SELECT 1 FROM membership_applications 
        WHERE users.id = membership_applications.user_id AND status = 'pending'
      ) as "profile_locked"
      FROM users
      LEFT JOIN profiles ON users.id = profiles.user_id
      LEFT JOIN membership_applications ON users.id = membership_applications.user_id 
      WHERE users.email = $1
    `, [email]);

    return result.rows[0];
  }

  static async create({ email, password, role = 'user' }) {
    const result = await db.query(`
      INSERT INTO users (email, password, role) 
      VALUES ($1, $2, ARRAY[$3]) RETURNING *
    `, [email, password, role]);
    return result.rows[0];
  }

  static async updatePassword(email, password) {
    const result = await db.query(`
      UPDATE users SET password = $1 WHERE email = $2 RETURNING *
    `, [password, email]);
    return result.rows[0];
  }

  static async addRole(id, role) {
    const { rows: userRecords } = await db.query('SELECT * FROM users WHERE id = $1', [id]);
    if (userRecords[0].role.includes(role)) return userRecords[0];
    const { rows: updatedUserRecords } = await db.query(`
      UPDATE users SET role = array_append(role, $1) WHERE id = $2 RETURNING *
    `, [role, id]);
    return updatedUserRecords[0];
  }

  static async removeRole(id, role) {
    const { rows } = await db.query(`
      UPDATE users SET role = array_remove(role, $1) WHERE id = $2 RETURNING *
    `, [role, id]);
    return rows[0];
  }

  static async delete(id) {
    const { rowCount } = await db.query('DELETE FROM users WHERE id = $1', [id]);
    return rowCount > 0;
  }
}

export default User;
