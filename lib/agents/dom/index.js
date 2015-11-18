'use strict';

const BaseAgent = require('../base');

class DOMAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   * Enables DOM agent for the given page.
   */
  enable(params) {
    return this._ignore('enable', params);
  }

  /**
   * Disables DOM agent for the given page.
   */
  disable(params) {
    return this._ignore('disable', params);
  }

  /**
   * Returns the root DOM node to the caller.
   *
   * @returns {Node} root Resulting node.
   */
  getDocument(params) {
    return this._ignore('getDocument', params);
  }

  /**
   * Requests that children of the node with given id are returned to the caller in form of <code>setChildNodes</code> events where not only immediate children are retrieved, but all children down to the specified depth.
   *
   * @param {NodeId} nodeId Id of the node to get children for.
   * @param {integer=} depth The maximum depth at which children should be retrieved, defaults to 1. Use -1 for the entire subtree or provide an integer larger than 0.
   */
  requestChildNodes() {
    throw new Error('Not implemented');
  }

  /**
   * Executes <code>querySelector</code> on a given node.
   *
   * @param {NodeId} nodeId Id of the node to query upon.
   * @param {string} selector Selector string.
   *
   * @returns {NodeId} nodeId Query selector result.
   */
  querySelector() {
    throw new Error('Not implemented');
  }

  /**
   * Executes <code>querySelectorAll</code> on a given node.
   *
   * @param {NodeId} nodeId Id of the node to query upon.
   * @param {string} selector Selector string.
   *
   * @returns {Array.<NodeId>} nodeIds Query selector result.
   */
  querySelectorAll() {
    throw new Error('Not implemented');
  }

  /**
   * Sets node name for a node with given id.
   *
   * @param {NodeId} nodeId Id of the node to set name for.
   * @param {string} name New node's name.
   *
   * @returns {NodeId} nodeId New node's id.
   */
  setNodeName() {
    throw new Error('Not implemented');
  }

  /**
   * Sets node value for a node with given id.
   *
   * @param {NodeId} nodeId Id of the node to set value for.
   * @param {string} value New node's value.
   */
  setNodeValue() {
    throw new Error('Not implemented');
  }

  /**
   * Removes node with given id.
   *
   * @param {NodeId} nodeId Id of the node to remove.
   */
  removeNode() {
    throw new Error('Not implemented');
  }

  /**
   * Sets attribute for an element with given id.
   *
   * @param {NodeId} nodeId Id of the element to set attribute for.
   * @param {string} name Attribute name.
   * @param {string} value Attribute value.
   */
  setAttributeValue() {
    throw new Error('Not implemented');
  }

  /**
   * Sets attributes on element with given id.
   * This method is useful when user edits some existing attribute value and types in several attribute name/value pairs.
   *
   * @param {NodeId} nodeId Id of the element to set attributes for.
   * @param {string} text Text with a number of attributes. Will parse this text using HTML parser.
   * @param {string=} name Attribute name to replace with new attributes derived from text in case text parsed successfully.
   */
  setAttributesAsText() {
    throw new Error('Not implemented');
  }

  /**
   * Removes attribute with given name from an element with given id.
   *
   * @param {NodeId} nodeId Id of the element to remove attribute from.
   * @param {string} name Name of the attribute to remove.
   */
  removeAttribute() {
    throw new Error('Not implemented');
  }

  /**
   * Returns node's HTML markup.
   *
   * @param {NodeId} nodeId Id of the node to get markup for.
   *
   * @returns {string} outerHTML Outer HTML markup.
   */
  getOuterHTML() {
    throw new Error('Not implemented');
  }

  /**
   * Sets node HTML markup, returns new node id.
   *
   * @param {NodeId} nodeId Id of the node to set markup for.
   * @param {string} outerHTML Outer HTML markup to set.
   */
  setOuterHTML() {
    throw new Error('Not implemented');
  }

  /**
   * Searches for a given string in the DOM tree.
   * Use <code>getSearchResults</code> to access search results or <code>cancelSearch</code> to end this search session.
   *
   * @param {string} query Plain text or query selector or XPath search query.
   * @param {boolean=} includeUserAgentShadowDOM True to search in user agent shadow DOM.
   *
   * @returns {string} searchId Unique search session identifier.
   * @returns {integer} resultCount Number of search results.
   */
  performSearch() {
    throw new Error('Not implemented');
  }

  /**
   * Returns search results from given <code>fromIndex</code> to given <code>toIndex</code> from the sarch with the given identifier.
   *
   * @param {string} searchId Unique search session identifier.
   * @param {integer} fromIndex Start index of the search result to be returned.
   * @param {integer} toIndex End index of the search result to be returned.
   *
   * @returns {Array.<NodeId>} nodeIds Ids of the search result nodes.
   */
  getSearchResults() {
    throw new Error('Not implemented');
  }

  /**
   * Discards search results from the session with the given id.
   * <code>getSearchResults</code> should no longer be called for that search.
   *
   * @param {string} searchId Unique search session identifier.
   */
  discardSearchResults() {
    throw new Error('Not implemented');
  }

  /**
   * Requests that the node is sent to the caller given the JavaScript node object reference.
   * All nodes that form the path from the node to the root are also sent to the client as a series of <code>setChildNodes</code> notifications.
   *
   * @param {Runtime.RemoteObjectId} objectId JavaScript object id to convert into node.
   *
   * @returns {NodeId} nodeId Node id for given object.
   */
  requestNode() {
    throw new Error('Not implemented');
  }

  /**
   * Enters the 'inspect' mode.
   * In this mode, elements that user is hovering over are highlighted.
   * Backend then generates 'inspectNodeRequested' event upon element selection.
   *
   * @param {boolean} enabled True to enable inspection mode, false to disable it.
   * @param {boolean=} inspectUAShadowDOM True to enable inspection mode for user agent shadow DOM.
   * @param {HighlightConfig=} highlightConfig A descriptor for the highlight appearance of hovered-over nodes. May be omitted if <code>enabled == false</code>.
   */
  setInspectModeEnabled() {
    throw new Error('Not implemented');
  }

  /**
   * Highlights given rectangle.
   * Coordinates are absolute with respect to the main frame viewport.
   *
   * @param {integer} x X coordinate
   * @param {integer} y Y coordinate
   * @param {integer} width Rectangle width
   * @param {integer} height Rectangle height
   * @param {RGBA=} color The highlight fill color (default: transparent).
   * @param {RGBA=} outlineColor The highlight outline color (default: transparent).
   */
  highlightRect() {
    throw new Error('Not implemented');
  }

  /**
   * Highlights given quad.
   * Coordinates are absolute with respect to the main frame viewport.
   *
   * @param {Quad} quad Quad to highlight
   * @param {RGBA=} color The highlight fill color (default: transparent).
   * @param {RGBA=} outlineColor The highlight outline color (default: transparent).
   */
  highlightQuad() {
    throw new Error('Not implemented');
  }

  /**
   * Highlights DOM node with given id or with the given JavaScript object wrapper.
   * Either nodeId or objectId must be specified.
   *
   * @param {HighlightConfig} highlightConfig A descriptor for the highlight appearance.
   * @param {NodeId=} nodeId Identifier of the node to highlight.
   * @param {BackendNodeId=} backendNodeId Identifier of the backend node to highlight.
   * @param {Runtime.RemoteObjectId=} objectId JavaScript object id of the node to be highlighted.
   */
  highlightNode() {
    throw new Error('Not implemented');
  }

  /**
   * Hides DOM node highlight.
   */
  hideHighlight() {
    throw new Error('Not implemented');
  }

  /**
   * Highlights owner element of the frame with given id.
   *
   * @param {Page.FrameId} frameId Identifier of the frame to highlight.
   * @param {RGBA=} contentColor The content box highlight fill color (default: transparent).
   * @param {RGBA=} contentOutlineColor The content box highlight outline color (default: transparent).
   */
  highlightFrame() {
    throw new Error('Not implemented');
  }

  /**
   * Requests that the node is sent to the caller given its path.
   * // FIXME, use XPath
   *
   * @param {string} path Path to node in the proprietary format.
   *
   * @returns {NodeId} nodeId Id of the node for given path.
   */
  pushNodeByPathToFrontend() {
    throw new Error('Not implemented');
  }

  /**
   * Requests that a batch of nodes is sent to the caller given their backend node ids.
   *
   * @param {Array.<BackendNodeId>} backendNodeIds The array of backend node ids.
   *
   * @returns {Array.<NodeId>} nodeIds The array of ids of pushed nodes that correspond to the backend ids specified in backendNodeIds.
   */
  pushNodesByBackendIdsToFrontend() {
    throw new Error('Not implemented');
  }

  /**
   * Enables console to refer to the node with given id via $x (see Command Line API for more details $x functions).
   *
   * @param {NodeId} nodeId DOM node id to be accessible by means of $x command line API.
   */
  setInspectedNode() {
    throw new Error('Not implemented');
  }

  /**
   * Resolves JavaScript node object for given node id.
   *
   * @param {NodeId} nodeId Id of the node to resolve.
   * @param {string=} objectGroup Symbolic group name that can be used to release multiple objects.
   *
   * @returns {Runtime.RemoteObject} object JavaScript object wrapper for given node.
   */
  resolveNode() {
    throw new Error('Not implemented');
  }

  /**
   * Returns attributes for the specified node.
   *
   * @param {NodeId} nodeId Id of the node to retrieve attibutes for.
   *
   * @returns {Array.<string>} attributes An interleaved array of node attribute names and values.
   */
  getAttributes() {
    throw new Error('Not implemented');
  }

  /**
   * Creates a deep copy of the specified node and places it into the target container before the given anchor.
   *
   * @param {NodeId} nodeId Id of the node to copy.
   * @param {NodeId} targetNodeId Id of the element to drop the copy into.
   * @param {NodeId=} insertBeforeNodeId Drop the copy before this node (if absent, the copy becomes the last child of <code>targetNodeId</code>).
   *
   * @returns {NodeId} nodeId Id of the node clone.
   */
  copyTo() {
    throw new Error('Not implemented');
  }

  /**
   * Moves node into the new container, places it before the given anchor.
   *
   * @param {NodeId} nodeId Id of the node to move.
   * @param {NodeId} targetNodeId Id of the element to drop the moved node into.
   * @param {NodeId=} insertBeforeNodeId Drop node before this one (if absent, the moved node becomes the last child of <code>targetNodeId</code>).
   *
   * @returns {NodeId} nodeId New id of the moved node.
   */
  moveTo() {
    throw new Error('Not implemented');
  }

  /**
   * Undoes the last performed action.
   */
  undo() {
    throw new Error('Not implemented');
  }

  /**
   * Re-does the last undone action.
   */
  redo() {
    throw new Error('Not implemented');
  }

  /**
   * Marks last undoable state.
   */
  markUndoableState() {
    throw new Error('Not implemented');
  }

  /**
   * Focuses the given element.
   *
   * @param {NodeId} nodeId Id of the node to focus.
   */
  focus() {
    throw new Error('Not implemented');
  }

  /**
   * Sets files for the given file input element.
   *
   * @param {NodeId} nodeId Id of the file input node to set files for.
   * @param {Array.<string>} files Array of file paths to set.
   */
  setFileInputFiles() {
    throw new Error('Not implemented');
  }

  /**
   * Returns boxes for the currently selected nodes.
   *
   * @param {NodeId} nodeId Id of the node to get box model for.
   *
   * @returns {BoxModel} model Box model for the node.
   */
  getBoxModel() {
    throw new Error('Not implemented');
  }

  /**
   * Returns node id at given location.
   *
   * @param {integer} x X coordinate.
   * @param {integer} y Y coordinate.
   *
   * @returns {NodeId} nodeId Id of the node at given coordinates.
   */
  getNodeForLocation() {
    throw new Error('Not implemented');
  }

  /**
   * Returns the id of the nearest ancestor that is a relayout boundary.
   *
   * @param {NodeId} nodeId Id of the node.
   *
   * @returns {NodeId} nodeId Relayout boundary node id for the given node.
   */
  getRelayoutBoundary() {
    throw new Error('Not implemented');
  }

  /**
   * For testing.
   *
   * @param {NodeId} nodeId Id of the node to get highlight object for.
   *
   * @returns {Object} highlight Highlight data for the node.
   */
  getHighlightObjectForTest() {
    throw new Error('Not implemented');
  }
}

module.exports = new DOMAgent();
