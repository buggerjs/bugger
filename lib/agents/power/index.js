'use strict';

const BaseAgent = require('../base');

class PowerAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   * Start power events collection.
   * 
   * 
   */
  start() {
    throw new Error('Not implemented');
  }

  /**
   * Stop power events collection.
   * 
   * 
   */
  end() {
    throw new Error('Not implemented');
  }

  /**
   * Tells whether power profiling is supported.
   * 
   * @returns {boolean} result True if power profiling is supported.
   */
  canProfilePower() {
    throw new Error('Not implemented');
  }

  /**
   * Describes the accuracy level of the data provider.
   * 
   * @returns {string high|moderate|low} result
   */
  getAccuracyLevel() {
    throw new Error('Not implemented');
  }
}

module.exports = PowerAgent;
