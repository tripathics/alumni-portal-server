import db from '../config/db.config.js';

class User {
  static async find() {
    const result = await db.query('SELECT * FROM users');
    return result.rows;
  }

  static async findById(id) {
    const result = await db.query('SELECT * FROM users WHERE id = $1', [id]);
    return result.rows[0];
  }

  static async findByEmail(email) {
    const result = await db.query('SELECT * FROM users WHERE email = $1', [email]);
    return result.rows[0];
  }

  static async findByEmailWithProfile(email) {
    const result = await db.query(`
      SELECT users.*, profiles.title, profiles.first_name, profiles.last_name, profiles.avatar, profiles.sign,
      membership_applications.status = 'pending' as "profile_locked"
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

  static async updateRole(id, role) {
    const result = await db.query(`
      UPDATE users SET role = $1 WHERE id = $2 RETURNING *',
    `, [role, id]);
    return result.rows[0];
  }

  static async delete(id) {
    const result = await db.query('DELETE FROM users WHERE id = $1', [id]);
    return result.rowCount > 0;
  }
}

export default User;
