'use strict';
// This file is auto-generated using scripts/doc-sync.js

  /**
   * Resource type as it was perceived by the rendering engine.
   */
exports.ResourceType = String;

  /**
   * Unique frame identifier.
   */
exports.FrameId = String;

  /**
   * Information about the Frame on the page.
   * 
   * @param {string} id Frame unique identifier.
   * @param {string=} parentId Parent frame identifier.
   * @param {Network.LoaderId} loaderId Identifier of the loader associated with this frame.
   * @param {string=} name Frame's name as specified in the tag.
   * @param {string} url Frame document's URL.
   * @param {string} securityOrigin Frame document's security origin.
   * @param {string} mimeType Frame document's mimeType as determined by the browser.
   */
exports.Frame =
function Frame(props) {
  this.id = props.id;
  this.parentId = props.parentId;
  this.loaderId = props.loaderId;
  this.name = props.name;
  this.url = props.url;
  this.securityOrigin = props.securityOrigin;
  this.mimeType = props.mimeType;
};

  /**
   * Information about the Frame hierarchy along with their cached resources.
   * 
   * @param {Frame} frame Frame information for this tree item.
   * @param {Array.<FrameResourceTree>=} childFrames Child frames.
   * @param {Array.<{url: string, type: ResourceType, mimeType: string, failed: boolean=, canceled: boolean=}>} resources Information about frame resources.
   */
exports.FrameResourceTree =
function FrameResourceTree(props) {
  this.frame = props.frame;
  this.childFrames = props.childFrames;
  this.resources = props.resources;
};

  /**
   * Unique script identifier.
   */
exports.ScriptIdentifier = String;

  /**
   * Navigation history entry.
   * 
   * @param {integer} id Unique id of the navigation history entry.
   * @param {string} url URL of the navigation history entry.
   * @param {string} title Title of the navigation history entry.
   */
exports.NavigationEntry =
function NavigationEntry(props) {
  this.id = props.id;
  this.url = props.url;
  this.title = props.title;
};

  /**
   * Screencast frame metadata
   * 
   * @param {number} offsetTop Top offset in DIP.
   * @param {number} pageScaleFactor Page scale factor.
   * @param {number} deviceWidth Device screen width in DIP.
   * @param {number} deviceHeight Device screen height in DIP.
   * @param {number} scrollOffsetX Position of horizontal scroll in CSS pixels.
   * @param {number} scrollOffsetY Position of vertical scroll in CSS pixels.
   * @param {number=} timestamp Frame swap timestamp.
   */
exports.ScreencastFrameMetadata =
function ScreencastFrameMetadata(props) {
  this.offsetTop = props.offsetTop;
  this.pageScaleFactor = props.pageScaleFactor;
  this.deviceWidth = props.deviceWidth;
  this.deviceHeight = props.deviceHeight;
  this.scrollOffsetX = props.scrollOffsetX;
  this.scrollOffsetY = props.scrollOffsetY;
  this.timestamp = props.timestamp;
};

  /**
   * Javascript dialog type
   */
exports.DialogType = String;
