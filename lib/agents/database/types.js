'use strict';
// This file is auto-generated using scripts/doc-sync.js

  /**
   * Unique identifier of Database object.
   */
exports.DatabaseId = String;

  /**
   * Database object.
   * 
   * @param {DatabaseId} id Database ID.
   * @param {string} domain Database domain.
   * @param {string} name Database name.
   * @param {string} version Database version.
   */
exports.Database =
function Database(props) {
  this.id = props.id;
  this.domain = props.domain;
  this.name = props.name;
  this.version = props.version;
};

  /**
   * Database error.
   * 
   * @param {string} message Error message.
   * @param {integer} code Error code.
   */
exports.Error =
function Error(props) {
  this.message = props.message;
  this.code = props.code;
};
