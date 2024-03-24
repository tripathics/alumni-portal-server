import pg from 'pg';

const { Pool } = pg;

// Make sure date columns output are in correct format (YYYY-MM-DD)
const PGDATEOID = 1082;
pg.types.setTypeParser(PGDATEOID, (value) => value);

const pool = new Pool({
  connectionString: process.env.PGURL,
});

export default pool;
