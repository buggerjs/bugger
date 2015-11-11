'use strict';
// This file is auto-generated using scripts/doc-sync.js

  /**
   * Number of seconds since epoch.
   */
exports.Timestamp = Number;

  /**
   * Console message.
   *
   * @param {string xml|javascript|network|console-api|storage|appcache|rendering|security|other|deprecation} source Message source.
   * @param {string log|warning|error|debug|info|revokedError} level Message severity.
   * @param {string} text Message text.
   * @param {string log|dir|dirxml|table|trace|clear|startGroup|startGroupCollapsed|endGroup|assert|profile|profileEnd=} type Console message type.
   * @param {string=} scriptId Script ID of the message origin.
   * @param {string=} url URL of the message origin.
   * @param {integer=} line Line number in the resource that generated this message.
   * @param {integer=} column Column number in the resource that generated this message.
   * @param {integer=} repeatCount Repeat count for repeated messages.
   * @param {Array.<Runtime.RemoteObject>=} parameters Message parameters in case of the formatted message.
   * @param {StackTrace=} stackTrace JavaScript stack trace for assertions and error messages.
   * @param {AsyncStackTrace=} asyncStackTrace Asynchronous JavaScript stack trace that preceded this message, if available.
   * @param {Network.RequestId=} networkRequestId Identifier of the network request associated with this message.
   * @param {Timestamp} timestamp Timestamp, when this message was fired.
   * @param {Runtime.ExecutionContextId=} executionContextId Identifier of the context where this message was created
   * @param {integer=} messageId Message id.
   * @param {integer=} relatedMessageId Related message id.
   */
exports.ConsoleMessage =
function ConsoleMessage(props) {
  this.source = props.source;
  this.level = props.level;
  this.text = props.text;
  this.type = props.type;
  this.scriptId = props.scriptId;
  this.url = props.url;
  this.line = props.line;
  this.column = props.column;
  this.repeatCount = props.repeatCount;
  this.parameters = props.parameters;
  this.stackTrace = props.stackTrace;
  this.asyncStackTrace = props.asyncStackTrace;
  this.networkRequestId = props.networkRequestId;
  this.timestamp = props.timestamp;
  this.executionContextId = props.executionContextId;
  this.messageId = props.messageId;
  this.relatedMessageId = props.relatedMessageId;
};

  /**
   * Stack entry for console errors and assertions.
   *
   * @param {string} functionName JavaScript function name.
   * @param {string} scriptId JavaScript script id.
   * @param {string} url JavaScript script name or url.
   * @param {integer} lineNumber JavaScript script line number.
   * @param {integer} columnNumber JavaScript script column number.
   */
exports.CallFrame =
function CallFrame(props) {
  this.functionName = props.functionName;
  this.scriptId = props.scriptId;
  this.url = props.url;
  this.lineNumber = props.lineNumber;
  this.columnNumber = props.columnNumber;
};

  /**
   * Call frames for assertions or error messages.
   */
exports.StackTrace = function StackTrace(arr) { return arr; };

  /**
   * Asynchronous JavaScript call stack.
   *
   * @param {Array.<CallFrame>} callFrames Call frames of the stack trace.
   * @param {string=} description String label of this stack trace. For async traces this may be a name of the function that initiated the async call.
   * @param {AsyncStackTrace=} asyncStackTrace Next asynchronous stack trace, if any.
   */
exports.AsyncStackTrace =
function AsyncStackTrace(props) {
  this.callFrames = props.callFrames;
  this.description = props.description;
  this.asyncStackTrace = props.asyncStackTrace;
};
