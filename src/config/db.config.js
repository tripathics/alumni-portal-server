import pg from 'pg';
import ApiError from '../utils/ApiError.util.js';

const { Pool } = pg;

// Make sure date columns output are in correct format (YYYY-MM-DD)
const PGDATEOID = 1082;
pg.types.setTypeParser(PGDATEOID, (value) => value);

const pool = new Pool({
  connectionString: process.env.PGURL,
});

export const verifyDbConnection = async () => {
  try {
    await pool.query('SELECT 1');
  } catch (err) {
    throw new ApiError(500, 'DB', `Database connection failed: ${err.message}`);
  }
};

export default pool;
