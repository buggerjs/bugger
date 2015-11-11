'use strict';

const BaseAgent = require('../base');

class AccessibilityAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   * Fetches the accessibility node for this DOM node, if it exists.
   *
   * @param {DOM.NodeId} nodeId ID of node to get accessibility node for.
   *
   * @returns {AXNode=} accessibilityNode The <code>Accessibility.AXNode</code> for this DOM node, if it exists.
   */
  getAXNode() {
    throw new Error('Not implemented');
  }
}

module.exports = AccessibilityAgent;
