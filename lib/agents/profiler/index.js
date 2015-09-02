'use strict';

const BaseAgent = require('../base');

class ProfilerAgent extends BaseAgent {
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
   * Changes CPU profiler sampling interval.
   * Must be called before CPU profiles recording started.
   * 
   * @param {integer} interval New sampling interval in microseconds.
   */
  setSamplingInterval() {
    throw new Error('Not implemented');
  }

  /**
   */
  start() {
    throw new Error('Not implemented');
  }

  /**
   * 
   * @returns {CPUProfile} profile Recorded profile.
   */
  stop() {
    throw new Error('Not implemented');
  }
}

module.exports = ProfilerAgent;
