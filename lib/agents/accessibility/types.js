'use strict';
// This file is auto-generated using scripts/doc-sync.js

  /**
   * Unique accessibility node identifier.
   */
exports.AXNodeId = String;

  /**
   * Enum of possible property types.
   */
exports.AXValueType = String;

  /**
   * Enum of possible property sources.
   */
exports.AXPropertySourceType = String;

  /**
   * A single source for a computed AX property.
   * 
   * @param {string} name The name/label of this source.
   * @param {AXPropertySourceType} sourceType What type of source this is.
   * @param {any} value The value of this property source.
   * @param {AXValueType} type What type the value should be interpreted as.
   * @param {boolean=} invalid Whether the value for this property is invalid.
   * @param {string=} invalidReason Reason for the value being invalid, if it is.
   */
exports.AXPropertySource =
function AXPropertySource(props) {
  this.name = props.name;
  this.sourceType = props.sourceType;
  this.value = props.value;
  this.type = props.type;
  this.invalid = props.invalid;
  this.invalidReason = props.invalidReason;
};

  /**
   * 
   * @param {string=} idref The IDRef value provided, if any.
   * @param {DOM.BackendNodeId} backendNodeId The BackendNodeId of the related node.
   */
exports.AXRelatedNode =
function AXRelatedNode(props) {
  this.idref = props.idref;
  this.backendNodeId = props.backendNodeId;
};

  /**
   * 
   * @param {string} name The name of this property.
   * @param {AXValue} value The value of this property.
   */
exports.AXProperty =
function AXProperty(props) {
  this.name = props.name;
  this.value = props.value;
};

  /**
   * A single computed AX property.
   * 
   * @param {AXValueType} type The type of this value.
   * @param {any=} value The computed value of this property.
   * @param {AXRelatedNode=} relatedNodeValue The related node value, if any.
   * @param {Array.<AXRelatedNode>=} relatedNodeArrayValue Multiple relted nodes, if applicable.
   * @param {Array.<AXPropertySource>=} sources The sources which contributed to the computation of this property.
   */
exports.AXValue =
function AXValue(props) {
  this.type = props.type;
  this.value = props.value;
  this.relatedNodeValue = props.relatedNodeValue;
  this.relatedNodeArrayValue = props.relatedNodeArrayValue;
  this.sources = props.sources;
};

  /**
   * States which apply to every AX node.
   */
exports.AXGlobalStates = String;

  /**
   * Attributes which apply to nodes in live regions.
   */
exports.AXLiveRegionAttributes = String;

  /**
   */
exports.AXWidgetAttributes = String;

  /**
   * States which apply to widgets.
   */
exports.AXWidgetStates = String;

  /**
   * Relationships between elements other than parent/child/sibling.
   */
exports.AXRelationshipAttributes = String;

  /**
   * A node in the accessibility tree.
   * 
   * @param {AXNodeId} nodeId Unique identifier for this node.
   * @param {boolean} ignored Whether this node is ignored for accessibility
   * @param {Array.<AXProperty>=} ignoredReasons Collection of reasons why this node is hidden.
   * @param {AXValue=} role This <code>Node</code>'s role, whether explicit or implicit.
   * @param {AXValue=} name The accessible name for this <code>Node</code>.
   * @param {AXValue=} description The accessible description for this <code>Node</code>.
   * @param {AXValue=} value The value for this <code>Node</code>.
   * @param {AXValue=} help Help.
   * @param {Array.<AXProperty>=} properties All other properties
   */
exports.AXNode =
function AXNode(props) {
  this.nodeId = props.nodeId;
  this.ignored = props.ignored;
  this.ignoredReasons = props.ignoredReasons;
  this.role = props.role;
  this.name = props.name;
  this.description = props.description;
  this.value = props.value;
  this.help = props.help;
  this.properties = props.properties;
};
