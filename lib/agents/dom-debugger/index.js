'use strict';

const BaseAgent = require('../base');

class DOMDebuggerAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   * Sets breakpoint on particular operation with DOM.
   *
   * @param {DOM.NodeId} nodeId Identifier of the node to set breakpoint on.
   * @param {DOMBreakpointType} type Type of the operation to stop upon.
   */
  setDOMBreakpoint() {
    throw new Error('Not implemented');
  }

  /**
   * Removes DOM breakpoint that was set using <code>setDOMBreakpoint</code>.
   *
   * @param {DOM.NodeId} nodeId Identifier of the node to remove breakpoint from.
   * @param {DOMBreakpointType} type Type of the breakpoint to remove.
   */
  removeDOMBreakpoint() {
    throw new Error('Not implemented');
  }

  /**
   * Sets breakpoint on particular DOM event.
   *
   * @param {string} eventName DOM Event name to stop on (any DOM event will do).
   * @param {string=} targetName EventTarget interface name to stop on. If equal to <code>"*"</code> or not provided, will stop on any EventTarget.
   */
  setEventListenerBreakpoint() {
    throw new Error('Not implemented');
  }

  /**
   * Removes breakpoint on particular DOM event.
   *
   * @param {string} eventName Event name.
   * @param {string=} targetName EventTarget interface name.
   */
  removeEventListenerBreakpoint() {
    throw new Error('Not implemented');
  }

  /**
   * Sets breakpoint on particular native event.
   *
   * @param {string} eventName Instrumentation name to stop on.
   */
  setInstrumentationBreakpoint() {
    throw new Error('Not implemented');
  }

  /**
   * Removes breakpoint on particular native event.
   *
   * @param {string} eventName Instrumentation name to stop on.
   */
  removeInstrumentationBreakpoint() {
    throw new Error('Not implemented');
  }

  /**
   * Sets breakpoint on XMLHttpRequest.
   *
   * @param {string} url Resource URL substring. All XHRs having this substring in the URL will get stopped upon.
   */
  setXHRBreakpoint() {
    throw new Error('Not implemented');
  }

  /**
   * Removes breakpoint from XMLHttpRequest.
   *
   * @param {string} url Resource URL substring.
   */
  removeXHRBreakpoint() {
    throw new Error('Not implemented');
  }

  /**
   * Returns event listeners of the given object.
   *
   * @param {Runtime.RemoteObjectId} objectId Identifier of the object to return listeners for.
   *
   * @returns {Array.<EventListener>} listeners Array of relevant listeners.
   */
  getEventListeners() {
    throw new Error('Not implemented');
  }
}

module.exports = DOMDebuggerAgent;
