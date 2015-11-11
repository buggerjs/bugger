'use strict';

const events = require('events');

const ThreadProxy = require('bindings')('DebugThread').ThreadProxy;

class Thread extends events.EventEmitter {
  constructor(filename) {
    super();

    this._handle = new ThreadProxy(filename, message =>
      this.emit('message', message));
  }

  /**
   * Actually creates & starts the thread
   */
  start() { // ?
    return this._handle.start();
  }

  /**
   * Block until there's a message
   */
  poll() {
    return this._handle.poll();
  }

  /**
   * Serialize message to buffer & send that over
   */
  postMessage(message) {
    this._handle.postMessage(message);
  }

  /**
   * Free up the handle & close the thread
   */
  close() {
    return this._handle.close();
  }
}

module.exports = function createThread(filename) {
  return new Thread(filename);
};
