import Model from './model.js';
import NITAP from '../utils/constants.util.js';

class Alumni extends Model {
  async find() {
    const result = await this.queryExecutor.query(
      `
      SELECT
        u.id,
        CONCAT_WS(' ', p.title, p.first_name, p.last_name) AS name,
            p.linkedin,
        p.github,
        p.avatar,

        -- Current experience (organization)
        e.organisation AS job_organisation,
        e.designation AS job_designation,
        e.location AS job_location,

        -- Current education (if any)
        ed.institute AS ed_institute,
        ed.degree AS ed_degree,
        ed.discipline AS ed_discipline,

        -- NITAP education (latest)
        nitap_ed.degree AS nitap_degree,
        nitap_ed.discipline AS nitap_discipline,
        EXTRACT(YEAR FROM nitap_ed.end_date) AS nitap_graduation_year

      FROM profiles p
      JOIN users u ON u.id = p.user_id
      
      -- Current experience (end_date IS NULL)
      LEFT JOIN LATERAL (
        SELECT organisation, designation, location
        FROM experiences
        WHERE user_id = p.user_id
          AND end_date IS NULL
        ORDER BY start_date DESC
        LIMIT 1
      ) e ON true

      -- Current education (end_date IS NULL)
      LEFT JOIN LATERAL (
        SELECT institute, degree, discipline
        FROM educations
        WHERE user_id = p.user_id
          AND end_date IS NULL
        ORDER BY start_date DESC
        LIMIT 1
      ) ed ON true

      -- NITAP education (latest by end_date)
      LEFT JOIN LATERAL (
        SELECT degree, discipline, end_date
        FROM educations
        WHERE user_id = p.user_id
          AND institute = $1
        ORDER BY end_date DESC
        LIMIT 1
      ) nitap_ed ON true

      -- Filter to alumni only
      WHERE 'alumni' = ANY(u.role);
    `,
      [NITAP],
    );
    return result.rows;
  }
}

export default Alumni;
