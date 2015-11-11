'use strict';

const BaseAgent = require('../base');

class ConsoleAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   * Enables console domain, sends the messages collected so far to the client by means of the <code>messageAdded</code> notification.
   */
  enable() {
  }

  /**
   * Disables console domain, prevents further console messages from being reported to the client.
   */
  disable() {
  }

  /**
   * Clears console messages collected in the browser.
   */
  clearMessages() {
  }
}

module.exports = ConsoleAgent;
