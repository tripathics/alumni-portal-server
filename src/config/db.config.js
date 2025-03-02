import pg from 'pg';
import ApiError from '../utils/ApiError.util.js';

// Make sure date columns output are in correct format (YYYY-MM-DD)
const PGDATEOID = 1082;
pg.types.setTypeParser(PGDATEOID, (value) => value);

const { Pool } = pg;

const pool = new Pool();

export const getClient = async () => {
  const client = await pool.connect();
  const { query, release } = client;

  // set a timeout of 5 seconds, after which we will log this client's last query
  const timeout = setTimeout(() => {
    console.error('A client has been checked out for more than 5 seconds!');
    console.error(`The last executed query on this client was: ${client.lastQuery}`);
  }, 5000);
  // monkey patch the query method to keep track of the last query executed
  client.query = (...args) => {
    client.lastQuery = args;
    return query.apply(client, args);
  };
  client.release = () => {
    // clear our timeout
    clearTimeout(timeout);
    // set the methods back to their old un-monkey-patched version
    client.query = query;
    client.release = release;
    return release.apply(client);
  };
  return client;
};

export const query = async (text, params, client = null) => {
  const res = await (pool || client).query(text, params);
  return res;
};

export const verifyDbConnection = async () => {
  try {
    await pool.query('SELECT 1');
  } catch (err) {
    throw new ApiError(500, 'DB', `Database connection failed: ${err.message}`);
  }
};
