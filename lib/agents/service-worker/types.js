'use strict';
// This file is auto-generated using scripts/doc-sync.js

  /**
   * ServiceWorker registration.
   *
   * @param {string} registrationId
   * @param {string} scopeURL
   * @param {boolean=} isDeleted
   */
exports.ServiceWorkerRegistration =
function ServiceWorkerRegistration(props) {
  this.registrationId = props.registrationId;
  this.scopeURL = props.scopeURL;
  this.isDeleted = props.isDeleted;
};

  /**
   */
exports.ServiceWorkerVersionRunningStatus = String;

  /**
   */
exports.ServiceWorkerVersionStatus = String;

  /**
   */
exports.TargetID = String;

  /**
   * ServiceWorker version.
   *
   * @param {string} versionId
   * @param {string} registrationId
   * @param {string} scriptURL
   * @param {ServiceWorkerVersionRunningStatus} runningStatus
   * @param {ServiceWorkerVersionStatus} status
   * @param {number=} scriptLastModified The Last-Modified header value of the main script.
   * @param {number=} scriptResponseTime The time at which the response headers of the main script were received from the server.  For cached script it is the last time the cache entry was validated.
   * @param {Array.<TargetID>=} controlledClients
   */
exports.ServiceWorkerVersion =
function ServiceWorkerVersion(props) {
  this.versionId = props.versionId;
  this.registrationId = props.registrationId;
  this.scriptURL = props.scriptURL;
  this.runningStatus = props.runningStatus;
  this.status = props.status;
  this.scriptLastModified = props.scriptLastModified;
  this.scriptResponseTime = props.scriptResponseTime;
  this.controlledClients = props.controlledClients;
};

  /**
   * ServiceWorker error message.
   *
   * @param {string} errorMessage
   * @param {string} registrationId
   * @param {string} versionId
   * @param {string} sourceURL
   * @param {integer} lineNumber
   * @param {integer} columnNumber
   */
exports.ServiceWorkerErrorMessage =
function ServiceWorkerErrorMessage(props) {
  this.errorMessage = props.errorMessage;
  this.registrationId = props.registrationId;
  this.versionId = props.versionId;
  this.sourceURL = props.sourceURL;
  this.lineNumber = props.lineNumber;
  this.columnNumber = props.columnNumber;
};

  /**
   *
   * @param {TargetID} id
   * @param {string} type
   * @param {string} title
   * @param {string} url
   */
exports.TargetInfo =
function TargetInfo(props) {
  this.id = props.id;
  this.type = props.type;
  this.title = props.title;
  this.url = props.url;
};
