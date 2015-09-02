'use strict';

const BaseAgent = require('../base');

class ScreenOrientationAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   * Overrides the Screen Orientation.
   * 
   * @param {integer} angle Orientation angle
   * @param {OrientationType} type Orientation type
   */
  setScreenOrientationOverride() {
    throw new Error('Not implemented');
  }

  /**
   * Clears the overridden Screen Orientation.
   */
  clearScreenOrientationOverride() {
    throw new Error('Not implemented');
  }
}

module.exports = ScreenOrientationAgent;
