'use strict';
// This file is auto-generated using scripts/doc-sync.js

  /**
   * Unique identifier of the Cache object.
   */
exports.CacheId = String;

  /**
   * Data entry.
   *
   * @param {string} request Request url spec.
   * @param {string} response Response stataus text.
   */
exports.DataEntry =
function DataEntry(props) {
  this.request = props.request;
  this.response = props.response;
};

  /**
   * Cache identifier.
   *
   * @param {CacheId} cacheId An opaque unique id of the cache.
   * @param {string} securityOrigin Security origin of the cache.
   * @param {string} cacheName The name of the cache.
   */
exports.Cache =
function Cache(props) {
  this.cacheId = props.cacheId;
  this.securityOrigin = props.securityOrigin;
  this.cacheName = props.cacheName;
};
