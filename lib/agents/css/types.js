'use strict';
// This file is auto-generated using scripts/doc-sync.js

  /**
   */
exports.StyleSheetId = String;

  /**
   * Stylesheet type: "injected" for stylesheets injected via extension, "user-agent" for user-agent stylesheets, "inspector" for stylesheets created by the inspector (i.e.
   * those holding the "via inspector" rules), "regular" for regular stylesheets.
   */
exports.StyleSheetOrigin = String;

  /**
   * CSS rule collection for a single pseudo style.
   *
   * @param {integer} pseudoId Pseudo style identifier (see <code>enum PseudoId</code> in <code>ComputedStyleConstants.h</code>).
   * @param {Array.<RuleMatch>} matches Matches of CSS rules applicable to the pseudo style.
   */
exports.PseudoIdMatches =
function PseudoIdMatches(props) {
  this.pseudoId = props.pseudoId;
  this.matches = props.matches;
};

  /**
   * Inherited CSS rule collection from ancestor node.
   *
   * @param {CSSStyle=} inlineStyle The ancestor node's inline style, if any, in the style inheritance chain.
   * @param {Array.<RuleMatch>} matchedCSSRules Matches of CSS rules matching the ancestor node in the style inheritance chain.
   */
exports.InheritedStyleEntry =
function InheritedStyleEntry(props) {
  this.inlineStyle = props.inlineStyle;
  this.matchedCSSRules = props.matchedCSSRules;
};

  /**
   * Match data for a CSS rule.
   *
   * @param {CSSRule} rule CSS rule in the match.
   * @param {Array.<integer>} matchingSelectors Matching selector indices in the rule's selectorList selectors (0-based).
   */
exports.RuleMatch =
function RuleMatch(props) {
  this.rule = props.rule;
  this.matchingSelectors = props.matchingSelectors;
};

  /**
   * Data for a simple selector (these are delimited by commas in a selector list).
   *
   * @param {string} value Selector text.
   * @param {SourceRange=} range Selector range in the underlying resource (if available).
   */
exports.Selector =
function Selector(props) {
  this.value = props.value;
  this.range = props.range;
};

  /**
   * Selector list data.
   *
   * @param {Array.<Selector>} selectors Selectors in the list.
   * @param {string} text Rule selector text.
   */
exports.SelectorList =
function SelectorList(props) {
  this.selectors = props.selectors;
  this.text = props.text;
};

  /**
   * CSS stylesheet metainformation.
   *
   * @param {StyleSheetId} styleSheetId The stylesheet identifier.
   * @param {Page.FrameId} frameId Owner frame identifier.
   * @param {string} sourceURL Stylesheet resource URL.
   * @param {string=} sourceMapURL URL of source map associated with the stylesheet (if any).
   * @param {StyleSheetOrigin} origin Stylesheet origin.
   * @param {string} title Stylesheet title.
   * @param {DOM.BackendNodeId=} ownerNode The backend id for the owner node of the stylesheet.
   * @param {boolean} disabled Denotes whether the stylesheet is disabled.
   * @param {boolean=} hasSourceURL Whether the sourceURL field value comes from the sourceURL comment.
   * @param {boolean} isInline Whether this stylesheet is created for STYLE tag by parser. This flag is not set for document.written STYLE tags.
   * @param {number} startLine Line offset of the stylesheet within the resource (zero based).
   * @param {number} startColumn Column offset of the stylesheet within the resource (zero based).
   */
exports.CSSStyleSheetHeader =
function CSSStyleSheetHeader(props) {
  this.styleSheetId = props.styleSheetId;
  this.frameId = props.frameId;
  this.sourceURL = props.sourceURL;
  this.sourceMapURL = props.sourceMapURL;
  this.origin = props.origin;
  this.title = props.title;
  this.ownerNode = props.ownerNode;
  this.disabled = props.disabled;
  this.hasSourceURL = props.hasSourceURL;
  this.isInline = props.isInline;
  this.startLine = props.startLine;
  this.startColumn = props.startColumn;
};

  /**
   * CSS rule representation.
   *
   * @param {StyleSheetId=} styleSheetId The css style sheet identifier (absent for user agent stylesheet and user-specified stylesheet rules) this rule came from.
   * @param {SelectorList} selectorList Rule selector data.
   * @param {StyleSheetOrigin} origin Parent stylesheet's origin.
   * @param {CSSStyle} style Associated style declaration.
   * @param {Array.<CSSMedia>=} media Media list array (for rules involving media queries). The array enumerates media queries starting with the innermost one, going outwards.
   */
exports.CSSRule =
function CSSRule(props) {
  this.styleSheetId = props.styleSheetId;
  this.selectorList = props.selectorList;
  this.origin = props.origin;
  this.style = props.style;
  this.media = props.media;
};

  /**
   * Text range within a resource.
   * All numbers are zero-based.
   *
   * @param {integer} startLine Start line of range.
   * @param {integer} startColumn Start column of range (inclusive).
   * @param {integer} endLine End line of range
   * @param {integer} endColumn End column of range (exclusive).
   */
