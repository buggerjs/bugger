'use strict';
// This file is auto-generated using scripts/doc-sync.js

  /**
   * Timeline record contains information about the recorded activity.
   *
   * @param {string} type Event type.
   * @param {Object} data Event data.
   * @param {number} startTime Start time.
   * @param {number=} endTime End time.
   * @param {Array.<TimelineEvent>=} children Nested records.
   * @param {string=} thread If present, identifies the thread that produced the event.
   * @param {Console.StackTrace=} stackTrace Stack trace.
   * @param {string=} frameId Unique identifier of the frame within the page that the event relates to.
   */
exports.TimelineEvent =
function TimelineEvent(props) {
  this.type = props.type;
  this.data = props.data;
  this.startTime = props.startTime;
  this.endTime = props.endTime;
  this.children = props.children;
  this.thread = props.thread;
  this.stackTrace = props.stackTrace;
  this.frameId = props.frameId;
};
