'use strict';
// This file is auto-generated using scripts/doc-sync.js

  /**
   *
   * @param {string touchPressed|touchReleased|touchMoved|touchStationary|touchCancelled} state State of the touch point.
   * @param {integer} x X coordinate of the event relative to the main frame's viewport.
   * @param {integer} y Y coordinate of the event relative to the main frame's viewport. 0 refers to the top of the viewport and Y increases as it proceeds towards the bottom of the viewport.
   * @param {integer=} radiusX X radius of the touch area (default: 1).
   * @param {integer=} radiusY Y radius of the touch area (default: 1).
   * @param {number=} rotationAngle Rotation angle (default: 0.0).
   * @param {number=} force Force (default: 1.0).
   * @param {number=} id Identifier used to track touch sources between events, must be unique within an event.
   */
exports.TouchPoint =
function TouchPoint(props) {
  this.state = props.state;
  this.x = props.x;
  this.y = props.y;
  this.radiusX = props.radiusX;
  this.radiusY = props.radiusY;
  this.rotationAngle = props.rotationAngle;
  this.force = props.force;
  this.id = props.id;
};

  /**
   */
exports.GestureSourceType = String;
