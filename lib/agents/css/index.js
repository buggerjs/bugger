'use strict';

const BaseAgent = require('../base');

class CSSAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   * Enables the CSS agent for the given page.
   * Clients should not assume that the CSS agent has been enabled until the result of this command is received.
   */
  enable() {
    throw new Error('Not implemented');
  }

  /**
   * Disables the CSS agent for the given page.
   */
  disable() {
    throw new Error('Not implemented');
  }

  /**
   * Returns requested styles for a DOM node identified by <code>nodeId</code>.
   * 
   * @param {DOM.NodeId} nodeId
   * @param {boolean=} excludePseudo Whether to exclude pseudo styles (default: false).
   * @param {boolean=} excludeInherited Whether to exclude inherited styles (default: false).
   * 
   * @returns {Array.<RuleMatch>=} matchedCSSRules CSS rules matching this node, from all applicable stylesheets.
   * @returns {Array.<PseudoIdMatches>=} pseudoElements Pseudo style matches for this node.
   * @returns {Array.<InheritedStyleEntry>=} inherited A chain of inherited styles (from the immediate node parent up to the DOM tree root).
   */
  getMatchedStylesForNode() {
    throw new Error('Not implemented');
  }

  /**
   * Returns the styles defined inline (explicitly in the "style" attribute and implicitly, using DOM attributes) for a DOM node identified by <code>nodeId</code>.
   * 
   * @param {DOM.NodeId} nodeId
   * 
   * @returns {CSSStyle=} inlineStyle Inline style for the specified DOM node.
   * @returns {CSSStyle=} attributesStyle Attribute-defined element style (e.g. resulting from "width=20 height=100%").
   */
  getInlineStylesForNode() {
    throw new Error('Not implemented');
  }

  /**
   * Returns the computed style for a DOM node identified by <code>nodeId</code>.
   * 
   * @param {DOM.NodeId} nodeId
   * 
   * @returns {Array.<CSSComputedStyleProperty>} computedStyle Computed style for the specified DOM node.
   */
  getComputedStyleForNode() {
    throw new Error('Not implemented');
  }

  /**
   * Requests information about platform fonts which we used to render child TextNodes in the given node.
   * 
   * @param {DOM.NodeId} nodeId
   * 
   * @returns {Array.<PlatformFontUsage>} fonts Usage statistics for every employed platform font.
   */
  getPlatformFontsForNode() {
    throw new Error('Not implemented');
  }

  /**
   * Returns the current textual content and the URL for a stylesheet.
   * 
   * @param {StyleSheetId} styleSheetId
   * 
   * @returns {string} text The stylesheet text.
   */
  getStyleSheetText() {
    throw new Error('Not implemented');
  }

  /**
   * Sets the new stylesheet text.
   * 
   * @param {StyleSheetId} styleSheetId
   * @param {string} text
   */
  setStyleSheetText() {
    throw new Error('Not implemented');
  }

  /**
   * Modifies the rule selector.
   * 
   * @param {StyleSheetId} styleSheetId
   * @param {SourceRange} range
   * @param {string} selector
   * 
   * @returns {CSSRule} rule The resulting rule after the selector modification.
   */
  setRuleSelector() {
    throw new Error('Not implemented');
  }

  /**
   * Modifies the style text.
   * 
   * @param {StyleSheetId} styleSheetId
   * @param {SourceRange} range
   * @param {string} text
   * 
   * @returns {CSSStyle} style The resulting style after the selector modification.
   */
  setStyleText() {
    throw new Error('Not implemented');
  }

  /**
   * Modifies the rule selector.
   * 
   * @param {StyleSheetId} styleSheetId
   * @param {SourceRange} range
   * @param {string} text
   * 
   * @returns {CSSMedia} media The resulting CSS media rule after modification.
   */
  setMediaText() {
    throw new Error('Not implemented');
  }

  /**
   * Creates a new special "via-inspector" stylesheet in the frame with given <code>frameId</code>.
   * 
   * @param {Page.FrameId} frameId Identifier of the frame where "via-inspector" stylesheet should be created.
   * 
   * @returns {StyleSheetId} styleSheetId Identifier of the created "via-inspector" stylesheet.
   */
  createStyleSheet() {
    throw new Error('Not implemented');
  }

  /**
   * Inserts a new rule with the given <code>ruleText</code> in a stylesheet with given <code>styleSheetId</code>, at the position specified by <code>location</code>.
   * 
   * @param {StyleSheetId} styleSheetId The css style sheet identifier where a new rule should be inserted.
   * @param {string} ruleText The text of a new rule.
   * @param {SourceRange} location Text position of a new rule in the target style sheet.
   * 
   * @returns {CSSRule} rule The newly created rule.
   */
  addRule() {
    throw new Error('Not implemented');
  }

  /**
   * Ensures that the given node will have specified pseudo-classes whenever its style is computed by the browser.
   * 
   * @param {DOM.NodeId} nodeId The element id for which to force the pseudo state.
   * @param {Array.<string active|focus|hover|visited>} forcedPseudoClasses Element pseudo classes to force when computing the element's style.
   */
  forcePseudoState() {
    throw new Error('Not implemented');
  }

  /**
   * Returns all media queries parsed by the rendering engine.
   * 
   * @returns {Array.<CSSMedia>} medias
   */
  getMediaQueries() {
    throw new Error('Not implemented');
  }

  /**
   * Find a rule with the given active property for the given node and set the new value for this property
   * 
   * @param {DOM.NodeId} nodeId The element id for which to set property.
   * @param {string} propertyName
   * @param {string} value
   */
  setEffectivePropertyValueForNode() {
    throw new Error('Not implemented');
  }
}

module.exports = CSSAgent;
