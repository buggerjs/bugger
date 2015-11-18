'use strict';

const BaseAgent = require('../base');

class SecurityAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   * Enables tracking security state changes.
   */
  enable() {
    throw new Error('Not implemented');
  }

  /**
   * Disables tracking security state changes.
   */
  disable() {
    throw new Error('Not implemented');
  }
}

module.exports = new SecurityAgent();
