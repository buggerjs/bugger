'use strict';

const BaseAgent = require('../base');

class ProfilerAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   */
  enable() {
  }

  /**
   */
  disable() {
  }

  /**
   * Changes CPU profiler sampling interval.
   * Must be called before CPU profiles recording started.
   * 
   * @param {integer} interval New sampling interval in microseconds.
   */
  setSamplingInterval(params) {
    // TODO: Update FLAG_cpu_profiler_sampling_interval
    this._ignore('setSamplingInterval', params);
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
