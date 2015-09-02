'use strict';
// This file is auto-generated using scripts/doc-sync.js

  /**
   * Database with an array of object stores.
   * 
   * @param {string} name Database name.
   * @param {string} version Deprecated string database version.
   * @param {integer} intVersion Integer database version.
   * @param {Array.<ObjectStore>} objectStores Object stores in this database.
   */
exports.DatabaseWithObjectStores =
function DatabaseWithObjectStores(props) {
  this.name = props.name;
  this.version = props.version;
  this.intVersion = props.intVersion;
  this.objectStores = props.objectStores;
};

  /**
   * Object store.
   * 
   * @param {string} name Object store name.
   * @param {KeyPath} keyPath Object store key path.
   * @param {boolean} autoIncrement If true, object store has auto increment flag set.
   * @param {Array.<ObjectStoreIndex>} indexes Indexes in this object store.
   */
exports.ObjectStore =
function ObjectStore(props) {
  this.name = props.name;
  this.keyPath = props.keyPath;
  this.autoIncrement = props.autoIncrement;
  this.indexes = props.indexes;
};

  /**
   * Object store index.
   * 
   * @param {string} name Index name.
   * @param {KeyPath} keyPath Index key path.
   * @param {boolean} unique If true, index is unique.
   * @param {boolean} multiEntry If true, index allows multiple entries for a key.
   */
exports.ObjectStoreIndex =
function ObjectStoreIndex(props) {
  this.name = props.name;
  this.keyPath = props.keyPath;
  this.unique = props.unique;
  this.multiEntry = props.multiEntry;
};

  /**
   * Key.
   * 
   * @param {string number|string|date|array} type Key type.
   * @param {number=} number Number value.
   * @param {string=} string String value.
   * @param {number=} date Date value.
   * @param {Array.<Key>=} array Array value.
   */
exports.Key =
function Key(props) {
  this.type = props.type;
  this.number = props.number;
  this.string = props.string;
  this.date = props.date;
  this.array = props.array;
};

  /**
   * Key range.
   * 
   * @param {Key=} lower Lower bound.
   * @param {Key=} upper Upper bound.
   * @param {boolean} lowerOpen If true lower bound is open.
   * @param {boolean} upperOpen If true upper bound is open.
   */
exports.KeyRange =
function KeyRange(props) {
  this.lower = props.lower;
  this.upper = props.upper;
  this.lowerOpen = props.lowerOpen;
  this.upperOpen = props.upperOpen;
};

  /**
   * Data entry.
   * 
   * @param {string} key JSON-stringified key object.
   * @param {string} primaryKey JSON-stringified primary key object.
   * @param {string} value JSON-stringified value object.
   */
exports.DataEntry =
function DataEntry(props) {
  this.key = props.key;
  this.primaryKey = props.primaryKey;
  this.value = props.value;
};

  /**
   * Key path.
   * 
   * @param {string null|string|array} type Key path type.
   * @param {string=} string String value.
   * @param {Array.<string>=} array Array value.
   */
exports.KeyPath =
function KeyPath(props) {
  this.type = props.type;
  this.string = props.string;
  this.array = props.array;
};
