'use strict';
// This file is auto-generated using scripts/doc-sync.js

  /**
   * Unique loader identifier.
   */
exports.LoaderId = String;

  /**
   * Unique request identifier.
   */
exports.RequestId = String;

  /**
   * Number of seconds since epoch.
   */
exports.Timestamp = Number;

  /**
   * Request / response headers as keys / values of JSON object.
   */
exports.Headers =
function Headers() {

};

  /**
   * Timing information for the request.
   *
   * @param {number} requestTime Timing's requestTime is a baseline in seconds, while the other numbers are ticks in milliseconds relatively to this requestTime.
   * @param {number} proxyStart Started resolving proxy.
   * @param {number} proxyEnd Finished resolving proxy.
   * @param {number} dnsStart Started DNS address resolve.
   * @param {number} dnsEnd Finished DNS address resolve.
   * @param {number} connectStart Started connecting to the remote host.
   * @param {number} connectEnd Connected to the remote host.
   * @param {number} sslStart Started SSL handshake.
   * @param {number} sslEnd Finished SSL handshake.
   * @param {number} workerStart Started running ServiceWorker.
   * @param {number} workerReady Finished Starting ServiceWorker.
   * @param {number} sendStart Started sending request.
   * @param {number} sendEnd Finished sending request.
   * @param {number} receiveHeadersEnd Finished receiving response headers.
   */
exports.ResourceTiming =
function ResourceTiming(props) {
  this.requestTime = props.requestTime;
  this.proxyStart = props.proxyStart;
  this.proxyEnd = props.proxyEnd;
  this.dnsStart = props.dnsStart;
  this.dnsEnd = props.dnsEnd;
  this.connectStart = props.connectStart;
  this.connectEnd = props.connectEnd;
  this.sslStart = props.sslStart;
  this.sslEnd = props.sslEnd;
  this.workerStart = props.workerStart;
  this.workerReady = props.workerReady;
  this.sendStart = props.sendStart;
  this.sendEnd = props.sendEnd;
  this.receiveHeadersEnd = props.receiveHeadersEnd;
};

  /**
   * HTTP request data.
   *
   * @param {string} url Request URL.
   * @param {string} method HTTP request method.
   * @param {Headers} headers HTTP request headers.
   * @param {string=} postData HTTP POST request data.
   */
exports.Request =
function Request(props) {
  this.url = props.url;
  this.method = props.method;
  this.headers = props.headers;
  this.postData = props.postData;
};

  /**
   * An internal certificate ID value.
   */
exports.CertificateId = Number;

  /**
   * Security details about a request.
   *
   * @param {string} protocol Protocol name (e.g. "TLS 1.2" or "QUIC".
   * @param {string} keyExchange Key Exchange used by the connection.
   * @param {string} cipher Cipher name.
   * @param {string=} mac TLS MAC. Note that AEAD ciphers do not have separate MACs.
   * @param {CertificateId} certificateId Certificate ID value.
   */
exports.SecurityDetails =
function SecurityDetails(props) {
  this.protocol = props.protocol;
  this.keyExchange = props.keyExchange;
  this.cipher = props.cipher;
  this.mac = props.mac;
  this.certificateId = props.certificateId;
};

  /**
   * HTTP response data.
   *
   * @param {string} url Response URL. This URL can be different from CachedResource.url in case of redirect.
   * @param {number} status HTTP response status code.
   * @param {string} statusText HTTP response status text.
   * @param {Headers} headers HTTP response headers.
   * @param {string=} headersText HTTP response headers text.
   * @param {string} mimeType Resource mimeType as determined by the browser.
   * @param {Headers=} requestHeaders Refined HTTP request headers that were actually transmitted over the network.
   * @param {string=} requestHeadersText HTTP request headers text.
   * @param {boolean} connectionReused Specifies whether physical connection was actually reused for this request.
   * @param {number} connectionId Physical connection id that was actually used for this request.
   * @param {string=} remoteIPAddress Remote IP address.
   * @param {integer=} remotePort Remote port.
   * @param {boolean=} fromDiskCache Specifies that the request was served from the disk cache.
   * @param {boolean=} fromServiceWorker Specifies that the request was served from the ServiceWorker.
   * @param {number} encodedDataLength Total number of bytes received for this request so far.
   * @param {ResourceTiming=} timing Timing information for the given request.
   * @param {string=} protocol Protocol used to fetch this request.
   * @param {Security.SecurityState} securityState Security state of the request resource.
   * @param {SecurityDetails=} securityDetails Security details for the request.
   */
