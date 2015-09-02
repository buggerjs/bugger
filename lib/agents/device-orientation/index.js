'use strict';

const BaseAgent = require('../base');

class DeviceOrientationAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   * Overrides the Device Orientation.
   * 
   * @param {number} alpha Mock alpha
   * @param {number} beta Mock beta
   * @param {number} gamma Mock gamma
   */
  setDeviceOrientationOverride() {
    throw new Error('Not implemented');
  }

  /**
   * Clears the overridden Device Orientation.
   */
  clearDeviceOrientationOverride() {
    throw new Error('Not implemented');
  }
}

module.exports = DeviceOrientationAgent;
