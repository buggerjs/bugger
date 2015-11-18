'use strict';

const BaseAgent = require('../base');

class AnimationAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   * Enables animation domain notifications.
   */
  enable() {
    throw new Error('Not implemented');
  }

  /**
   * Disables animation domain notifications.
   */
  disable() {
    throw new Error('Not implemented');
  }

  /**
   * Gets the playback rate of the document timeline.
   *
   * @returns {number} playbackRate Playback rate for animations on page.
   */
  getPlaybackRate() {
    throw new Error('Not implemented');
  }

  /**
   * Sets the playback rate of the document timeline.
   *
   * @param {number} playbackRate Playback rate for animations on page
   */
  setPlaybackRate() {
    throw new Error('Not implemented');
  }

  /**
   * Sets the current time of the document timeline.
   *
   * @param {number} currentTime Current time for the page animation timeline
   */
  setCurrentTime() {
    throw new Error('Not implemented');
  }

  /**
   * Sets the timing of an animation node.
   *
   * @param {string} playerId AnimationPlayer id.
   * @param {number} duration Duration of the animation.
   * @param {number} delay Delay of the animation.
   */
  setTiming() {
    throw new Error('Not implemented');
  }
}

module.exports = new AnimationAgent();
