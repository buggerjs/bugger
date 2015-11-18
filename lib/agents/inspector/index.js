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
    this._ignore('enable');
  }

  /**
   * Disables inspector domain notifications.
   */
  disable() {
    this._ignore('disable');
  }
}

module.exports = new InspectorAgent();
