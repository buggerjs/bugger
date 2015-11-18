'use strict';

const BaseAgent = require('../base');

class ServiceWorkerAgent extends BaseAgent {
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
  sendMessage() {
    throw new Error('Not implemented');
  }

  /**
   *
   * @param {string} workerId
   */
  stop() {
    throw new Error('Not implemented');
  }

  /**
   *
   * @param {string} scopeURL
   */
  unregister() {
    throw new Error('Not implemented');
  }

  /**
   *
   * @param {string} scopeURL
   */
  updateRegistration() {
    throw new Error('Not implemented');
  }

  /**
   *
   * @param {string} scopeURL
   */
  startWorker() {
    throw new Error('Not implemented');
  }

  /**
   *
   * @param {string} versionId
   */
  stopWorker() {
    throw new Error('Not implemented');
  }

  /**
   *
   * @param {string} versionId
   */
  inspectWorker() {
    throw new Error('Not implemented');
  }

  /**
   *
   * @param {string} versionId
   */
  skipWaiting() {
    throw new Error('Not implemented');
  }

  /**
   *
   * @param {boolean} debugOnStart
   */
  setDebugOnStart() {
    throw new Error('Not implemented');
  }

  /**
   *
   * @param {string} origin
   * @param {string} registrationId
   * @param {string} data
   */
  deliverPushMessage() {
    throw new Error('Not implemented');
  }

  /**
   *
   * @param {TargetID} targetId
   *
   * @returns {TargetInfo} targetInfo
   */
  getTargetInfo() {
    throw new Error('Not implemented');
  }

  /**
   *
   * @param {TargetID} targetId
   */
  activateTarget() {
    throw new Error('Not implemented');
  }
}

module.exports = new ServiceWorkerAgent();
