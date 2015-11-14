'use strict';

const BaseAgent = require('../base');

const MICRO_PER_SECOND = 1e6;
const NANO_PER_MICRO = 1e3;

class TracingAgent extends BaseAgent {
  constructor() {
    super();
  }

  // Current tracing time in full microseconds
  _getTime() {
    const delta = process.hrtime(this._startTime);
    return (delta[0] * MICRO_PER_SECOND + delta[1] / NANO_PER_MICRO) | 0;
  }

  /**
   * Start trace events collection.
   *
   * @param {string=} categories Category/tag filter
   * @param {string=} options Tracing options
   * @param {number=} bufferUsageReportingInterval If set, the agent will issue bufferUsage events at this interval, specified in milliseconds
   */
  start(params) {
    this._ignore('start', params);
    this._startTime = process.hrtime();
    this._sessionId = 'bugger-session'; // TODO: generate unique id
  }

  /**
   * Stop trace events collection.
   */
  end() {
    this.emit('dataCollected', {
      value: [
        {
          args: { sessionId: this._sessionId },
          cat: 'disabled-by-default-devtools.timeline',
          name: 'TracingStartedInPage',
          ph: 'I', // Instant
          pid: process.pid,
          s: 'g',
          tid: 1,
          ts: this._getTime(),
        },
      ],
    });
    this.emit('tracingComplete', {});
  }

  /**
   * Gets supported tracing categories.
   *
   * @returns {Array.<string>} categories A list of supported tracing categories.
   */
  getCategories() {
    throw new Error('Not implemented');
  }

  /**
   * Request a global memory dump.
   *
   * @returns {string} dumpGuid GUID of the resulting global memory dump.
   * @returns {boolean} success True iff the global memory dump succeeded.
   */
  requestMemoryDump() {
    throw new Error('Not implemented');
  }
}

module.exports = TracingAgent;
