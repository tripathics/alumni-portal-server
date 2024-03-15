import db from '../config/db.config.js';

const profileColumns = [
  'user_id',
  'title',
  'first_name',
  'last_name',
  'dob',
  'sex',
  'category',
  'nationality',
  'religion',
  'address',
  'pincode',
  'state',
  'city',
  'country',
  'phone',
  'alt_phone',
  'alt_email',
  'linkedin',
  'github',
  'registration_no',
  'roll_no',
  'sign',
  'avatar',
];

class Profile {
  static async findByEmail(email) {
    const result = await db.query(`
      SELECT users.id, users.email, users.role, profiles.title, profiles.firstName, profiles.lastName, profiles.avatar,
      membership_applications.status = 'pending' as "profile_locked"
      FROM users
      LEFT JOIN profiles ON users.id = profiles."userId"
      LEFT JOIN membership_applications ON users.id = membership_applications."userId" 
      WHERE users.email = $1
    `, [email]);

    return result.rows[0];
  }

  static async createOrUpdate(userId, profileData) {
    const columns = profileColumns.filter((column) => !!profileData[column]);
    const values = [userId, ...columns.map((column) => profileData[column])];

    const sql = `
      INSERT INTO profiles ("userId", ${columns.join(', ')})
      VALUES ($1, ${columns.map((_, i) => `$${i + 2}`).join(', ')})
      ON CONFLICT ("userId") DO UPDATE SET
      ${columns.map((column) => `${column} = EXCLUDED.${column}`).join(', ')}
      RETURNING *
    `;
    const result = await db.query(sql, values);
    return result.rows[0];
  }
}

export default Profile;
