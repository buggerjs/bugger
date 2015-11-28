'use strict';

const BaseAgent = require('../base');

const consoleTracker = require('./tracker');
consoleTracker.enable();

class ConsoleAgent extends BaseAgent {
  constructor() {
    super();

    this._forwardMessage = (message) => {
      this.emit('messageAdded', { message });
    };
  }

  /**
   * Enables console domain, sends the messages collected so far to the client by means of the <code>messageAdded</code> notification.
   */
  enable() {
    // Make sure we don't add the listener twice
    consoleTracker.removeListener('message', this._forwardMessage);
    consoleTracker.on('message', this._forwardMessage);

    for (const message of consoleTracker.buffer) {
      this._forwardMessage(message);
    }
  }

  /**
   * Disables console domain, prevents further console messages from being reported to the client.
   */
  disable() {
    consoleTracker.removeListener('message', this._forwardMessage);
  }

  /**
   * Clears console messages collected in the browser.
   */
  clearMessages() {
    consoleTracker.clearMessages();
  }
}

module.exports = new ConsoleAgent();
