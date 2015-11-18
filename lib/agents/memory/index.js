'use strict';

const BaseAgent = require('../base');

class MemoryAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   *
   * @returns {integer} documents
   * @returns {integer} nodes
   * @returns {integer} jsEventListeners
   */
  getDOMCounters() {
    throw new Error('Not implemented');
  }
}

module.exports = new MemoryAgent();
