'use strict';
// This file is auto-generated using scripts/doc-sync.js

  /**
   * Unique object identifier.
   */
exports.RemoteObjectId = String;

  /**
   * Mirror object referencing original JavaScript object.
   * 
   * @param {string object|function|undefined|string|number|boolean|symbol} type Object type.
   * @param {string array|null|node|regexp|date|map|set|iterator|generator|error=} subtype Object subtype hint. Specified for <code>object</code> type values only.
   * @param {string=} className Object class (constructor) name. Specified for <code>object</code> type values only.
   * @param {any=} value Remote object value in case of primitive values or JSON values (if it was requested), or description string if the value can not be JSON-stringified (like NaN, Infinity, -Infinity, -0).
   * @param {string=} description String representation of the object.
   * @param {RemoteObjectId=} objectId Unique object identifier (for non-primitive values).
   * @param {ObjectPreview=} preview Preview containing abbreviated property values. Specified for <code>object</code> type values only.
   * @param {CustomPreview=} customPreview
   */
exports.RemoteObject =
function RemoteObject(props) {
  this.type = props.type;
  this.subtype = props.subtype;
  this.className = props.className;
  this.value = props.value;
  this.description = props.description;
  this.objectId = props.objectId;
  this.preview = props.preview;
  this.customPreview = props.customPreview;
};

  /**
   * 
   * @param {string} header
   * @param {boolean} hasBody
   * @param {RemoteObjectId} formatterObjectId
   * @param {RemoteObjectId=} configObjectId
   */
exports.CustomPreview =
function CustomPreview(props) {
  this.header = props.header;
  this.hasBody = props.hasBody;
  this.formatterObjectId = props.formatterObjectId;
  this.configObjectId = props.configObjectId;
};

  /**
   * Object containing abbreviated remote object value.
   * 
   * @param {string object|function|undefined|string|number|boolean|symbol} type Object type.
   * @param {string array|null|node|regexp|date|map|set|iterator|generator|error=} subtype Object subtype hint. Specified for <code>object</code> type values only.
   * @param {string=} description String representation of the object.
   * @param {boolean} lossless Determines whether preview is lossless (contains all information of the original object).
   * @param {boolean} overflow True iff some of the properties or entries of the original object did not fit.
   * @param {Array.<PropertyPreview>} properties List of the properties.
   * @param {Array.<EntryPreview>=} entries List of the entries. Specified for <code>map</code> and <code>set</code> subtype values only.
   */
exports.ObjectPreview =
function ObjectPreview(props) {
  this.type = props.type;
  this.subtype = props.subtype;
  this.description = props.description;
  this.lossless = props.lossless;
  this.overflow = props.overflow;
  this.properties = props.properties;
  this.entries = props.entries;
};

  /**
   * 
   * @param {string} name Property name.
   * @param {string object|function|undefined|string|number|boolean|symbol|accessor} type Object type. Accessor means that the property itself is an accessor property.
   * @param {string=} value User-friendly property value string.
   * @param {ObjectPreview=} valuePreview Nested value preview.
   * @param {string array|null|node|regexp|date|map|set|iterator|generator|error=} subtype Object subtype hint. Specified for <code>object</code> type values only.
   */
exports.PropertyPreview =
function PropertyPreview(props) {
  this.name = props.name;
  this.type = props.type;
  this.value = props.value;
  this.valuePreview = props.valuePreview;
  this.subtype = props.subtype;
};

  /**
   * 
   * @param {ObjectPreview=} key Preview of the key. Specified for map-like collection entries.
   * @param {ObjectPreview} value Preview of the value.
   */
exports.EntryPreview =
function EntryPreview(props) {
  this.key = props.key;
  this.value = props.value;
};

  /**
   * Object property descriptor.
   * 
   * @param {string} name Property name or symbol description.
   * @param {RemoteObject=} value The value associated with the property.
   * @param {boolean=} writable True if the value associated with the property may be changed (data descriptors only).
   * @param {RemoteObject=} get A function which serves as a getter for the property, or <code>undefined</code> if there is no getter (accessor descriptors only).
   * @param {RemoteObject=} set A function which serves as a setter for the property, or <code>undefined</code> if there is no setter (accessor descriptors only).
   * @param {boolean} configurable True if the type of this property descriptor may be changed and if the property may be deleted from the corresponding object.
   * @param {boolean} enumerable True if this property shows up during enumeration of the properties on the corresponding object.
   * @param {boolean=} wasThrown True if the result was thrown during the evaluation.
   * @param {boolean=} isOwn True if the property is owned for the object.
   * @param {RemoteObject=} symbol Property symbol object, if the property is of the <code>symbol</code> type.
   */
exports.PropertyDescriptor =
function PropertyDescriptor(props) {
  this.name = props.name;
  this.value = props.value;
  this.writable = props.writable;
  this.get = props.get;
  this.set = props.set;
  this.configurable = props.configurable;
  this.enumerable = props.enumerable;
  this.wasThrown = props.wasThrown;
  this.isOwn = props.isOwn;
  this.symbol = props.symbol;
};

  /**
   * Object internal property descriptor.
   * This property isn't normally visible in JavaScript code.
   * 
   * @param {string} name Conventional property name.
   * @param {RemoteObject=} value The value associated with the property.
   */
exports.InternalPropertyDescriptor =
function InternalPropertyDescriptor(props) {
  this.name = props.name;
  this.value = props.value;
};

  /**
   * Represents function call argument.
   * Either remote object id <code>objectId</code> or primitive <code>value</code> or neither of (for undefined) them should be specified.
   * 
   * @param {any=} value Primitive value, or description string if the value can not be JSON-stringified (like NaN, Infinity, -Infinity, -0).
   * @param {RemoteObjectId=} objectId Remote object handle.
   * @param {string object|function|undefined|string|number|boolean|symbol=} type Object type.
   */
exports.CallArgument =
function CallArgument(props) {
  this.value = props.value;
  this.objectId = props.objectId;
  this.type = props.type;
};

  /**
   * Id of an execution context.
   */
exports.ExecutionContextId = Number;

  /**
   * Description of an isolated world.
   * 
   * @param {ExecutionContextId} id Unique id of the execution context. It can be used to specify in which execution context script evaluation should be performed.
   * @param {string=} type Context type. It is used e.g. to distinguish content scripts from web page script.
   * @param {string} origin Execution context origin.
   * @param {string} name Human readable name describing given context.
   * @param {string} frameId Id of the owning frame. May be an empty string if the context is not associated with a frame.
   */
exports.ExecutionContextDescription =
function ExecutionContextDescription(props) {
  this.id = props.id;
  this.type = props.type;
  this.origin = props.origin;
  this.name = props.name;
  this.frameId = props.frameId;
};
