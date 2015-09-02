'use strict';

const BaseAgent = require('../base');

class IndexedDBAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   * Enables events from backend.
   */
  enable() {
    throw new Error('Not implemented');
  }

  /**
   * Disables events from backend.
   */
  disable() {
    throw new Error('Not implemented');
  }

  /**
   * Requests database names for given security origin.
   * 
   * @param {string} securityOrigin Security origin.
   * 
   * @returns {Array.<string>} databaseNames Database names for origin.
   */
  requestDatabaseNames() {
    throw new Error('Not implemented');
  }

  /**
   * Requests database with given name in given frame.
   * 
   * @param {string} securityOrigin Security origin.
   * @param {string} databaseName Database name.
   * 
   * @returns {DatabaseWithObjectStores} databaseWithObjectStores Database with an array of object stores.
   */
  requestDatabase() {
    throw new Error('Not implemented');
  }

  /**
   * Requests data from object store or index.
   * 
   * @param {string} securityOrigin Security origin.
   * @param {string} databaseName Database name.
   * @param {string} objectStoreName Object store name.
   * @param {string} indexName Index name, empty string for object store data requests.
   * @param {integer} skipCount Number of records to skip.
   * @param {integer} pageSize Number of records to fetch.
   * @param {KeyRange=} keyRange Key range.
   * 
   * @returns {Array.<DataEntry>} objectStoreDataEntries Array of object store data entries.
   * @returns {boolean} hasMore If true, there are more entries to fetch in the given range.
   */
  requestData() {
    throw new Error('Not implemented');
  }

  /**
   * Clears all entries from an object store.
   * 
   * @param {string} securityOrigin Security origin.
   * @param {string} databaseName Database name.
   * @param {string} objectStoreName Object store name.
   * 
   * 
   */
  clearObjectStore() {
    throw new Error('Not implemented');
  }
}

module.exports = IndexedDBAgent;
