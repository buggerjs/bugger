'use strict';
// This file is auto-generated using scripts/doc-sync.js

  /**
   * The security level of a page or resource.
   */
exports.SecurityState = String;

  /**
   * An explanation of an factor contributing to the security state.
   *
   * @param {SecurityState} securityState Security state representing the severity of the factor being explained.
   * @param {string} summary Short phrase describing the type of factor.
   * @param {string} description Full text explanation of the factor.
   */
exports.SecurityStateExplanation =
function SecurityStateExplanation(props) {
  this.securityState = props.securityState;
  this.summary = props.summary;
  this.description = props.description;
};

  /**
   * Information about mixed content on the page.
   *
   * @param {boolean} ranInsecureContent True if the page ran insecure content such as scripts.
   * @param {boolean} displayedInsecureContent True if the page displayed insecure content such as images.
   * @param {SecurityState} ranInsecureContentStyle Security state representing a page that ran insecure content.
   * @param {SecurityState} displayedInsecureContentStyle Security state representing a page that displayed insecure content.
   */
exports.MixedContentStatus =
function MixedContentStatus(props) {
  this.ranInsecureContent = props.ranInsecureContent;
  this.displayedInsecureContent = props.displayedInsecureContent;
  this.ranInsecureContentStyle = props.ranInsecureContentStyle;
  this.displayedInsecureContentStyle = props.displayedInsecureContentStyle;
};
