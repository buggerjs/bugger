'use strict';

const path = require('path');

const BaseAgent = require('../base');

class PageAgent extends BaseAgent {
  constructor() {
    super();

    const processUrl = 'file://' + path.join(process.cwd(), '.bugger.json');

    this.rootFrame = {
      id: 'bugger-frame',
      loaderId: 'loader-id',
      url: processUrl,
      securityOrigin: '*',
      mimeType: 'application/json',
    };
  }

  /**
   * Enables page domain notifications.
   */
  enable() {
  }

  /**
   * Disables page domain notifications.
   */
  disable() {
    throw new Error('Not implemented');
  }

  /**
   *
   * @param {string} scriptSource
   *
   * @returns {ScriptIdentifier} identifier Identifier of the added script.
   */
  addScriptToEvaluateOnLoad() {
    throw new Error('Not implemented');
  }

  /**
   *
   * @param {ScriptIdentifier} identifier
   */
  removeScriptToEvaluateOnLoad() {
    throw new Error('Not implemented');
  }

  /**
   * Reloads given page optionally ignoring the cache.
   *
   * @param {boolean=} ignoreCache If true, browser cache is ignored (as if the user pressed Shift+refresh).
   * @param {string=} scriptToEvaluateOnLoad If set, the script will be injected into all frames of the inspected page after reload.
   */
  reload() {
    throw new Error('Not implemented');
  }

  /**
   * Navigates current page to the given URL.
   *
   * @param {string} url URL to navigate the page to.
   *
   * @returns {FrameId} frameId Frame id that will be navigated.
   */
  navigate() {
    throw new Error('Not implemented');
  }

  /**
   * Returns navigation history for the current page.
   *
   *
   *
   * @returns {integer} currentIndex Index of the current navigation history entry.
   * @returns {Array.<NavigationEntry>} entries Array of navigation history entries.
   */
  getNavigationHistory() {
    throw new Error('Not implemented');
  }

  /**
   * Navigates current page to the given history entry.
   *
   * @param {integer} entryId Unique id of the entry to navigate to.
   */
  navigateToHistoryEntry() {
    throw new Error('Not implemented');
  }

  /**
   * Returns all browser cookies.
   * Depending on the backend support, will return detailed cookie information in the <code>cookies</code> field.
   *
   * @returns {Array.<Network.Cookie>} cookies Array of cookie objects.
   */
  getCookies() {
    throw new Error('Not implemented');
  }

  /**
   * Deletes browser cookie with given name, domain and path.
   *
   * @param {string} cookieName Name of the cookie to remove.
   * @param {string} url URL to match cooke domain and path.
   */
  deleteCookie() {
    throw new Error('Not implemented');
  }

  /**
   * Returns present frame / resource tree structure.
   *
   * @returns {FrameResourceTree} frameTree Present frame / resource tree structure.
   */
  getResourceTree() {
    return {
      frameTree: {
        frame: this.rootFrame,
        childFrames: [],
        resources: [],
      },
    };
  }

  /**
   * Returns content of the given resource.
   *
   * @param {FrameId} frameId Frame id to get resource for.
   * @param {string} url URL of the resource to get content for.
   *
   * @returns {string} content Resource content.
   * @returns {boolean} base64Encoded True, if content was served as base64.
   */
  getResourceContent(params) {
    if (params.url === this.rootFrame.url) {
      const meta = { pid: process.pid };
      return {
        content: JSON.stringify(meta, null, 2) + '\n',
        base64Encoded: false,
      };
    }
    throw new Error('Not implemented');
  }

  /**
   * Searches for given string in resource content.
   *
   * @param {FrameId} frameId Frame id for resource to search in.
   * @param {string} url URL of the resource to search in.
   * @param {string} query String to search for.
   * @param {boolean=} caseSensitive If true, search is case sensitive.
   * @param {boolean=} isRegex If true, treats string parameter as regex.
   *
   * @returns {Array.<Debugger.SearchMatch>} result List of search matches.
   */
  searchInResource() {
    throw new Error('Not implemented');
  }

  /**
   * Sets given markup as the document's HTML.
   *
   * @param {FrameId} frameId Frame id to set HTML for.
   * @param {string} html HTML content to set.
   */
  setDocumentContent() {
    throw new Error('Not implemented');
  }

