'use strict';

const EventEmitter = require('events').EventEmitter;
const Url = require('url');
const http = require('http');

const debug = require('debug')('bugger:network:tracker');

const makeStackTrace = require('../../url-mapper').makeStackTrace;

const STATUS_CODES = http.STATUS_CODES;
const DEFAULT_MIME = 'text/plain';

const tracker = module.exports = new EventEmitter();
tracker._lastRequestId = 0;
tracker.EVENTS = [
  'requestWillBeSent',
  'loadingFailed',
  'responseReceived',
  'dataReceived',
  'loadingFinished',
];
tracker.bodyMap = {};

function isBuggerPatched(obj) {
  return typeof obj.__buggerPatched === 'function';
}

function markBuggerPatched(obj, original) {
  Object.defineProperty(obj, '__buggerPatched', {
    enumerable: false,
    value: original,
  });
}

function wrap(obj, method, wrapper) {
  const original = obj[method];
  if (typeof original !== 'function') {
    debug('No method %s found on object', method);
    return;
  }
  if (isBuggerPatched(original)) return;
  const wrapped = wrapper(original);
  markBuggerPatched(wrapped, original);
  obj[method] = wrapped;
}

function unwrap(obj, method) {
  const current = obj[method];
  const original = current.__buggerPatched;
  if (typeof original === 'function') {
    obj[method] = original;
  }
}

function clone(obj) {
  return Object.keys(obj).reduce((out, key) => {
    out[key] = obj[key];
    return out;
  }, {});
}

function captureErrorEvent(ee, onError) {
  const originalEmit = ee.emit;
  ee.emit = function emitIntercept(event, error) {
    if (event === 'error') { onError(error); }
    return originalEmit.apply(this, arguments);
  };
  return ee;
}

function makeTimestamp() {
  return Date.now() / 1000;
}

function _renderHeaders(req) {
  const headers = req._headers;
  if (!headers) return {};

  const out = {};
  const names = Object.keys(headers);
  names.forEach(name => {
    out[req._headerNames[name]] = String(headers[name]);
  });

  return out;
}

function _getMimeType(headers) {
  if (typeof headers['content-type'] === 'string') {
    return headers['content-type'].split(';')[0] || DEFAULT_MIME;
  }
  return DEFAULT_MIME;
}

function _formatIncomingHeaders(rawHeaders) {
  const out = {};
  for (let idx = 0; idx < rawHeaders.length; idx += 2) {
    const key = rawHeaders[idx];
    const value = rawHeaders[idx + 1];
    if (typeof out[key] === 'string') {
      out[key] += '\n' + value;
    } else {
      out[key] = String(value);
    }
  }
  return out;
}

