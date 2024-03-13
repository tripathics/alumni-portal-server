import db from '../config/db.config.js';

class Profile {
  static async findByEmail(email) {
    const result = await db.query(`
      SELECT users.*, profiles.title, profiles.firstName, profiles.lastName, profiles.avatar, 
      membership_applications.status = 'pending' as "profileLocked"
      FROM users
      LEFT JOIN profiles ON users.id = profiles."userId"
      LEFT JOIN membership_applications ON users.id = membership_applications."userId" 
      WHERE users.email = $1
    `, [email]);

    return result.rows[0];
  }
}

export default Profile;
