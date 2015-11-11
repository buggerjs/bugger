'use strict';

const BaseAgent = require('../base');

class NetworkAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   * Enables network tracking, network events will now be delivered to the client.
   */
  enable() {
  }

  /**
   * Disables network tracking, prevents network events from being sent to the client.
   */
  disable() {
  }

  /**
   * Allows overriding user agent with the given string.
   * 
   * @param {string} userAgent User agent to use.
   */
  setUserAgentOverride() {
    throw new Error('Not implemented');
  }

  /**
   * Specifies whether to always send extra HTTP headers with the requests from this page.
   * 
   * @param {Headers} headers Map with extra HTTP headers.
   */
  setExtraHTTPHeaders() {
    throw new Error('Not implemented');
  }

  /**
   * Returns content served for the given request.
   * 
   * @param {RequestId} requestId Identifier of the network request to get content for.
   * 
   * @returns {string} body Response body.
   * @returns {boolean} base64Encoded True, if content was sent as base64.
   */
  getResponseBody() {
    throw new Error('Not implemented');
  }

  /**
   * This method sends a new XMLHttpRequest which is identical to the original one.
   * The following parameters should be identical: method, url, async, request body, extra headers, withCredentials attribute, user, password.
   * 
   * @param {RequestId} requestId Identifier of XHR to replay.
   */
  replayXHR() {
    throw new Error('Not implemented');
  }

  /**
   * Toggles monitoring of XMLHttpRequest.
   * If <code>true</code>, console will receive messages upon each XHR issued.
   * 
   * @param {boolean} enabled Monitoring enabled state.
   */
  setMonitoringXHREnabled() {
    throw new Error('Not implemented');
  }

  /**
   * Tells whether clearing browser cache is supported.
   * 
   * @returns {boolean} result True if browser cache can be cleared.
   */
  canClearBrowserCache() {
    throw new Error('Not implemented');
  }

  /**
   * Clears browser cache.
   */
  clearBrowserCache() {
    throw new Error('Not implemented');
  }

  /**
   * Tells whether clearing browser cookies is supported.
   * 
   * @returns {boolean} result True if browser cookies can be cleared.
   */
  canClearBrowserCookies() {
    throw new Error('Not implemented');
  }

  /**
   * Clears browser cookies.
   */
  clearBrowserCookies() {
    throw new Error('Not implemented');
  }

  /**
   * Returns all browser cookies.
   * Depending on the backend support, will return detailed cookie information in the <code>cookies</code> field.
   * 
   * @returns {Array.<Cookie>} cookies Array of cookie objects.
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
   * Tells whether emulation of network conditions is supported.
   * 
   * @returns {boolean} result True if emulation of network conditions is supported.
   */
  canEmulateNetworkConditions() {
    return { result: false };
  }

  /**
   * Activates emulation of network conditions.
   * 
   * @param {boolean} offline True to emulate internet disconnection.
   * @param {number} latency Additional latency (ms).
   * @param {number} downloadThroughput Maximal aggregated download throughput.
   * @param {number} uploadThroughput Maximal aggregated upload throughput.
   */
  emulateNetworkConditions() {
    throw new Error('Not implemented');
  }

  /**
   * Toggles ignoring cache for each request.
   * If <code>true</code>, cache will not be used.
   * 
   * @param {boolean} cacheDisabled Cache disabled state.
   */
  setCacheDisabled() {
    throw new Error('Not implemented');
  }

  /**
   * For testing.
   * 
   * @param {integer} maxTotalSize Maximum total buffer size.
   * @param {integer} maxResourceSize Maximum per-resource size.
   */
  setDataSizeLimitsForTest() {
    throw new Error('Not implemented');
  }
}

module.exports = NetworkAgent;
