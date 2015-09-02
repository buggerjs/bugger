'use strict';
// This file is auto-generated using scripts/doc-sync.js

  /**
   * Unique DOM node identifier.
   */
exports.NodeId = Number;

  /**
   * Unique DOM node identifier used to reference a node that may not have been pushed to the front-end.
   */
exports.BackendNodeId = Number;

  /**
   * Backend node with a friendly name.
   * 
   * @param {integer} nodeType <code>Node</code>'s nodeType.
   * @param {string} nodeName <code>Node</code>'s nodeName.
   * @param {BackendNodeId} backendNodeId
   */
exports.BackendNode =
function BackendNode(props) {
  this.nodeType = props.nodeType;
  this.nodeName = props.nodeName;
  this.backendNodeId = props.backendNodeId;
};

  /**
   * Pseudo element type.
   */
exports.PseudoType = String;

  /**
   * Shadow root type.
   */
exports.ShadowRootType = String;

  /**
   * DOM interaction is implemented in terms of mirror objects that represent the actual DOM nodes.
   * DOMNode is a base node mirror type.
   * 
   * @param {NodeId} nodeId Node identifier that is passed into the rest of the DOM messages as the <code>nodeId</code>. Backend will only push node with given <code>id</code> once. It is aware of all requested nodes and will only fire DOM events for nodes known to the client.
   * @param {integer} nodeType <code>Node</code>'s nodeType.
   * @param {string} nodeName <code>Node</code>'s nodeName.
   * @param {string} localName <code>Node</code>'s localName.
   * @param {string} nodeValue <code>Node</code>'s nodeValue.
   * @param {integer=} childNodeCount Child count for <code>Container</code> nodes.
   * @param {Array.<Node>=} children Child nodes of this node when requested with children.
   * @param {Array.<string>=} attributes Attributes of the <code>Element</code> node in the form of flat array <code>[name1, value1, name2, value2]</code>.
   * @param {string=} documentURL Document URL that <code>Document</code> or <code>FrameOwner</code> node points to.
   * @param {string=} baseURL Base URL that <code>Document</code> or <code>FrameOwner</code> node uses for URL completion.
   * @param {string=} publicId <code>DocumentType</code>'s publicId.
   * @param {string=} systemId <code>DocumentType</code>'s systemId.
   * @param {string=} internalSubset <code>DocumentType</code>'s internalSubset.
   * @param {string=} xmlVersion <code>Document</code>'s XML version in case of XML documents.
   * @param {string=} name <code>Attr</code>'s name.
   * @param {string=} value <code>Attr</code>'s value.
   * @param {PseudoType=} pseudoType Pseudo element type for this node.
   * @param {ShadowRootType=} shadowRootType Shadow root type.
   * @param {Page.FrameId=} frameId Frame ID for frame owner elements.
   * @param {Node=} contentDocument Content document for frame owner elements.
   * @param {Array.<Node>=} shadowRoots Shadow root list for given element host.
   * @param {Node=} templateContent Content document fragment for template elements.
   * @param {Array.<Node>=} pseudoElements Pseudo elements associated with this node.
   * @param {Node=} importedDocument Import document for the HTMLImport links.
   * @param {Array.<BackendNode>=} distributedNodes Distributed nodes for given insertion point.
   */
