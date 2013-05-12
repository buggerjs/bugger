# Domain bindings for CSS
{EventEmitter} = require 'events'

module.exports = (agentContext) ->
  CSS = new EventEmitter()

  # Enables the CSS agent for the given page. Clients should not assume that the CSS agent has been enabled until the result of this command is received.
  CSS.enable = ({}, cb) ->
    # Not implemented

  # Disables the CSS agent for the given page.
  CSS.disable = ({}, cb) ->
    # Not implemented

  # Returns requested styles for a DOM node identified by <code>nodeId</code>.
  #
  # @param nodeId DOM.NodeId 
  # @param includePseudo boolean? Whether to include pseudo styles (default: true).
  # @param includeInherited boolean? Whether to include inherited styles (default: true).
  # @returns matchedCSSRules RuleMatch[]? CSS rules matching this node, from all applicable stylesheets.
  # @returns pseudoElements PseudoIdMatches[]? Pseudo style matches for this node.
  # @returns inherited InheritedStyleEntry[]? A chain of inherited styles (from the immediate node parent up to the DOM tree root).
  CSS.getMatchedStylesForNode = ({nodeId, includePseudo, includeInherited}, cb) ->
    # Not implemented

  # Returns the styles defined inline (explicitly in the "style" attribute and implicitly, using DOM attributes) for a DOM node identified by <code>nodeId</code>.
  #
  # @param nodeId DOM.NodeId 
  # @returns inlineStyle CSSStyle? Inline style for the specified DOM node.
  # @returns attributesStyle CSSStyle? Attribute-defined element style (e.g. resulting from "width=20 height=100%").
  CSS.getInlineStylesForNode = ({nodeId}, cb) ->
    # Not implemented

  # Returns the computed style for a DOM node identified by <code>nodeId</code>.
  #
  # @param nodeId DOM.NodeId 
  # @returns computedStyle CSSComputedStyleProperty[] Computed style for the specified DOM node.
  CSS.getComputedStyleForNode = ({nodeId}, cb) ->
    # Not implemented

  # Returns metainfo entries for all known stylesheets.
  #
  # @returns headers CSSStyleSheetHeader[] Descriptor entries for all available stylesheets.
  CSS.getAllStyleSheets = ({}, cb) ->
    # Not implemented

  # Returns stylesheet data for the specified <code>styleSheetId</code>.
  #
  # @param styleSheetId StyleSheetId 
  # @returns styleSheet CSSStyleSheetBody Stylesheet contents for the specified <code>styleSheetId</code>.
  CSS.getStyleSheet = ({styleSheetId}, cb) ->
    # Not implemented

  # Returns the current textual content and the URL for a stylesheet.
  #
  # @param styleSheetId StyleSheetId 
  # @returns text string The stylesheet text.
  CSS.getStyleSheetText = ({styleSheetId}, cb) ->
    # Not implemented

  # Sets the new stylesheet text, thereby invalidating all existing <code>CSSStyleId</code>'s and <code>CSSRuleId</code>'s contained by this stylesheet.
  #
  # @param styleSheetId StyleSheetId 
  # @param text string 
  CSS.setStyleSheetText = ({styleSheetId, text}, cb) ->
    # Not implemented

  # Sets the new <code>text</code> for the respective style.
  #
  # @param styleId CSSStyleId 
  # @param text string 
  # @returns style CSSStyle The resulting style after the text modification.
  CSS.setStyleText = ({styleId, text}, cb) ->
    # Not implemented

  # Sets the new <code>text</code> for a property in the respective style, at offset <code>propertyIndex</code>. If <code>overwrite</code> is <code>true</code>, a property at the given offset is overwritten, otherwise inserted. <code>text</code> entirely replaces the property <code>name: value</code>.
  #
  # @param styleId CSSStyleId 
  # @param propertyIndex integer 
  # @param text string 
  # @param overwrite boolean 
  # @returns style CSSStyle The resulting style after the property text modification.
  CSS.setPropertyText = ({styleId, propertyIndex, text, overwrite}, cb) ->
    # Not implemented

  # Toggles the property in the respective style, at offset <code>propertyIndex</code>. The <code>disable</code> parameter denotes whether the property should be disabled (i.e. removed from the style declaration). If <code>disable == false</code>, the property gets put back into its original place in the style declaration.
  #
  # @param styleId CSSStyleId 
  # @param propertyIndex integer 
  # @param disable boolean 
  # @returns style CSSStyle The resulting style after the property toggling.
  CSS.toggleProperty = ({styleId, propertyIndex, disable}, cb) ->
    # Not implemented

  # Modifies the rule selector.
  #
  # @param ruleId CSSRuleId 
  # @param selector string 
  # @returns rule CSSRule The resulting rule after the selector modification.
  CSS.setRuleSelector = ({ruleId, selector}, cb) ->
    # Not implemented

  # Creates a new empty rule with the given <code>selector</code> in a special "inspector" stylesheet in the owner document of the context node.
  #
  # @param contextNodeId DOM.NodeId 
  # @param selector string 
  # @returns rule CSSRule The newly created rule.
  CSS.addRule = ({contextNodeId, selector}, cb) ->
    # Not implemented

  # Returns all supported CSS property names.
  #
  # @returns cssProperties CSSPropertyInfo[] Supported property metainfo.
  CSS.getSupportedCSSProperties = ({}, cb) ->
    # Not implemented

  # Ensures that the given node will have specified pseudo-classes whenever its style is computed by the browser.
  #
  # @param nodeId DOM.NodeId The element id for which to force the pseudo state.
  # @param forcedPseudoClasses active|focus|hover|visited[] Element pseudo classes to force when computing the element's style.
  CSS.forcePseudoState = ({nodeId, forcedPseudoClasses}, cb) ->
    # Not implemented

  CSS.startSelectorProfiler = ({}, cb) ->
    # Not implemented

  # @returns profile SelectorProfile 
  CSS.stopSelectorProfiler = ({}, cb) ->
    # Not implemented

  # Returns the Named Flows from the document.
  #
  # @param documentNodeId DOM.NodeId The document node id for which to get the Named Flow Collection.
  # @returns namedFlows NamedFlow[] An array containing the Named Flows in the document.
  CSS.getNamedFlowCollection = ({documentNodeId}, cb) ->
    # Not implemented

  # Fires whenever a MediaQuery result changes (for example, after a browser window has been resized.) The current implementation considers only viewport-dependent media features.
  CSS.emit_mediaQueryResultChanged = (params) ->
    notification = {params, method: 'CSS.mediaQueryResultChanged'}
    @emit 'notification', notification

  # Fired whenever a stylesheet is changed as a result of the client operation.
  #
  # @param styleSheetId StyleSheetId 
  CSS.emit_styleSheetChanged = (params) ->
    notification = {params, method: 'CSS.styleSheetChanged'}
    @emit 'notification', notification

  # Fires when a Named Flow is created.
  #
  # @param namedFlow NamedFlow The new Named Flow.
  CSS.emit_namedFlowCreated = (params) ->
    notification = {params, method: 'CSS.namedFlowCreated'}
    @emit 'notification', notification

  # Fires when a Named Flow is removed: has no associated content nodes and regions.
  #
  # @param documentNodeId DOM.NodeId The document node id.
  # @param flowName string Identifier of the removed Named Flow.
  CSS.emit_namedFlowRemoved = (params) ->
    notification = {params, method: 'CSS.namedFlowRemoved'}
    @emit 'notification', notification

  # Fires when a Named Flow's layout may have changed.
  #
  # @param namedFlow NamedFlow The Named Flow whose layout may have changed.
  CSS.emit_regionLayoutUpdated = (params) ->
    notification = {params, method: 'CSS.regionLayoutUpdated'}
    @emit 'notification', notification

  # # Types
  CSS.StyleSheetId = {"id":"StyleSheetId","type":"string"}
  # This object identifies a CSS style in a unique way.
  CSS.CSSStyleId = {"id":"CSSStyleId","type":"object","properties":[{"name":"styleSheetId","$ref":"StyleSheetId","description":"Enclosing stylesheet identifier."},{"name":"ordinal","type":"integer","description":"The style ordinal within the stylesheet."}],"description":"This object identifies a CSS style in a unique way."}
  # Stylesheet type: "user" for user stylesheets, "user-agent" for user-agent stylesheets, "inspector" for stylesheets created by the inspector (i.e. those holding the "via inspector" rules), "regular" for regular stylesheets.
  CSS.StyleSheetOrigin = {"id":"StyleSheetOrigin","type":"string","enum":["user","user-agent","inspector","regular"],"description":"Stylesheet type: \"user\" for user stylesheets, \"user-agent\" for user-agent stylesheets, \"inspector\" for stylesheets created by the inspector (i.e. those holding the \"via inspector\" rules), \"regular\" for regular stylesheets."}
  # This object identifies a CSS rule in a unique way.
  CSS.CSSRuleId = {"id":"CSSRuleId","type":"object","properties":[{"name":"styleSheetId","$ref":"StyleSheetId","description":"Enclosing stylesheet identifier."},{"name":"ordinal","type":"integer","description":"The rule ordinal within the stylesheet."}],"description":"This object identifies a CSS rule in a unique way."}
  # CSS rule collection for a single pseudo style.
  CSS.PseudoIdMatches = {"id":"PseudoIdMatches","type":"object","properties":[{"name":"pseudoId","type":"integer","description":"Pseudo style identifier (see <code>enum PseudoId</code> in <code>RenderStyleConstants.h</code>)."},{"name":"matches","type":"array","items":{"$ref":"RuleMatch"},"description":"Matches of CSS rules applicable to the pseudo style."}],"description":"CSS rule collection for a single pseudo style."}
  # CSS rule collection for a single pseudo style.
  CSS.InheritedStyleEntry = {"id":"InheritedStyleEntry","type":"object","properties":[{"name":"inlineStyle","$ref":"CSSStyle","optional":true,"description":"The ancestor node's inline style, if any, in the style inheritance chain."},{"name":"matchedCSSRules","type":"array","items":{"$ref":"RuleMatch"},"description":"Matches of CSS rules matching the ancestor node in the style inheritance chain."}],"description":"CSS rule collection for a single pseudo style."}
  # Match data for a CSS rule.
  CSS.RuleMatch = {"id":"RuleMatch","type":"object","properties":[{"name":"rule","$ref":"CSSRule","description":"CSS rule in the match."},{"name":"matchingSelectors","type":"array","items":{"type":"integer"},"description":"Matching selector indices in the rule's selectorList selectors (0-based)."}],"description":"Match data for a CSS rule."}
  # Selector list data.
  CSS.SelectorList = {"id":"SelectorList","type":"object","properties":[{"name":"selectors","type":"array","items":{"type":"string"},"description":"Selectors in the list."},{"name":"text","type":"string","description":"Rule selector text."},{"name":"range","$ref":"SourceRange","optional":true,"description":"Rule selector range in the underlying resource (if available)."}],"description":"Selector list data."}
  # CSS style information for a DOM style attribute.
  CSS.CSSStyleAttribute = {"id":"CSSStyleAttribute","type":"object","properties":[{"name":"name","type":"string","description":"DOM attribute name (e.g. \"width\")."},{"name":"style","$ref":"CSSStyle","description":"CSS style generated by the respective DOM attribute."}],"description":"CSS style information for a DOM style attribute."}
  # CSS stylesheet metainformation.
  CSS.CSSStyleSheetHeader = {"id":"CSSStyleSheetHeader","type":"object","properties":[{"name":"styleSheetId","$ref":"StyleSheetId","description":"The stylesheet identifier."},{"name":"frameId","$ref":"Network.FrameId","description":"Owner frame identifier."},{"name":"sourceURL","type":"string","description":"Stylesheet resource URL."},{"name":"origin","$ref":"StyleSheetOrigin","description":"Stylesheet origin."},{"name":"title","type":"string","description":"Stylesheet title."},{"name":"disabled","type":"boolean","description":"Denotes whether the stylesheet is disabled."}],"description":"CSS stylesheet metainformation."}
  # CSS stylesheet contents.
  CSS.CSSStyleSheetBody = {"id":"CSSStyleSheetBody","type":"object","properties":[{"name":"styleSheetId","$ref":"StyleSheetId","description":"The stylesheet identifier."},{"name":"rules","type":"array","items":{"$ref":"CSSRule"},"description":"Stylesheet resource URL."},{"name":"text","type":"string","optional":true,"description":"Stylesheet resource contents (if available)."}],"description":"CSS stylesheet contents."}
  # CSS rule representation.
  CSS.CSSRule = {"id":"CSSRule","type":"object","properties":[{"name":"ruleId","$ref":"CSSRuleId","optional":true,"description":"The CSS rule identifier (absent for user agent stylesheet and user-specified stylesheet rules)."},{"name":"selectorList","$ref":"SelectorList","description":"Rule selector data."},{"name":"sourceURL","type":"string","optional":true,"description":"Parent stylesheet resource URL (for regular rules)."},{"name":"sourceLine","type":"integer","description":"Line ordinal of the rule selector start character in the resource."},{"name":"origin","$ref":"StyleSheetOrigin","description":"Parent stylesheet's origin."},{"name":"style","$ref":"CSSStyle","description":"Associated style declaration."},{"name":"media","type":"array","items":{"$ref":"CSSMedia"},"optional":true,"description":"Media list array (for rules involving media queries). The array enumerates media queries starting with the innermost one, going outwards."}],"description":"CSS rule representation."}
  # Text range within a resource.
  CSS.SourceRange = {"id":"SourceRange","type":"object","properties":[{"name":"startLine","type":"integer","description":"Start line of range."},{"name":"startColumn","type":"integer","description":"Start column of range (inclusive)."},{"name":"endLine","type":"integer","description":"End line of range"},{"name":"endColumn","type":"integer","description":"End column of range (exclusive)."}],"description":"Text range within a resource."}
  CSS.ShorthandEntry = {"id":"ShorthandEntry","type":"object","properties":[{"name":"name","type":"string","description":"Shorthand name."},{"name":"value","type":"string","description":"Shorthand value."}]}
  CSS.CSSPropertyInfo = {"id":"CSSPropertyInfo","type":"object","properties":[{"name":"name","type":"string","description":"Property name."},{"name":"longhands","type":"array","optional":true,"items":{"type":"string"},"description":"Longhand property names."}]}
  CSS.CSSComputedStyleProperty = {"id":"CSSComputedStyleProperty","type":"object","properties":[{"name":"name","type":"string","description":"Computed style property name."},{"name":"value","type":"string","description":"Computed style property value."}]}
  # CSS style representation.
  CSS.CSSStyle = {"id":"CSSStyle","type":"object","properties":[{"name":"styleId","$ref":"CSSStyleId","optional":true,"description":"The CSS style identifier (absent for attribute styles)."},{"name":"cssProperties","type":"array","items":{"$ref":"CSSProperty"},"description":"CSS properties in the style."},{"name":"shorthandEntries","type":"array","items":{"$ref":"ShorthandEntry"},"description":"Computed values for all shorthands found in the style."},{"name":"cssText","type":"string","optional":true,"description":"Style declaration text (if available)."},{"name":"range","$ref":"SourceRange","optional":true,"description":"Style declaration range in the enclosing stylesheet (if available)."},{"name":"width","type":"string","optional":true,"description":"The effective \"width\" property value from this style."},{"name":"height","type":"string","optional":true,"description":"The effective \"height\" property value from this style."}],"description":"CSS style representation."}
  # CSS style effective visual dimensions and source offsets.
  CSS.CSSProperty = {"id":"CSSProperty","type":"object","properties":[{"name":"name","type":"string","description":"The property name."},{"name":"value","type":"string","description":"The property value."},{"name":"priority","type":"string","optional":true,"description":"The property priority (implies \"\" if absent)."},{"name":"implicit","type":"boolean","optional":true,"description":"Whether the property is implicit (implies <code>false</code> if absent)."},{"name":"text","type":"string","optional":true,"description":"The full property text as specified in the style."},{"name":"parsedOk","type":"boolean","optional":true,"description":"Whether the property is understood by the browser (implies <code>true</code> if absent)."},{"name":"status","type":"string","enum":["active","inactive","disabled","style"],"optional":true,"description":"The property status: \"active\" if the property is effective in the style, \"inactive\" if the property is overridden by a same-named property in this style later on, \"disabled\" if the property is disabled by the user, \"style\" (implied if absent) if the property is reported by the browser rather than by the CSS source parser."},{"name":"range","$ref":"SourceRange","optional":true,"description":"The entire property range in the enclosing style declaration (if available)."}],"description":"CSS style effective visual dimensions and source offsets."}
  # CSS media query descriptor.
  CSS.CSSMedia = {"id":"CSSMedia","type":"object","properties":[{"name":"text","type":"string","description":"Media query text."},{"name":"source","type":"string","enum":["mediaRule","importRule","linkedSheet","inlineSheet"],"description":"Source of the media query: \"mediaRule\" if specified by a @media rule, \"importRule\" if specified by an @import rule, \"linkedSheet\" if specified by a \"media\" attribute in a linked stylesheet's LINK tag, \"inlineSheet\" if specified by a \"media\" attribute in an inline stylesheet's STYLE tag."},{"name":"sourceURL","type":"string","optional":true,"description":"URL of the document containing the media query description."},{"name":"sourceLine","type":"integer","optional":true,"description":"Line in the document containing the media query (not defined for the \"stylesheet\" source)."}],"description":"CSS media query descriptor."}
  # CSS selector profile entry.
  CSS.SelectorProfileEntry = {"id":"SelectorProfileEntry","type":"object","properties":[{"name":"selector","type":"string","description":"CSS selector of the corresponding rule."},{"name":"url","type":"string","description":"URL of the resource containing the corresponding rule."},{"name":"lineNumber","type":"integer","description":"Selector line number in the resource for the corresponding rule."},{"name":"time","type":"number","description":"Total time this rule handling contributed to the browser running time during profiling (in milliseconds.)"},{"name":"hitCount","type":"integer","description":"Number of times this rule was considered a candidate for matching against DOM elements."},{"name":"matchCount","type":"integer","description":"Number of times this rule actually matched a DOM element."}],"description":"CSS selector profile entry."}
  CSS.SelectorProfile = {"id":"SelectorProfile","type":"object","properties":[{"name":"totalTime","type":"number","description":"Total processing time for all selectors in the profile (in milliseconds.)"},{"name":"data","type":"array","items":{"$ref":"SelectorProfileEntry"},"description":"CSS selector profile entries."}]}
  # This object represents a region that flows from a Named Flow.
  CSS.Region = {"id":"Region","type":"object","properties":[{"name":"regionOverset","type":"string","enum":["overset","fit","empty"],"description":"The \"overset\" attribute of a Named Flow."},{"name":"nodeId","$ref":"DOM.NodeId","description":"The corresponding DOM node id."}],"description":"This object represents a region that flows from a Named Flow.","hidden":true}
  # This object represents a Named Flow.
  CSS.NamedFlow = {"id":"NamedFlow","type":"object","properties":[{"name":"documentNodeId","$ref":"DOM.NodeId","description":"The document node id."},{"name":"name","type":"string","description":"Named Flow identifier."},{"name":"overset","type":"boolean","description":"The \"overset\" attribute of a Named Flow."},{"name":"content","type":"array","items":{"$ref":"DOM.NodeId"},"description":"An array of nodes that flow into the Named Flow."},{"name":"regions","type":"array","items":{"$ref":"Region"},"description":"An array of regions associated with the Named Flow."}],"description":"This object represents a Named Flow.","hidden":true}

  return CSS
