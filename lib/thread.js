'use strict';

var events = require('events');
var util = require('util');

var ThreadProxy = require('bindings')('DebugThread').ThreadProxy;

class Thread extends events.EventEmitter {
  constructor(filename) {
    super();

    var handleMessage = this._handleMessage.bind(this);
    this._handle = new ThreadProxy(filename, handleMessage);
  }

  /**
   * Actually creates & starts the thread
   */
  start() { // ?
    return this._handle.start();
  }

  /**
   * Emit the message
   */
  _handleMessage(message) {
    this.emit('message', message);
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
