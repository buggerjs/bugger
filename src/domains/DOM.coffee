# Domain bindings for DOM
{EventEmitter} = require 'events'

module.exports = (agentContext) ->
  DOM = new EventEmitter()

  # Returns the root DOM node to the caller.
  #
  # @returns root Node Resulting node.
  DOM.getDocument = ({}, cb) ->
    # Not implemented

  # Requests that children of the node with given id are returned to the caller in form of <code>setChildNodes</code> events where not only immediate children are retrieved, but all children down to the specified depth.
  #
  # @param nodeId NodeId Id of the node to get children for.
  # @param depth integer? The maximum depth at which children should be retrieved, defaults to 1. Use -1 for the entire subtree or provide an integer larger than 0.
  DOM.requestChildNodes = ({nodeId, depth}, cb) ->
    # Not implemented

  # Executes <code>querySelector</code> on a given node.
  #
  # @param nodeId NodeId Id of the node to query upon.
  # @param selector string Selector string.
  # @returns nodeId NodeId Query selector result.
  DOM.querySelector = ({nodeId, selector}, cb) ->
    # Not implemented

  # Executes <code>querySelectorAll</code> on a given node.
  #
  # @param nodeId NodeId Id of the node to query upon.
  # @param selector string Selector string.
  # @returns nodeIds NodeId[] Query selector result.
  DOM.querySelectorAll = ({nodeId, selector}, cb) ->
    # Not implemented

  # Sets node name for a node with given id.
  #
  # @param nodeId NodeId Id of the node to set name for.
  # @param name string New node's name.
  # @returns nodeId NodeId New node's id.
  DOM.setNodeName = ({nodeId, name}, cb) ->
    # Not implemented

  # Sets node value for a node with given id.
  #
  # @param nodeId NodeId Id of the node to set value for.
  # @param value string New node's value.
  DOM.setNodeValue = ({nodeId, value}, cb) ->
    # Not implemented

  # Removes node with given id.
  #
  # @param nodeId NodeId Id of the node to remove.
  DOM.removeNode = ({nodeId}, cb) ->
    # Not implemented

  # Sets attribute for an element with given id.
  #
  # @param nodeId NodeId Id of the element to set attribute for.
  # @param name string Attribute name.
  # @param value string Attribute value.
  DOM.setAttributeValue = ({nodeId, name, value}, cb) ->
    # Not implemented

  # Sets attributes on element with given id. This method is useful when user edits some existing attribute value and types in several attribute name/value pairs.
  #
  # @param nodeId NodeId Id of the element to set attributes for.
  # @param text string Text with a number of attributes. Will parse this text using HTML parser.
  # @param name string? Attribute name to replace with new attributes derived from text in case text parsed successfully.
  DOM.setAttributesAsText = ({nodeId, text, name}, cb) ->
    # Not implemented

  # Removes attribute with given name from an element with given id.
  #
  # @param nodeId NodeId Id of the element to remove attribute from.
  # @param name string Name of the attribute to remove.
  DOM.removeAttribute = ({nodeId, name}, cb) ->
    # Not implemented

  # Returns event listeners relevant to the node.
  #
  # @param nodeId NodeId Id of the node to get listeners for.
  # @param objectGroup string? Symbolic group name for handler value. Handler value is not returned without this parameter specified.
  # @returns listeners EventListener[] Array of relevant listeners.
  DOM.getEventListenersForNode = ({nodeId, objectGroup}, cb) ->
    # Not implemented

  # Returns node's HTML markup.
  #
  # @param nodeId NodeId Id of the node to get markup for.
  # @returns outerHTML string Outer HTML markup.
  DOM.getOuterHTML = ({nodeId}, cb) ->
    # Not implemented

  # Sets node HTML markup, returns new node id.
  #
  # @param nodeId NodeId Id of the node to set markup for.
  # @param outerHTML string Outer HTML markup to set.
  DOM.setOuterHTML = ({nodeId, outerHTML}, cb) ->
    # Not implemented

  # Searches for a given string in the DOM tree. Use <code>getSearchResults</code> to access search results or <code>cancelSearch</code> to end this search session.
  #
  # @param query string Plain text or query selector or XPath search query.
  # @returns searchId string Unique search session identifier.
  # @returns resultCount integer Number of search results.
  DOM.performSearch = ({query}, cb) ->
    # Not implemented

  # Returns search results from given <code>fromIndex</code> to given <code>toIndex</code> from the sarch with the given identifier.
  #
  # @param searchId string Unique search session identifier.
  # @param fromIndex integer Start index of the search result to be returned.
  # @param toIndex integer End index of the search result to be returned.
  # @returns nodeIds NodeId[] Ids of the search result nodes.
  DOM.getSearchResults = ({searchId, fromIndex, toIndex}, cb) ->
    # Not implemented

  # Discards search results from the session with the given id. <code>getSearchResults</code> should no longer be called for that search.
  #
  # @param searchId string Unique search session identifier.
  DOM.discardSearchResults = ({searchId}, cb) ->
    # Not implemented

  # Requests that the node is sent to the caller given the JavaScript node object reference. All nodes that form the path from the node to the root are also sent to the client as a series of <code>setChildNodes</code> notifications.
  #
  # @param objectId Runtime.RemoteObjectId JavaScript object id to convert into node.
  # @returns nodeId NodeId Node id for given object.
  DOM.requestNode = ({objectId}, cb) ->
    # Not implemented

  # Enters the 'inspect' mode. In this mode, elements that user is hovering over are highlighted. Backend then generates 'inspect' command upon element selection.
  #
  # @param enabled boolean True to enable inspection mode, false to disable it.
  # @param highlightConfig HighlightConfig? A descriptor for the highlight appearance of hovered-over nodes. May be omitted if <code>enabled == false</code>.
  DOM.setInspectModeEnabled = ({enabled, highlightConfig}, cb) ->
    # Not implemented

  # Highlights given rectangle. Coordinates are absolute with respect to the main frame viewport.
  #
  # @param x integer X coordinate
  # @param y integer Y coordinate
  # @param width integer Rectangle width
  # @param height integer Rectangle height
  # @param color RGBA? The highlight fill color (default: transparent).
  # @param outlineColor RGBA? The highlight outline color (default: transparent).
  # @param usePageCoordinates boolean? Indicates whether the provided parameters are in page coordinates or in viewport coordinates (the default).
  DOM.highlightRect = ({x, y, width, height, color, outlineColor, usePageCoordinates}, cb) ->
    # Not implemented

  # Highlights given quad. Coordinates are absolute with respect to the main frame viewport.
  #
  # @param quad Quad Quad to highlight
  # @param color RGBA? The highlight fill color (default: transparent).
  # @param outlineColor RGBA? The highlight outline color (default: transparent).
  # @param usePageCoordinates boolean? Indicates whether the provided parameters are in page coordinates or in viewport coordinates (the default).
  DOM.highlightQuad = ({quad, color, outlineColor, usePageCoordinates}, cb) ->
    # Not implemented

  # Highlights DOM node with given id or with the given JavaScript object wrapper. Either nodeId or objectId must be specified.
  #
  # @param highlightConfig HighlightConfig A descriptor for the highlight appearance.
  # @param nodeId NodeId? Identifier of the node to highlight.
  # @param objectId Runtime.RemoteObjectId? JavaScript object id of the node to be highlighted.
  DOM.highlightNode = ({highlightConfig, nodeId, objectId}, cb) ->
    # Not implemented

  # Hides DOM node highlight.
  DOM.hideHighlight = ({}, cb) ->
    # Not implemented

  # Highlights owner element of the frame with given id.
  #
  # @param frameId Network.FrameId Identifier of the frame to highlight.
  # @param contentColor RGBA? The content box highlight fill color (default: transparent).
  # @param contentOutlineColor RGBA? The content box highlight outline color (default: transparent).
  DOM.highlightFrame = ({frameId, contentColor, contentOutlineColor}, cb) ->
    # Not implemented

  # Requests that the node is sent to the caller given its path. // FIXME, use XPath
  #
  # @param path string Path to node in the proprietary format.
  # @returns nodeId NodeId Id of the node for given path.
  DOM.pushNodeByPathToFrontend = ({path}, cb) ->
    # Not implemented

  # Requests that the node is sent to the caller given its backend node id.
  #
  # @param backendNodeId BackendNodeId The backend node id of the node.
  # @returns nodeId NodeId The pushed node's id.
  DOM.pushNodeByBackendIdToFrontend = ({backendNodeId}, cb) ->
    # Not implemented

  # Requests that group of <code>BackendNodeIds</code> is released.
  #
  # @param nodeGroup string The backend node ids group name.
  DOM.releaseBackendNodeIds = ({nodeGroup}, cb) ->
    # Not implemented

  # Resolves JavaScript node object for given node id.
  #
  # @param nodeId NodeId Id of the node to resolve.
  # @param objectGroup string? Symbolic group name that can be used to release multiple objects.
  # @returns object Runtime.RemoteObject JavaScript object wrapper for given node.
  DOM.resolveNode = ({nodeId, objectGroup}, cb) ->
    # Not implemented

  # Returns attributes for the specified node.
  #
  # @param nodeId NodeId Id of the node to retrieve attibutes for.
  # @returns attributes string[] An interleaved array of node attribute names and values.
  DOM.getAttributes = ({nodeId}, cb) ->
    # Not implemented

  # Moves node into the new container, places it before the given anchor.
  #
  # @param nodeId NodeId Id of the node to drop.
  # @param targetNodeId NodeId Id of the element to drop into.
  # @param insertBeforeNodeId NodeId? Drop node before given one.
  # @returns nodeId NodeId New id of the moved node.
  DOM.moveTo = ({nodeId, targetNodeId, insertBeforeNodeId}, cb) ->
    # Not implemented

  # Undoes the last performed action.
  DOM.undo = ({}, cb) ->
    # Not implemented

  # Re-does the last undone action.
  DOM.redo = ({}, cb) ->
    # Not implemented

  # Marks last undoable state.
  DOM.markUndoableState = ({}, cb) ->
    # Not implemented

  # Focuses the given element.
  #
  # @param nodeId NodeId Id of the node to focus.
  DOM.focus = ({nodeId}, cb) ->
    # Not implemented

  # Sets files for the given file input element.
  #
  # @param nodeId NodeId Id of the file input node to set files for.
  # @param files string[] Array of file paths to set.
  DOM.setFileInputFiles = ({nodeId, files}, cb) ->
    # Not implemented

  # Fired when <code>Document</code> has been totally updated. Node ids are no longer valid.
  DOM.emit_documentUpdated = (params) ->
    notification = {params, method: 'DOM.documentUpdated'}
    @emit 'notification', notification

  # Fired when backend wants to provide client with the missing DOM structure. This happens upon most of the calls requesting node ids.
  #
  # @param parentId NodeId Parent node id to populate with children.
  # @param nodes Node[] Child nodes array.
  DOM.emit_setChildNodes = (params) ->
    notification = {params, method: 'DOM.setChildNodes'}
    @emit 'notification', notification

  # Fired when <code>Element</code>'s attribute is modified.
  #
  # @param nodeId NodeId Id of the node that has changed.
  # @param name string Attribute name.
  # @param value string Attribute value.
  DOM.emit_attributeModified = (params) ->
    notification = {params, method: 'DOM.attributeModified'}
    @emit 'notification', notification

  # Fired when <code>Element</code>'s attribute is removed.
  #
  # @param nodeId NodeId Id of the node that has changed.
  # @param name string A ttribute name.
  DOM.emit_attributeRemoved = (params) ->
    notification = {params, method: 'DOM.attributeRemoved'}
    @emit 'notification', notification

  # Fired when <code>Element</code>'s inline style is modified via a CSS property modification.
  #
  # @param nodeIds NodeId[] Ids of the nodes for which the inline styles have been invalidated.
  DOM.emit_inlineStyleInvalidated = (params) ->
    notification = {params, method: 'DOM.inlineStyleInvalidated'}
    @emit 'notification', notification

  # Mirrors <code>DOMCharacterDataModified</code> event.
  #
  # @param nodeId NodeId Id of the node that has changed.
  # @param characterData string New text value.
  DOM.emit_characterDataModified = (params) ->
    notification = {params, method: 'DOM.characterDataModified'}
    @emit 'notification', notification

  # Fired when <code>Container</code>'s child node count has changed.
  #
  # @param nodeId NodeId Id of the node that has changed.
  # @param childNodeCount integer New node count.
  DOM.emit_childNodeCountUpdated = (params) ->
    notification = {params, method: 'DOM.childNodeCountUpdated'}
    @emit 'notification', notification

  # Mirrors <code>DOMNodeInserted</code> event.
  #
  # @param parentNodeId NodeId Id of the node that has changed.
  # @param previousNodeId NodeId If of the previous siblint.
  # @param node Node Inserted node data.
  DOM.emit_childNodeInserted = (params) ->
    notification = {params, method: 'DOM.childNodeInserted'}
    @emit 'notification', notification

  # Mirrors <code>DOMNodeRemoved</code> event.
  #
  # @param parentNodeId NodeId Parent id.
  # @param nodeId NodeId Id of the node that has been removed.
  DOM.emit_childNodeRemoved = (params) ->
    notification = {params, method: 'DOM.childNodeRemoved'}
    @emit 'notification', notification

  # Called when shadow root is pushed into the element.
  #
  # @param hostId NodeId Host element id.
  # @param root Node Shadow root.
  DOM.emit_shadowRootPushed = (params) ->
    notification = {params, method: 'DOM.shadowRootPushed'}
    @emit 'notification', notification

  # Called when shadow root is popped from the element.
  #
  # @param hostId NodeId Host element id.
  # @param rootId NodeId Shadow root id.
  DOM.emit_shadowRootPopped = (params) ->
    notification = {params, method: 'DOM.shadowRootPopped'}
    @emit 'notification', notification

  # # Types
  # Unique DOM node identifier.
  DOM.NodeId = {"id":"NodeId","type":"integer","description":"Unique DOM node identifier."}
  # Unique DOM node identifier used to reference a node that may not have been pushed to the front-end.
  DOM.BackendNodeId = {"id":"BackendNodeId","type":"integer","description":"Unique DOM node identifier used to reference a node that may not have been pushed to the front-end.","hidden":true}
  # DOM interaction is implemented in terms of mirror objects that represent the actual DOM nodes. DOMNode is a base node mirror type.
  DOM.Node = {"id":"Node","type":"object","properties":[{"name":"nodeId","$ref":"NodeId","description":"Node identifier that is passed into the rest of the DOM messages as the <code>nodeId</code>. Backend will only push node with given <code>id</code> once. It is aware of all requested nodes and will only fire DOM events for nodes known to the client."},{"name":"nodeType","type":"integer","description":"<code>Node</code>'s nodeType."},{"name":"nodeName","type":"string","description":"<code>Node</code>'s nodeName."},{"name":"localName","type":"string","description":"<code>Node</code>'s localName."},{"name":"nodeValue","type":"string","description":"<code>Node</code>'s nodeValue."},{"name":"childNodeCount","type":"integer","optional":true,"description":"Child count for <code>Container</code> nodes."},{"name":"children","type":"array","optional":true,"items":{"$ref":"Node"},"description":"Child nodes of this node when requested with children."},{"name":"attributes","type":"array","optional":true,"items":{"type":"string"},"description":"Attributes of the <code>Element</code> node in the form of flat array <code>[name1, value1, name2, value2]</code>."},{"name":"documentURL","type":"string","optional":true,"description":"Document URL that <code>Document</code> or <code>FrameOwner</code> node points to."},{"name":"baseURL","type":"string","optional":true,"description":"Base URL that <code>Document</code> or <code>FrameOwner</code> node uses for URL completion.","hidden":true},{"name":"publicId","type":"string","optional":true,"description":"<code>DocumentType</code>'s publicId."},{"name":"systemId","type":"string","optional":true,"description":"<code>DocumentType</code>'s systemId."},{"name":"internalSubset","type":"string","optional":true,"description":"<code>DocumentType</code>'s internalSubset."},{"name":"xmlVersion","type":"string","optional":true,"description":"<code>Document</code>'s XML version in case of XML documents."},{"name":"name","type":"string","optional":true,"description":"<code>Attr</code>'s name."},{"name":"value","type":"string","optional":true,"description":"<code>Attr</code>'s value."},{"name":"frameId","$ref":"Network.FrameId","optional":true,"description":"Frame ID for frame owner elements.","hidden":true},{"name":"contentDocument","$ref":"Node","optional":true,"description":"Content document for frame owner elements."},{"name":"shadowRoots","type":"array","optional":true,"items":{"$ref":"Node"},"description":"Shadow root list for given element host.","hidden":true},{"name":"templateContent","$ref":"Node","optional":true,"description":"Content document fragment for template elements","hidden":true}],"description":"DOM interaction is implemented in terms of mirror objects that represent the actual DOM nodes. DOMNode is a base node mirror type."}
  # DOM interaction is implemented in terms of mirror objects that represent the actual DOM nodes. DOMNode is a base node mirror type.
  DOM.EventListener = {"id":"EventListener","type":"object","hidden":true,"properties":[{"name":"type","type":"string","description":"<code>EventListener</code>'s type."},{"name":"useCapture","type":"boolean","description":"<code>EventListener</code>'s useCapture."},{"name":"isAttribute","type":"boolean","description":"<code>EventListener</code>'s isAttribute."},{"name":"nodeId","$ref":"NodeId","description":"Target <code>DOMNode</code> id."},{"name":"handlerBody","type":"string","description":"Event handler function body."},{"name":"location","$ref":"Debugger.Location","optional":true,"description":"Handler code location."},{"name":"sourceName","type":"string","optional":true,"description":"Source script URL."},{"name":"handler","$ref":"Runtime.RemoteObject","optional":true,"description":"Event handler function value."}],"description":"DOM interaction is implemented in terms of mirror objects that represent the actual DOM nodes. DOMNode is a base node mirror type."}
  # A structure holding an RGBA color.
  DOM.RGBA = {"id":"RGBA","type":"object","properties":[{"name":"r","type":"integer","description":"The red component, in the [0-255] range."},{"name":"g","type":"integer","description":"The green component, in the [0-255] range."},{"name":"b","type":"integer","description":"The blue component, in the [0-255] range."},{"name":"a","type":"number","optional":true,"description":"The alpha component, in the [0-1] range (default: 1)."}],"description":"A structure holding an RGBA color."}
  # An array of quad vertices, x immediately followed by y for each point, points clock-wise.
  DOM.Quad = {"id":"Quad","type":"array","items":{"type":"number"},"minItems":8,"maxItems":8,"description":"An array of quad vertices, x immediately followed by y for each point, points clock-wise."}
  # Configuration data for the highlighting of page elements.
  DOM.HighlightConfig = {"id":"HighlightConfig","type":"object","properties":[{"name":"showInfo","type":"boolean","optional":true,"description":"Whether the node info tooltip should be shown (default: false)."},{"name":"contentColor","$ref":"RGBA","optional":true,"description":"The content box highlight fill color (default: transparent)."},{"name":"paddingColor","$ref":"RGBA","optional":true,"description":"The padding highlight fill color (default: transparent)."},{"name":"borderColor","$ref":"RGBA","optional":true,"description":"The border highlight fill color (default: transparent)."},{"name":"marginColor","$ref":"RGBA","optional":true,"description":"The margin highlight fill color (default: transparent)."}],"description":"Configuration data for the highlighting of page elements."}

  return DOM