exports.SourceRange =
function SourceRange(props) {
  this.startLine = props.startLine;
  this.startColumn = props.startColumn;
  this.endLine = props.endLine;
  this.endColumn = props.endColumn;
};

  /**
   *
   * @param {string} name Shorthand name.
   * @param {string} value Shorthand value.
   * @param {boolean=} important Whether the property has "!important" annotation (implies <code>false</code> if absent).
   */
exports.ShorthandEntry =
function ShorthandEntry(props) {
  this.name = props.name;
  this.value = props.value;
  this.important = props.important;
};

  /**
   *
   * @param {string} name Computed style property name.
   * @param {string} value Computed style property value.
   */
exports.CSSComputedStyleProperty =
function CSSComputedStyleProperty(props) {
  this.name = props.name;
  this.value = props.value;
};

  /**
   * CSS style representation.
   *
   * @param {StyleSheetId=} styleSheetId The css style sheet identifier (absent for user agent stylesheet and user-specified stylesheet rules) this rule came from.
   * @param {Array.<CSSProperty>} cssProperties CSS properties in the style.
   * @param {Array.<ShorthandEntry>} shorthandEntries Computed values for all shorthands found in the style.
   * @param {string=} cssText Style declaration text (if available).
   * @param {SourceRange=} range Style declaration range in the enclosing stylesheet (if available).
   */
exports.CSSStyle =
function CSSStyle(props) {
  this.styleSheetId = props.styleSheetId;
  this.cssProperties = props.cssProperties;
  this.shorthandEntries = props.shorthandEntries;
  this.cssText = props.cssText;
  this.range = props.range;
};

  /**
   * CSS property declaration data.
   *
   * @param {string} name The property name.
   * @param {string} value The property value.
   * @param {boolean=} important Whether the property has "!important" annotation (implies <code>false</code> if absent).
   * @param {boolean=} implicit Whether the property is implicit (implies <code>false</code> if absent).
   * @param {string=} text The full property text as specified in the style.
   * @param {boolean=} parsedOk Whether the property is understood by the browser (implies <code>true</code> if absent).
   * @param {boolean=} disabled Whether the property is disabled by the user (present for source-based properties only).
   * @param {SourceRange=} range The entire property range in the enclosing style declaration (if available).
   */
exports.CSSProperty =
function CSSProperty(props) {
  this.name = props.name;
  this.value = props.value;
  this.important = props.important;
  this.implicit = props.implicit;
  this.text = props.text;
  this.parsedOk = props.parsedOk;
  this.disabled = props.disabled;
  this.range = props.range;
};

  /**
   * CSS media rule descriptor.
   *
   * @param {string} text Media query text.
   * @param {string mediaRule|importRule|linkedSheet|inlineSheet} source Source of the media query: "mediaRule" if specified by a @media rule, "importRule" if specified by an @import rule, "linkedSheet" if specified by a "media" attribute in a linked stylesheet's LINK tag, "inlineSheet" if specified by a "media" attribute in an inline stylesheet's STYLE tag.
   * @param {string=} sourceURL URL of the document containing the media query description.
   * @param {SourceRange=} range The associated rule (@media or @import) header range in the enclosing stylesheet (if available).
   * @param {StyleSheetId=} parentStyleSheetId Identifier of the stylesheet containing this object (if exists).
   * @param {Array.<MediaQuery>=} mediaList Array of media queries.
   */
exports.CSSMedia =
function CSSMedia(props) {
  this.text = props.text;
  this.source = props.source;
  this.sourceURL = props.sourceURL;
  this.range = props.range;
  this.parentStyleSheetId = props.parentStyleSheetId;
  this.mediaList = props.mediaList;
};

  /**
   * Media query descriptor.
   *
   * @param {Array.<MediaQueryExpression>} expressions Array of media query expressions.
   * @param {boolean} active Whether the media query condition is satisfied.
   */
exports.MediaQuery =
function MediaQuery(props) {
  this.expressions = props.expressions;
  this.active = props.active;
};

  /**
   * Media query expression descriptor.
   *
   * @param {number} value Media query expression value.
   * @param {string} unit Media query expression units.
   * @param {string} feature Media query expression feature.
   * @param {SourceRange=} valueRange The associated range of the value text in the enclosing stylesheet (if available).
   * @param {number=} computedLength Computed length of media query expression (if applicable).
   */
exports.MediaQueryExpression =
function MediaQueryExpression(props) {
  this.value = props.value;
  this.unit = props.unit;
  this.feature = props.feature;
  this.valueRange = props.valueRange;
  this.computedLength = props.computedLength;
};

  /**
   * Information about amount of glyphs that were rendered with given font.
   *
   * @param {string} familyName Font's family name reported by platform.
   * @param {number} glyphCount Amount of glyphs that were rendered with this font.
   */
exports.PlatformFontUsage =
function PlatformFontUsage(props) {
  this.familyName = props.familyName;
  this.glyphCount = props.glyphCount;
};
