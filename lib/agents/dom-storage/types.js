'use strict';
// This file is auto-generated using scripts/doc-sync.js

  /**
   * DOM Storage identifier.
   * 
   * @param {string} securityOrigin Security origin for the storage.
   * @param {boolean} isLocalStorage Whether the storage is local storage (not session storage).
   */
exports.StorageId =
function StorageId(props) {
  this.securityOrigin = props.securityOrigin;
  this.isLocalStorage = props.isLocalStorage;
};

  /**
   * DOM Storage item.
   */
exports.Item = function(arr) { return arr; };
