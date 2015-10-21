'use strict';

const BaseAgent = require('../base');

class WorkerAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   */
  enable() {
    this._ignore('enable');
  }

  /**
   */
  disable() {
    this._ignore('disable');
  }

  /**
   * 
   * @param {string} workerId
   * @param {string} message
   */
  sendMessageToWorker() {
    throw new Error('Not implemented');
  }

  /**
   * 
   * @param {string} workerId
   */
  connectToWorker() {
    throw new Error('Not implemented');
  }

  /**
   * 
   * @param {string} workerId
   */
  disconnectFromWorker() {
    throw new Error('Not implemented');
  }

  /**
   * 
   * @param {boolean} value
   */
  setAutoconnectToWorkers(params) {
    this._ignore('setAutoconnectToWorkers', params);
  }
}

module.exports = WorkerAgent;
