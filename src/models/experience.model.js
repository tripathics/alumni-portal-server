import Model from './model.js';

const experienceColumns = [
  'id',
  'user_id',
  'type',
  'organisation',
  'designation',
  'location',
  'start_date',
  'end_date',
  'ctc',
  'description',
];

class Experiences extends Model {
  async createOrUpdate(userId, experienceData) {
    const columns = experienceColumns.filter(
      (column) => !!experienceData[column] && column !== 'user_id',
    );
    const values = [userId, ...columns.map((column) => experienceData[column])];

    const sql = `
    INSERT INTO experiences (user_id, ${columns.join(', ')})
    VALUES ($1, ${columns.map((_, i) => `$${i + 2}`).join(', ')})
    ON CONFLICT (id) DO UPDATE SET
    ${columns.map((column) => `${column} = EXCLUDED.${column}`).join(', ')}
    RETURNING *
    `;
    const result = await this.queryExecutor.query(sql, values);
    return result.rows[0];
  }

  async findByUserId(userId) {
    const result = await this.queryExecutor.query(
      'SELECT * FROM experiences WHERE user_id = $1',
      [userId],
    );
    return result.rows;
  }

  async delete(id) {
    const result = await this.queryExecutor.query(
      'DELETE FROM experiences WHERE id = $1 RETURNING *',
      [id],
    );
    return result.rowCount > 0;
  }
}

export default Experiences;
