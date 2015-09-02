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
