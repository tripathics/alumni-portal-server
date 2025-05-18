import ApiError from '../utils/ApiError.util.js';
import Model from './model.js';

const webMessagesColumns = [
  'message_from',
  'full_name',
  'email',
  'phone',
  'message',
  'designation',
  'department',
  'avatar',
];

class WebMessages extends Model {
  async find() {
    const { rows } = await this.queryExecutor.query(
      'SELECT * FROM web_messages',
    );
    return rows;
  }

  async findPresidentsMessage() {
    const { rows } = await this.queryExecutor.query(
      ` SELECT * FROM web_messages WHERE message_from = 'president'`,
    );
    return rows;
  }

  async findDirectorsMessage() {
    const { rows } = await this.queryExecutor.query(
      ` SELECT * FROM web_messages WHERE message_from = 'director'`,
    );
    return rows;
  }

  async createOrUpdate(messageData) {
    if (!messageData.message_from)
      throw new ApiError(400, 'DB', 'Message from is not provided');

    const columns = webMessagesColumns.filter(
      (column) => messageData[column] !== undefined,
    );
    const values = columns.map((column) => messageData[column]);

    const sql = `
      INSERT INTO web_messages (${columns.join(', ')})
      VALUES (${columns.map((_, i) => `$${i + 1}`).join(', ')})
      ON CONFLICT (message_from) DO UPDATE SET
      ${columns.map((column) => `${column} = EXCLUDED.${column}`).join(', ')}
      RETURNING *
    `;
    const { rows } = await this.queryExecutor.query(sql, values);
    return rows[0];
  }
}

export default WebMessages;
