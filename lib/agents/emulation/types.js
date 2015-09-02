'use strict';
// This file is auto-generated using scripts/doc-sync.js

  /**
   * Visible page viewport
   * 
   * @param {number} scrollX X scroll offset in CSS pixels.
   * @param {number} scrollY Y scroll offset in CSS pixels.
   * @param {number} contentsWidth Contents width in CSS pixels.
   * @param {number} contentsHeight Contents height in CSS pixels.
   * @param {number} pageScaleFactor Page scale factor.
   * @param {number} minimumPageScaleFactor Minimum page scale factor.
   * @param {number} maximumPageScaleFactor Maximum page scale factor.
   */
exports.Viewport =
function Viewport(props) {
  this.scrollX = props.scrollX;
  this.scrollY = props.scrollY;
  this.contentsWidth = props.contentsWidth;
  this.contentsHeight = props.contentsHeight;
  this.pageScaleFactor = props.pageScaleFactor;
  this.minimumPageScaleFactor = props.minimumPageScaleFactor;
  this.maximumPageScaleFactor = props.maximumPageScaleFactor;
};