exports.Response =
function Response(props) {
  this.url = props.url;
  this.status = props.status;
  this.statusText = props.statusText;
  this.headers = props.headers;
  this.headersText = props.headersText;
  this.mimeType = props.mimeType;
  this.requestHeaders = props.requestHeaders;
  this.requestHeadersText = props.requestHeadersText;
  this.connectionReused = props.connectionReused;
  this.connectionId = props.connectionId;
  this.remoteIPAddress = props.remoteIPAddress;
  this.remotePort = props.remotePort;
  this.fromDiskCache = props.fromDiskCache;
  this.fromServiceWorker = props.fromServiceWorker;
  this.encodedDataLength = props.encodedDataLength;
  this.timing = props.timing;
  this.protocol = props.protocol;
  this.securityState = props.securityState;
  this.securityDetails = props.securityDetails;
};

  /**
   * WebSocket request data.
   *
   * @param {Headers} headers HTTP request headers.
   */
exports.WebSocketRequest =
function WebSocketRequest(props) {
  this.headers = props.headers;
};

  /**
   * WebSocket response data.
   *
   * @param {number} status HTTP response status code.
   * @param {string} statusText HTTP response status text.
   * @param {Headers} headers HTTP response headers.
   * @param {string=} headersText HTTP response headers text.
   * @param {Headers=} requestHeaders HTTP request headers.
   * @param {string=} requestHeadersText HTTP request headers text.
   */
exports.WebSocketResponse =
function WebSocketResponse(props) {
  this.status = props.status;
  this.statusText = props.statusText;
  this.headers = props.headers;
  this.headersText = props.headersText;
  this.requestHeaders = props.requestHeaders;
  this.requestHeadersText = props.requestHeadersText;
};

  /**
   * WebSocket frame data.
   *
   * @param {number} opcode WebSocket frame opcode.
   * @param {boolean} mask WebSocke frame mask.
   * @param {string} payloadData WebSocke frame payload data.
   */
exports.WebSocketFrame =
function WebSocketFrame(props) {
  this.opcode = props.opcode;
  this.mask = props.mask;
  this.payloadData = props.payloadData;
};

  /**
   * Information about the cached resource.
   *
   * @param {string} url Resource URL. This is the url of the original network request.
   * @param {Page.ResourceType} type Type of this resource.
   * @param {Response=} response Cached response data.
   * @param {number} bodySize Cached response body size.
   */
exports.CachedResource =
function CachedResource(props) {
  this.url = props.url;
  this.type = props.type;
  this.response = props.response;
  this.bodySize = props.bodySize;
};

  /**
   * Information about the request initiator.
   *
   * @param {string parser|script|other} type Type of this initiator.
   * @param {Console.StackTrace=} stackTrace Initiator JavaScript stack trace, set for Script only.
   * @param {string=} url Initiator URL, set for Parser type only.
   * @param {number=} lineNumber Initiator line number, set for Parser type only.
   * @param {Console.AsyncStackTrace=} asyncStackTrace Initiator asynchronous JavaScript stack trace, if available.
   */
exports.Initiator =
function Initiator(props) {
  this.type = props.type;
  this.stackTrace = props.stackTrace;
  this.url = props.url;
  this.lineNumber = props.lineNumber;
  this.asyncStackTrace = props.asyncStackTrace;
};

  /**
   * Cookie object
   *
   * @param {string} name Cookie name.
   * @param {string} value Cookie value.
   * @param {string} domain Cookie domain.
   * @param {string} path Cookie path.
   * @param {number} expires Cookie expires.
   * @param {integer} size Cookie size.
   * @param {boolean} httpOnly True if cookie is http-only.
   * @param {boolean} secure True if cookie is secure.
   * @param {boolean} session True in case of session cookie.
   */
exports.Cookie =
function Cookie(props) {
  this.name = props.name;
  this.value = props.value;
  this.domain = props.domain;
  this.path = props.path;
  this.expires = props.expires;
  this.size = props.size;
  this.httpOnly = props.httpOnly;
  this.secure = props.secure;
  this.session = props.session;
};
