import pg from 'pg';

const { Pool } = pg;

const pool = new Pool({
  connectionString: process.env.PGURL,
});

export default pool;
