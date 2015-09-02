'use strict';

const BaseAgent = require('../base');

class DOMStorageAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   * Enables storage tracking, storage events will now be delivered to the client.
   */
  enable() {
    throw new Error('Not implemented');
  }

  /**
   * Disables storage tracking, prevents storage events from being sent to the client.
   */
  disable() {
    throw new Error('Not implemented');
  }

  /**
   * 
   * @param {StorageId} storageId
   * 
   * @returns {Array.<Item>} entries
   */
  getDOMStorageItems() {
    throw new Error('Not implemented');
  }

  /**
   * 
   * @param {StorageId} storageId
   * @param {string} key
   * @param {string} value
   */
  setDOMStorageItem() {
    throw new Error('Not implemented');
  }

  /**
   * 
   * @param {StorageId} storageId
   * @param {string} key
   */
  removeDOMStorageItem() {
    throw new Error('Not implemented');
  }
}

module.exports = DOMStorageAgent;
