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
      SELECT users.id, users.email, users.role, 
      profiles.title, profiles.first_name, profiles.last_name, profiles.avatar, profiles.sign,
      membership_applications.status = 'pending' as "profile_locked"
      FROM profiles
      RIGHT JOIN users ON users.id = profiles.user_id
      LEFT JOIN membership_applications ON users.id = membership_applications.user_id
      WHERE users.email = $1
    `, [email]);

    return result.rows[0];
  }

  static async createOrUpdate(userId, profileData) {
    const columns = profileColumns.filter((column) => !!profileData[column]);
    const values = [userId, ...columns.map((column) => profileData[column])];

    const sql = `
      INSERT INTO profiles (user_id, ${columns.join(', ')})
      VALUES ($1, ${columns.map((_, i) => `$${i + 2}`).join(', ')})
      ON CONFLICT (user_id) DO UPDATE SET
      ${columns.map((column) => `${column} = EXCLUDED.${column}`).join(', ')}
      RETURNING *
    `;
    const result = await db.query(sql, values);
    return result.rows[0];
  }

  static async updateAvatar(userId, avatar) {
    const result = await db.query(`
      UPDATE profiles
      SET avatar = $1
      WHERE "userId" = $2
      RETURNING *
    `, [avatar, userId]);

    return result.rows[0];
  }
}

export default Profile;