function wrapRequest(originalRequest) {
  return function request(options, onResponse) {
    let protocol;
    let documentURL;
    let splitPath;
    let urlOptions;
    if (typeof options === 'string') {
      documentURL = options;
      urlOptions = Url.parse(options);
      protocol = urlOptions.protocol || 'http:';
    } else {
      protocol = options.protocol || (options._defaultAgent && options._defaultAgent.protocol) || 'http:';
      urlOptions = clone(options);
      urlOptions.protocol = protocol;
      if (typeof urlOptions.path === 'string' && urlOptions.pathname === undefined) {
        splitPath = urlOptions.path.split('?');
        urlOptions.pathname = splitPath[0];
        urlOptions.search = splitPath[1];
      }
      documentURL = Url.format(urlOptions.uri || urlOptions);
    }

    const initiator = {
      type: 'script',
      stackTrace: makeStackTrace(request),
    };

    const requestId = '' + (++tracker._lastRequestId);
    const loaderId = '' + process.pid;
    const wasAborted = false;
    tracker.bodyMap[requestId] = '';

    let postData = '';
    let totalLength = 0;

    const timing = { requestTime: Date.now() / 1000 };
    const requestTime = process.hrtime();
    function trackTime(type) {
      const hrt = process.hrtime(requestTime);
      timing[type] = hrt[0] * 1e3 + hrt[1] / 1e6;
    }

    let cReq;

    function sendRequestInfo() {
      const data = {
        requestId: requestId,
        loaderId: loaderId,
        documentURL: documentURL,
        request: {
          headers: _renderHeaders(cReq),
          method: cReq.method,
          postData: postData,
          url: documentURL,
        },
        type: 'XHR',
        timestamp: timing.requestTime,
        wallTime: timing.requestTime,
        initiator: initiator,
      };
      tracker.emit('requestWillBeSent', data);
    }

    function onRequestSent() {
      /* jshint validthis:true */
      trackTime('sendEnd');
      sendRequestInfo();
    }

    function onLookup() {
      trackTime('dnsEnd');
    }

    function onSocket(socket) {
      function onConnect() {
        trackTime('connectEnd');
        if (!socket.ssl) {
          trackTime('sendStart');
        }
      }

      function onSecure() {
        trackTime('sslEnd');
        trackTime('sendStart');
      }

      trackTime('connectStart');
      socket.once('connect', onConnect);
      socket.once('secure', onSecure);
      if (socket.ssl) {
        wrap(socket.ssl, 'onhandshakestart', original => {
          return function onTlsHandshakeStart() {
            trackTime('sslStart');
            return original.apply(this, arguments);
          };
        });
      }

      trackTime('dnsStart');
      if (socket.address()) {
        onLookup();
      } else {
        socket.once('lookup', onLookup);
      }
    }

    function onRequestFailed(error) {
      tracker.emit('loadingFailed', {
        requestId: requestId,
        timestamp: makeTimestamp(),
        type: 'XHR',
        errorText: error.message,
        canceled: wasAborted,
      });
    }

    cReq = originalRequest(options);

    function interceptRequestBodyChunk(original) {
      return function write(chunk) {
        if (typeof chunk === 'string' || Buffer.isBuffer(chunk)) {
          postData += chunk.toString();
        } else {
          debug('Could not intercept', typeof chunk);
        }
        return original.apply(this, arguments);
      };
    }

    // TODO: Do we need to handle _writev as well?
    wrap(cReq, 'write', interceptRequestBodyChunk);

    cReq.on('finish', onRequestSent);
    captureErrorEvent(cReq, onRequestFailed);

    if (cReq.socket) {
      onSocket(cReq.socket);
    } else {
      cReq.once('socket', onSocket);
    }

    function patchResponse(cRes) {
      captureErrorEvent(cRes, onRequestFailed);
      trackTime('receiveHeadersEnd');

      const mimeType = _getMimeType(cRes.headers);

      const data = {
        requestId: requestId,
        loaderId: loaderId,
        timestamp: makeTimestamp(),
        type: 'XHR',
        response: {
          timing: timing,
          connectionId: requestId,
          connectionReused: false,
          requestHeaders: _renderHeaders(cReq),
          headers: _formatIncomingHeaders(cRes.rawHeaders),
          mimeType: mimeType,
          status: cRes.statusCode,
          statusText: STATUS_CODES[cRes.statusCode] || '?',
          url: documentURL,
        },
      };
      tracker.emit('responseReceived', data);

      // TODO: this potentially changes the streaming mode

      cRes.on('data', function onResponseChunk(bufferOrString) {
        const chunk = Buffer.isBuffer(data) ?
          bufferOrString : new Buffer(bufferOrString);
        totalLength += chunk.length;
        tracker.bodyMap[requestId] += chunk.toString('base64');
        tracker.emit('dataReceived', {
          requestId: requestId,
          timestamp: makeTimestamp(),
          dataLength: chunk.length,
          encodedDataLength: chunk.length,
        });
      });

      cRes.on('end', function onClientResponseEnd() {
        tracker.emit('loadingFinished', {
          requestId: requestId,
          timestamp: makeTimestamp(),
          dataLength: totalLength,
          encodedDataLength: totalLength,
        });
      });
    }
    cReq.on('response', patchResponse);

    if (onResponse !== undefined) {
      cReq.on('response', onResponse);
    }

    return cReq;
  };
}

tracker.enable = function enable() {
  wrap(http, 'request', wrapRequest);
};

tracker.disable = function disable() {
  unwrap(http, 'request');
};
