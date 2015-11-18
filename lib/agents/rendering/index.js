'use strict';

const BaseAgent = require('../base');

class RenderingAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   * Requests that backend shows paint rectangles
   *
   * @param {boolean} result True for showing paint rectangles
   */
  setShowPaintRects() {
    throw new Error('Not implemented');
  }

  /**
   * Requests that backend shows debug borders on layers
   *
   * @param {boolean} show True for showing debug borders
   */
  setShowDebugBorders() {
    throw new Error('Not implemented');
  }

  /**
   * Requests that backend shows the FPS counter
   *
   * @param {boolean} show True for showing the FPS counter
   */
  setShowFPSCounter() {
    throw new Error('Not implemented');
  }

  /**
   * Requests that backend enables continuous painting
   *
   * @param {boolean} enabled True for enabling cointinuous painting
   */
  setContinuousPaintingEnabled() {
    throw new Error('Not implemented');
  }

  /**
   * Requests that backend shows scroll bottleneck rects
   *
   * @param {boolean} show True for showing scroll bottleneck rects
   */
  setShowScrollBottleneckRects() {
    throw new Error('Not implemented');
  }
}

module.exports = new RenderingAgent();
