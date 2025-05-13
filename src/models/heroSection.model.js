import Model from './model.js';
import ApiError from '../utils/ApiError.util.js';

const requiredCols = ['title', 'description'];

class HeroSection extends Model {
  async find() {
    const result = await this.queryExecutor.query(`
      SELECT * FROM hero_section
      WHERE id = 1
    `);
    if (result.rows.length === 0) {
      throw new ApiError(404, 'DB', 'Hero section not found');
    }
    return result.rows[0];
  }

  async update(data) {
    if (requiredCols.some((col) => !data[col])) {
      throw new ApiError(400, 'DB', 'Missing required fields');
    }
    const result = await this.queryExecutor.query(
      `
      INSERT INTO hero_section (id, title, description, hero_image)
      VALUES (1, $1, $2, $3)
      ON CONFLICT (id) 
      DO UPDATE SET 
      title = EXCLUDED.title, 
      description = EXCLUDED.description, 
      hero_image = EXCLUDED.hero_image
      WHERE hero_section.id = 1
      RETURNING *
    `,
      [data.title, data.description, data.hero_image],
    );

    return result.rows[0];
  }
}

export default HeroSection;
