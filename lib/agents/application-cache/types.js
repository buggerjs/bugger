'use strict';
// This file is auto-generated using scripts/doc-sync.js

  /**
   * Detailed application cache resource information.
   *
   * @param {string} url Resource url.
   * @param {integer} size Resource size.
   * @param {string} type Resource type.
   */
exports.ApplicationCacheResource =
function ApplicationCacheResource(props) {
  this.url = props.url;
  this.size = props.size;
  this.type = props.type;
};

  /**
   * Detailed application cache information.
   *
   * @param {string} manifestURL Manifest URL.
   * @param {number} size Application cache size.
   * @param {number} creationTime Application cache creation time.
   * @param {number} updateTime Application cache update time.
   * @param {Array.<ApplicationCacheResource>} resources Application cache resources.
   */
exports.ApplicationCache =
function ApplicationCache(props) {
  this.manifestURL = props.manifestURL;
  this.size = props.size;
  this.creationTime = props.creationTime;
  this.updateTime = props.updateTime;
  this.resources = props.resources;
};

  /**
   * Frame identifier - manifest URL pair.
   *
   * @param {Page.FrameId} frameId Frame identifier.
   * @param {string} manifestURL Manifest URL.
   * @param {integer} status Application cache status.
   */
exports.FrameWithManifest =
function FrameWithManifest(props) {
  this.frameId = props.frameId;
  this.manifestURL = props.manifestURL;
  this.status = props.status;
};
