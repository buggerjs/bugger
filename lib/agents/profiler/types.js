'use strict';
// This file is auto-generated using scripts/doc-sync.js

  /**
   * CPU Profile node.
   * Holds callsite information, execution statistics and child nodes.
   *
   * @param {string} functionName Function name.
   * @param {Debugger.ScriptId} scriptId Script identifier.
   * @param {string} url URL.
   * @param {integer} lineNumber 1-based line number of the function start position.
   * @param {integer} columnNumber 1-based column number of the function start position.
   * @param {integer} hitCount Number of samples where this node was on top of the call stack.
   * @param {number} callUID Call UID.
   * @param {Array.<CPUProfileNode>} children Child nodes.
   * @param {string} deoptReason The reason of being not optimized. The function may be deoptimized or marked as don't optimize.
   * @param {integer} id Unique id of the node.
   * @param {Array.<PositionTickInfo>} positionTicks An array of source position ticks.
   */
exports.CPUProfileNode =
function CPUProfileNode(props) {
  this.functionName = props.functionName;
  this.scriptId = props.scriptId;
  this.url = props.url;
  this.lineNumber = props.lineNumber;
  this.columnNumber = props.columnNumber;
  this.hitCount = props.hitCount;
  this.callUID = props.callUID;
  this.children = props.children;
  this.deoptReason = props.deoptReason;
  this.id = props.id;
  this.positionTicks = props.positionTicks;
};

  /**
   * Profile.
   *
   * @param {CPUProfileNode} head
   * @param {number} startTime Profiling start time in seconds.
   * @param {number} endTime Profiling end time in seconds.
   * @param {Array.<integer>=} samples Ids of samples top nodes.
   * @param {Array.<number>=} timestamps Timestamps of the samples in microseconds.
   */
exports.CPUProfile =
function CPUProfile(props) {
  this.head = props.head;
  this.startTime = props.startTime;
  this.endTime = props.endTime;
  this.samples = props.samples;
  this.timestamps = props.timestamps;
};

  /**
   * Specifies a number of samples attributed to a certain source position.
   *
   * @param {integer} line Source line number (1-based).
   * @param {integer} ticks Number of samples attributed to the source line.
   */
exports.PositionTickInfo =
function PositionTickInfo(props) {
  this.line = props.line;
  this.ticks = props.ticks;
};
