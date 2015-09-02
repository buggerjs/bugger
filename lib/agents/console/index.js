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
    throw new Error('Not implemented');
  }

  /**
   * Disables console domain, prevents further console messages from being reported to the client.
   */
  disable() {
    throw new Error('Not implemented');
  }

  /**
   * Clears console messages collected in the browser.
   */
  clearMessages() {
    throw new Error('Not implemented');
  }
}

module.exports = ConsoleAgent;
