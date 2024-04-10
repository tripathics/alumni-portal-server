/* eslint-disable import/first */
import dotenv from 'dotenv';

dotenv.config();

import fs from 'fs';
import path from 'path';
import url from 'url';
import bcrypt from 'bcrypt';
import pg from 'pg';

const pool = new pg.Pool({
  connectionString: process.env.PGURL,
});

const FILENAME = url.fileURLToPath(import.meta.url);
const DIRNAME = path.dirname(FILENAME);

const seedAdmin = async (client) => {
  const [email, password] = [
    process.env.ADMIN_EMAIL,
    process.env.ADMIN_PASSWORD,
  ];
  // create user
  const { rowCount } = await client.query('SELECT * FROM users WHERE email = $1', [email]);
  if (rowCount) {
    console.log('Admin user already seeded');
    return;
  }
  const hashedPassword = await bcrypt.hash(password, 10);
  await client.query('INSERT INTO users (email, password, role) VALUES ($1, $2, ARRAY[$3])', [email, hashedPassword, 'admin']);
  console.log('Admin user seeded');
};

const migrate = async () => {
  const client = await pool.connect();
  try {
    const sql = (await fs.promises.readFile(path.join(DIRNAME, './database.sql'))).toString();
    await client.query(sql);
    console.log('Migration complete');

    // seed admin
    await seedAdmin(client);
  } catch (error) {
    console.error('Migration failed', error.message);
  } finally {
    client.release();
  }
};

const migrateDown = async () => {
  const client = await pool.connect();
  try {
    await client.query('DROP SCHEMA public CASCADE');
    await client.query('CREATE SCHEMA public');
    console.log('Migration down complete');
  } catch (error) {
    console.error('Migration down failed', error.message);
  } finally {
    client.release();
  }
};

// when run migrate down drop all tables else call migrate()
if (process.argv[2] === 'down') {
  migrateDown();
} else {
  migrate();
}
