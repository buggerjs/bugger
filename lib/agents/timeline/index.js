'use strict';

const BaseAgent = require('../base');

class TimelineAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   * Deprecated.
   */
  enable() {
    throw new Error('Not implemented');
  }

  /**
   * Deprecated.
   */
  disable() {
    throw new Error('Not implemented');
  }

  /**
   * Deprecated.
   * 
   * @param {integer=} maxCallStackDepth Samples JavaScript stack traces up to <code>maxCallStackDepth</code>, defaults to 5.
   * @param {boolean=} bufferEvents Whether instrumentation events should be buffered and returned upon <code>stop</code> call.
   * @param {string=} liveEvents Coma separated event types to issue although bufferEvents is set.
   * @param {boolean=} includeCounters Whether counters data should be included into timeline events.
   * @param {boolean=} includeGPUEvents Whether events from GPU process should be collected.
   */
  start() {
    throw new Error('Not implemented');
  }

  /**
   * Deprecated.
   */
  stop() {
    throw new Error('Not implemented');
  }
}

module.exports = TimelineAgent;
