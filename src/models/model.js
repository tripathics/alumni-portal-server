import * as db from '../config/db.config.js';

class Model {
  constructor(queryExecutor = db) {
    this.queryExecutor = queryExecutor;
  }
}

export default Model;
