'use strict';

const BaseAgent = require('../base');

class TracingAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   * Start trace events collection.
   * 
   * @param {string=} categories Category/tag filter
   * @param {string=} options Tracing options
   * @param {number=} bufferUsageReportingInterval If set, the agent will issue bufferUsage events at this interval, specified in milliseconds
   */
  start() {
    throw new Error('Not implemented');
  }

  /**
   * Stop trace events collection.
   */
  end() {
    throw new Error('Not implemented');
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
