'use strict';

const BaseAgent = require('../base');

class InspectorAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   * Enables inspector domain notifications.
   */
  enable() {
    throw new Error('Not implemented');
  }

  /**
   * Disables inspector domain notifications.
   */
  disable() {
    throw new Error('Not implemented');
  }
}

module.exports = InspectorAgent;