exports.Node =
function Node(props) {
  this.nodeId = props.nodeId;
  this.nodeType = props.nodeType;
  this.nodeName = props.nodeName;
  this.localName = props.localName;
  this.nodeValue = props.nodeValue;
  this.childNodeCount = props.childNodeCount;
  this.children = props.children;
  this.attributes = props.attributes;
  this.documentURL = props.documentURL;
  this.baseURL = props.baseURL;
  this.publicId = props.publicId;
  this.systemId = props.systemId;
  this.internalSubset = props.internalSubset;
  this.xmlVersion = props.xmlVersion;
  this.name = props.name;
  this.value = props.value;
  this.pseudoType = props.pseudoType;
  this.shadowRootType = props.shadowRootType;
  this.frameId = props.frameId;
  this.contentDocument = props.contentDocument;
  this.shadowRoots = props.shadowRoots;
  this.templateContent = props.templateContent;
  this.pseudoElements = props.pseudoElements;
  this.importedDocument = props.importedDocument;
  this.distributedNodes = props.distributedNodes;
};

  /**
   * A structure holding an RGBA color.
   * 
   * @param {integer} r The red component, in the [0-255] range.
   * @param {integer} g The green component, in the [0-255] range.
   * @param {integer} b The blue component, in the [0-255] range.
   * @param {number=} a The alpha component, in the [0-1] range (default: 1).
   */
exports.RGBA =
function RGBA(props) {
  this.r = props.r;
  this.g = props.g;
  this.b = props.b;
  this.a = props.a;
};

  /**
   * An array of quad vertices, x immediately followed by y for each point, points clock-wise.
   */
exports.Quad = function(arr) { return arr; };

  /**
   * Box model.
   * 
   * @param {Quad} content Content box
   * @param {Quad} padding Padding box
   * @param {Quad} border Border box
   * @param {Quad} margin Margin box
   * @param {integer} width Node width
   * @param {integer} height Node height
   * @param {ShapeOutsideInfo=} shapeOutside Shape outside coordinates
   */
exports.BoxModel =
function BoxModel(props) {
  this.content = props.content;
  this.padding = props.padding;
  this.border = props.border;
  this.margin = props.margin;
  this.width = props.width;
  this.height = props.height;
  this.shapeOutside = props.shapeOutside;
};

  /**
   * CSS Shape Outside details.
   * 
   * @param {Quad} bounds Shape bounds
   * @param {Array.<any>} shape Shape coordinate details
   * @param {Array.<any>} marginShape Margin shape bounds
   */
exports.ShapeOutsideInfo =
function ShapeOutsideInfo(props) {
  this.bounds = props.bounds;
  this.shape = props.shape;
  this.marginShape = props.marginShape;
};

  /**
   * Rectangle.
   * 
   * @param {number} x X coordinate
   * @param {number} y Y coordinate
   * @param {number} width Rectangle width
   * @param {number} height Rectangle height
   */
exports.Rect =
function Rect(props) {
  this.x = props.x;
  this.y = props.y;
  this.width = props.width;
  this.height = props.height;
};

  /**
   * Configuration data for the highlighting of page elements.
   * 
   * @param {boolean=} showInfo Whether the node info tooltip should be shown (default: false).
   * @param {boolean=} showRulers Whether the rulers should be shown (default: false).
   * @param {boolean=} showExtensionLines Whether the extension lines from node to the rulers should be shown (default: false).
   * @param {boolean=} showLayoutEditor
   * @param {RGBA=} contentColor The content box highlight fill color (default: transparent).
   * @param {RGBA=} paddingColor The padding highlight fill color (default: transparent).
   * @param {RGBA=} borderColor The border highlight fill color (default: transparent).
   * @param {RGBA=} marginColor The margin highlight fill color (default: transparent).
   * @param {RGBA=} eventTargetColor The event target element highlight fill color (default: transparent).
   * @param {RGBA=} shapeColor The shape outside fill color (default: transparent).
   * @param {RGBA=} shapeMarginColor The shape margin fill color (default: transparent).
   */
exports.HighlightConfig =
function HighlightConfig(props) {
  this.showInfo = props.showInfo;
  this.showRulers = props.showRulers;
  this.showExtensionLines = props.showExtensionLines;
  this.showLayoutEditor = props.showLayoutEditor;
  this.contentColor = props.contentColor;
  this.paddingColor = props.paddingColor;
  this.borderColor = props.borderColor;
  this.marginColor = props.marginColor;
  this.eventTargetColor = props.eventTargetColor;
  this.shapeColor = props.shapeColor;
  this.shapeMarginColor = props.shapeMarginColor;
};
