'use strict';

const BaseAgent = require('../base');

class CacheStorageAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   * Requests cache names.
   *
   * @param {string} securityOrigin Security origin.
   *
   * @returns {Array.<Cache>} caches Caches for the security origin.
   */
  requestCacheNames() {
    throw new Error('Not implemented');
  }

  /**
   * Requests data from cache.
   *
   * @param {CacheId} cacheId ID of cache to get entries from.
   * @param {integer} skipCount Number of records to skip.
   * @param {integer} pageSize Number of records to fetch.
   *
   * @returns {Array.<DataEntry>} cacheDataEntries Array of object store data entries.
   * @returns {boolean} hasMore If true, there are more entries to fetch in the given range.
   */
  requestEntries() {
    throw new Error('Not implemented');
  }

  /**
   * Deletes a cache.
   *
   * @param {CacheId} cacheId Id of cache for deletion.
   */
  deleteCache() {
    throw new Error('Not implemented');
  }

  /**
   * Deletes a cache entry.
   *
   * @param {CacheId} cacheId Id of cache where the entry will be deleted.
   * @param {string} request URL spec of the request.
   */
  deleteEntry() {
    throw new Error('Not implemented');
  }
}

module.exports = CacheStorageAgent;
