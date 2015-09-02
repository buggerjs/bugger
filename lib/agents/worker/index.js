'use strict';

const BaseAgent = require('../base');

class WorkerAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   */
  enable() {
    throw new Error('Not implemented');
  }

  /**
   */
  disable() {
    throw new Error('Not implemented');
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
  setAutoconnectToWorkers() {
    throw new Error('Not implemented');
  }
}

module.exports = WorkerAgent;
