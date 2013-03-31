// Generated by CoffeeScript 2.0.0-beta4
var _, _renderHeaders, http, https, lastRequestId, makeStackTrace, mimeTypeToResponseType, patchProtocolLib, protocolLib, removeArraysFromHeaders, sendMessage, url;
http = require('http');
https = require('https');
url = require('url');
_ = require('underscore');
lastRequestId = 0;
mimeTypeToResponseType = function (mimeType) {
  if (mimeType.indexOf('html') >= 0) {
    return 'Document';
  } else if (mimeType.indexOf('json') >= 0 || mimeType.indexOf('xml') >= 0) {
    return 'XHR';
  } else if (mimeType.indexOf('css') >= 0) {
    return 'Stylesheet';
  } else if (mimeType.indexOf('javascript') >= 0) {
    return 'Script';
  } else if (mimeType.indexOf('image') >= 0) {
    return 'Image';
  } else {
    return 'Other';
  }
};
sendMessage = function (method, params) {
  var message;
  message = _.extend({
    method: method,
    timestamp: Math.floor(new Date().getTime() / 1e3)
  }, params);
  if (process.send)
    return process.send(message);
};
removeArraysFromHeaders = function (headers) {
  var headerMap, headerName, headerValue;
  headerMap = {};
  for (headerName in headers) {
    headerValue = headers[headerName];
    headerMap[headerName] = Array.isArray(headerValue) ? headerValue.join('\n') : headerValue;
  }
  return headerMap;
};
makeStackTrace = function () {
  var err, orig, stack;
  orig = Error.prepareStackTrace;
  Error.prepareStackTrace = function (_, stack) {
    return stack;
  };
  err = new Error;
  Error.captureStackTrace(err, arguments.callee);
  stack = err.stack;
  Error.prepareStackTrace = orig;
  return stack.map(function (frame) {
    return {
      url: frame.getFileName(),
      functionName: frame.getFunctionName(),
      lineNumber: frame.getLineNumber(),
      columnNumber: frame.getColumnNumber()
    };
  });
};
_renderHeaders = function () {
  var headers, headerValue, key;
  if (!this._headers)
    return {};
  headers = {};
  for (key in this._headers) {
    headerValue = this._headers[key];
    headers[this._headerNames[key]] = headerValue;
  }
  return headers;
};
patchProtocolLib = function (protocolLib) {
  var oldRequest;
  oldRequest = protocolLib.request;
  return protocolLib.request = function (options, cb) {
    var documentURL, loaderId, patchedClientRequest, patchedClientResponseCallback, requestId;
    if (typeof options === 'string')
      options = url.parse(options);
    requestId = (++lastRequestId).toString();
    loaderId = requestId;
    documentURL = url.format(null != options.uri ? options.uri : options);
    patchedClientRequest = function (cReq) {
      var _end;
      _end = cReq.end;
      cReq.end = function () {
        var initiator, request, stackTrace, timestamp;
        timestamp = new Date().getTime();
        request = {
          headers: _renderHeaders.apply(cReq),
          method: cReq.method,
          postData: '',
          url: documentURL
        };
        stackTrace = makeStackTrace();
        initiator = {
          stackTrace: stackTrace,
          type: 'script'
        };
        sendMessage('Network.requestWillBeSent', {
          requestId: requestId,
          loaderId: loaderId,
          documentURL: documentURL,
          request: request,
          stackTrace: stackTrace,
          initiator: initiator
        });
        return _end.apply(this, arguments);
      };
      return cReq;
    };
    patchedClientResponseCallback = function (cb) {
      return function (cRes) {
        var cache$, mimeType, response, type;
        mimeType = (cache$ = null != cRes.headers['content-type'] ? cRes.headers['content-type'].split(';')[0] : void 0, null != cache$ ? cache$ : 'text/plain');
        type = mimeTypeToResponseType(mimeType);
        response = {
          connectionId: requestId,
          connectionReused: false,
          headers: removeArraysFromHeaders(cRes.headers),
          mimeType: mimeType,
          status: cRes.statusCode,
          statusText: http.STATUS_CODES[cRes.statusCode],
          url: documentURL
        };
        sendMessage('Network.responseReceived', {
          requestId: requestId,
          loaderId: loaderId,
          response: response,
          type: type
        });
        cRes.on('data', function (chunk) {
          process.send({
            method: 'cacheResponseContent',
            requestId: requestId,
            chunk: chunk.toString()
          });
          return sendMessage('Network.dataReceived', {
            requestId: requestId,
            dataLength: chunk.length,
            encodedDataLength: chunk.length
          });
        });
        cRes.on('end', function () {
          return sendMessage('Network.loadingFinished', { requestId: requestId });
        });
        cRes.on('error', function (err) {
          return sendMessage('Network.loadingFailed', {
            requestId: requestId,
            errorText: err.message
          });
        });
        return cb(cRes);
      };
    };
    return patchedClientRequest(oldRequest(options, patchedClientResponseCallback(cb)));
  };
};
for (var cache$ = [
      http,
      https
    ], i$ = 0, length$ = cache$.length; i$ < length$; ++i$) {
  protocolLib = cache$[i$];
  patchProtocolLib(protocolLib);
}