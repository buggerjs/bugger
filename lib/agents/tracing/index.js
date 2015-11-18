'use strict';

const gcStats = require('gc-stats')();

const BaseAgent = require('../base');

const MICRO_PER_SECOND = 1e6;
const NANO_PER_MICRO = 1e3;

const MEASURE_EVERY_MS = 250;

class TracingAgent extends BaseAgent {
  constructor() {
    super();

    this._sessionId = 'bugger-session'; // TODO: generate unique id per trace
    this._buffer = null;
    this._measureTimer = null;

    gcStats.on('stats', stats => this._trackGC(stats));
  }

  // Current tracing time in full microseconds
  _getTime() {
    const delta = process.hrtime();
    return Math.round(delta[0] * MICRO_PER_SECOND + delta[1] / NANO_PER_MICRO);
  }

  _trackGC(stats) {
    if (this._buffer === null) return;
    const name = stats.gctype & 2 ? 'MajorGC' : 'MinorGC';
    const endTime = this._getTime();
    this._buffer.push({
      pid: process.pid,
      tid: 1,
      ts: endTime - Math.round(stats.pause / NANO_PER_MICRO),
      ph: 'B',
      cat: 'devtools.timeline,v8',
      name: name,
      args: {
        // Missing: `"type":"weak processing"`
        usedHeapSizeBefore: stats.before.usedHeapSize,
      },
    }, {
      pid: process.pid,
      tid: 1,
      ts: endTime,
      ph: 'E',
      cat: 'devtools.timeline,v8',
      name: name,
      args: {
        usedHeapSizeAfter: stats.after.usedHeapSize,
      },
    });
  }

  _measure() {
    this._buffer.push({
      args: {
        data: {
          jsHeapSizeUsed: process.memoryUsage().heapUsed,
        },
      },
      cat: 'disabled-by-default-devtools',
      name: 'UpdateCounters',
      ph: 'I',
      pid: process.pid,
      s: 'g',
      tid: 1,
      ts: this._getTime(),
    });
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
    this._buffer = [
      {
        args: { sessionId: this._sessionId },
        cat: 'disabled-by-default-devtools.timeline',
        name: 'TracingStartedInPage',
        ph: 'I',
        pid: process.pid,
        s: 'g',
        tid: 1,
        ts: this._getTime(),
      },
    ];

    clearInterval(this._measureTimer);
    this._measure();
    this._measureTimer = setInterval(this._measure.bind(this), MEASURE_EVERY_MS);
  }

  /**
   * Stop trace events collection.
   */
  end() {
    clearInterval(this._measureTimer);
    this._measureTimer = null;

    this.emit('dataCollected', { value: this._buffer });
    this._buffer = null;
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

module.exports = new TracingAgent();
