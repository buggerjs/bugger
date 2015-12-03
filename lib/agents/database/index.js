'use strict';

const BaseAgent = require('../base');

class DatabaseAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   * Enables database tracking, database events will now be delivered to the client.
   */
  enable() {
    throw new Error('Not implemented');
  }

  /**
   * Disables database tracking, prevents database events from being sent to the client.
   */
  disable() {
    throw new Error('Not implemented');
  }

  /**
   *
   * @param {DatabaseId} databaseId
   *
   * @returns {Array.<string>} tableNames
   */
  getDatabaseTableNames() {
    throw new Error('Not implemented');
  }

  /**
   *
   * @param {DatabaseId} databaseId
   * @param {string} query
   *
   * @returns {Array.<string>=} columnNames
   * @returns {Array.<any>=} values
   * @returns {Error=} sqlError
   */
  executeSQL() {
    throw new Error('Not implemented');
  }
}

module.exports = DatabaseAgent;
