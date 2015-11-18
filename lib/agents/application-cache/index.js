'use strict';

const BaseAgent = require('../base');

class ApplicationCacheAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   * Returns array of frame identifiers with manifest urls for each frame containing a document associated with some application cache.
   *
   * @returns {Array.<FrameWithManifest>} frameIds Array of frame identifiers with manifest urls for each frame containing a document associated with some application cache.
   */
  getFramesWithManifests() {
    throw new Error('Not implemented');
  }

  /**
   * Enables application cache domain notifications.
   */
  enable() {
    throw new Error('Not implemented');
  }

  /**
   * Returns manifest URL for document in the given frame.
   *
   * @param {Page.FrameId} frameId Identifier of the frame containing document whose manifest is retrieved.
   *
   * @returns {string} manifestURL Manifest URL for document in the given frame.
   */
  getManifestForFrame() {
    throw new Error('Not implemented');
  }

  /**
   * Returns relevant application cache data for the document in given frame.
   *
   * @param {Page.FrameId} frameId Identifier of the frame containing document whose application cache is retrieved.
   *
   * @returns {ApplicationCache} applicationCache Relevant application cache data for the document in given frame.
   */
  getApplicationCacheForFrame() {
    throw new Error('Not implemented');
  }
}

module.exports = new ApplicationCacheAgent();
