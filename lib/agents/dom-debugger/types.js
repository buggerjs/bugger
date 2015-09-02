'use strict';
// This file is auto-generated using scripts/doc-sync.js

  /**
   * DOM breakpoint type.
   */
exports.DOMBreakpointType = String;

  /**
   * Object event listener.
   * 
   * @param {string} type <code>EventListener</code>'s type.
   * @param {boolean} useCapture <code>EventListener</code>'s useCapture.
   * @param {Debugger.Location} location Handler code location.
   * @param {Runtime.RemoteObject=} handler Event handler function value.
   */
exports.EventListener =
function EventListener(props) {
  this.type = props.type;
  this.useCapture = props.useCapture;
  this.location = props.location;
  this.handler = props.handler;
};
