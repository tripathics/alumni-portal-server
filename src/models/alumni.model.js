import * as db from '../config/db.config.js';
import NITAP from '../utils/constants.util.js';

class Alumni {
  static async find() {
    // name, avatar, course, degree, linkedin?, github?, course, degree
    // current status?
    //   - job (role@company, location) or
    //   - education (course, degree @ college)

    const result = await db.query(
      `
      SELECT
        u.id,
        CONCAT_WS(' ', p.title, p.first_name, p.last_name) AS name,
        p.linkedin,
        p.github,
        p.avatar,
      
        -- Current experience (organization)
        e.organisation,
        e.designation,
        e.location,
      
        -- Current education (if any)
        ed.institute,
        ed.degree,
        ed.discipline,
      
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