  /**
   * Overrides the values of device screen dimensions (window.screen.width, window.screen.height, window.innerWidth, window.innerHeight, and "device-width"/"device-height"-related CSS media query results).
   *
   * @param {integer} width Overriding width value in pixels (minimum 0, maximum 10000000). 0 disables the override.
   * @param {integer} height Overriding height value in pixels (minimum 0, maximum 10000000). 0 disables the override.
   * @param {number} deviceScaleFactor Overriding device scale factor value. 0 disables the override.
   * @param {boolean} mobile Whether to emulate mobile device. This includes viewport meta tag, overlay scrollbars, text autosizing and more.
   * @param {boolean} fitWindow Whether a view that exceeds the available browser window area should be scaled down to fit.
   * @param {number=} scale Scale to apply to resulting view image. Ignored in |fitWindow| mode.
   * @param {number=} offsetX X offset to shift resulting view image by. Ignored in |fitWindow| mode.
   * @param {number=} offsetY Y offset to shift resulting view image by. Ignored in |fitWindow| mode.
   * @param {integer=} screenWidth Overriding screen width value in pixels (minimum 0, maximum 10000000). Only used for |mobile==true|.
   * @param {integer=} screenHeight Overriding screen height value in pixels (minimum 0, maximum 10000000). Only used for |mobile==true|.
   * @param {integer=} positionX Overriding view X position on screen in pixels (minimum 0, maximum 10000000). Only used for |mobile==true|.
   * @param {integer=} positionY Overriding view Y position on screen in pixels (minimum 0, maximum 10000000). Only used for |mobile==true|.
   */
  setDeviceMetricsOverride() {
    throw new Error('Not implemented');
  }

  /**
   * Clears the overriden device metrics.
   */
  clearDeviceMetricsOverride() {
    throw new Error('Not implemented');
  }

  /**
   * Overrides the Geolocation Position or Error.
   * Omitting any of the parameters emulates position unavailable.
   *
   * @param {number=} latitude Mock latitude
   * @param {number=} longitude Mock longitude
   * @param {number=} accuracy Mock accuracy
   */
  setGeolocationOverride() {
    throw new Error('Not implemented');
  }

  /**
   * Clears the overriden Geolocation Position and Error.
   */
  clearGeolocationOverride() {
    throw new Error('Not implemented');
  }

  /**
   * Overrides the Device Orientation.
   *
   * @param {number} alpha Mock alpha
   * @param {number} beta Mock beta
   * @param {number} gamma Mock gamma
   */
  setDeviceOrientationOverride() {
    throw new Error('Not implemented');
  }

  /**
   * Clears the overridden Device Orientation.
   */
  clearDeviceOrientationOverride() {
    throw new Error('Not implemented');
  }

  /**
   * Toggles mouse event-based touch event emulation.
   *
   * @param {boolean} enabled Whether the touch event emulation should be enabled.
   * @param {string mobile|desktop=} configuration Touch/gesture events configuration. Default: current platform.
   */
  setTouchEmulationEnabled(params) {
    return this._ignore('setTouchEmulationEnabled', params);
  }

  /**
   * Capture page screenshot.
   *
   *
   *
   * @returns {string} data Base64-encoded image data (PNG).
   */
  captureScreenshot() {
    throw new Error('Not implemented');
  }

  /**
   * Tells whether screencast is supported.
   *
   * @returns {boolean} result True if screencast is supported.
   */
  canScreencast() {
    return { result: false };
  }

  /**
   * Starts sending each frame using the <code>screencastFrame</code> event.
   *
   * @param {string jpeg|png=} format Image compression format.
   * @param {integer=} quality Compression quality from range [0..100].
   * @param {integer=} maxWidth Maximum screenshot width.
   * @param {integer=} maxHeight Maximum screenshot height.
   */
  startScreencast() {
    throw new Error('Not implemented');
  }

  /**
   * Stops sending each frame in the <code>screencastFrame</code>.
   */
  stopScreencast() {
    throw new Error('Not implemented');
  }

  /**
   * Acknowledges that a screencast frame has been received by the frontend.
   *
   * @param {integer} frameNumber Frame number.
   */
  screencastFrameAck() {
    throw new Error('Not implemented');
  }

  /**
   * Accepts or dismisses a JavaScript initiated dialog (alert, confirm, prompt, or onbeforeunload).
   *
   * @param {boolean} accept Whether to accept or dismiss the dialog.
   * @param {string=} promptText The text to enter into the dialog prompt before accepting. Used only if this is a prompt dialog.
   */
  handleJavaScriptDialog() {
    throw new Error('Not implemented');
  }

  /**
   * Paints viewport size upon main frame resize.
   *
   * @param {boolean} show Whether to paint size or not.
   * @param {boolean=} showGrid Whether to paint grid as well.
   */
  setShowViewportSizeOnResize(params) {
    return this._ignore('setShowViewportSizeOnResize', params);
  }

  /**
   * Shows / hides color picker
   *
   * @param {boolean} enabled Shows / hides color picker
   */
  setColorPickerEnabled() {
    return this._ignore('setColorPickerEnabled');
  }

  /**
   * Sets overlay message.
   *
   * @param {string=} message Overlay message to display when paused in debugger.
   */
  setOverlayMessage() {
    return this._ignore('setOverlayMessage');
  }
}

module.exports = new PageAgent();
