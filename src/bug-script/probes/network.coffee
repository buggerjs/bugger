
http = require 'http'
https = require 'https'
url = require 'url'

_ = require 'underscore'

lastRequestId = 0

mimeTypeToResponseType = (mimeType) ->
  # [ "Document" , "Font" , "Image" , "Other" , "Script" , "Stylesheet" , "WebSocket" , "XHR" ]
  if mimeType.indexOf('html') >= 0
    'Document'
  else if mimeType.indexOf('json') >= 0 or mimeType.indexOf('xml') >= 0
    'XHR'
  else if mimeType.indexOf('css') >= 0
    'Stylesheet'
  else if mimeType.indexOf('javascript') >= 0
    'Script'
  else if mimeType.indexOf('image') >= 0
    'Image'
  else
    'Other'

sendMessage = (method, params) ->
  message = _.extend { method, timestamp: (new Date()).getTime() / 1000.0 }, params
  if process.send
    process.send message

removeArraysFromHeaders = (headers) ->
  headerMap = {}
  for headerName, headerValue of headers
    headerMap[headerName] =
      if Array.isArray(headerValue)
        headerValue.join("\n")
      else
        headerValue
  headerMap

makeStackTrace = ->
  orig = Error.prepareStackTrace
  Error.prepareStackTrace = (_, stack) -> stack
  err = new Error
  Error.captureStackTrace err, arguments.callee
  stack = err.stack
  Error.prepareStackTrace = orig
  return stack.map (frame) ->
    url: frame.getFileName()
    functionName: frame.getFunctionName()
    lineNumber: frame.getLineNumber()
    columnNumber: frame.getColumnNumber()

_renderHeaders = ->
  return {} unless @_headers

  headers = {}
  for key, headerValue of @_headers
    headers[@_headerNames[key]] = headerValue

  return headers

patchProtocolLib = (protocolLib) ->
  oldRequest = protocolLib.request
  protocolLib.request = (options, cb) ->
    if typeof options is 'string'
      options = url.parse options

    requestId = (++lastRequestId).toString()
    loaderId = requestId
    documentURL = url.format (options.uri ? options)

    patchedClientRequest = (cReq) ->
      cReq.on 'error', (err) ->
        sendMessage 'Network.emit_loadingFailed', { requestId, errorText: err.message }

      _end = cReq.end
      cReqStartTime = Date.now()
      cReq.end = ->
        request = { headers: _renderHeaders.apply(cReq), method: cReq.method, postData: '', url: documentURL }
        stackTrace = makeStackTrace()
        initiator = { stackTrace, type: 'script' }
        sendMessage 'Network.emit_requestWillBeSent', { requestId, loaderId, documentURL, request, stackTrace, initiator }
        sendMessage 'Timeline.emit_eventRecorded',
          record:
            type: 'ResourceSendRequest',
            startTime: cReqStartTime,
            endTime: Date.now()
            data: { requestId, url: documentURL, requestMethod: cReq.method }
        _end.apply this, arguments

      cReq

    patchedClientResponseCallback = (cb) ->
      (cRes) ->
        mimeType = cRes.headers['content-type']?.split(';')[0] ? 'text/plain'
        type = mimeTypeToResponseType(mimeType)
        cResStartTime = Date.now()
        response = {
          connectionId: requestId
          connectionReused: false
          headers: removeArraysFromHeaders(cRes.headers)
          mimeType: mimeType
          status: cRes.statusCode
          statusText: http.STATUS_CODES[cRes.statusCode]
          url: documentURL
        }
        sendMessage 'Network.emit_responseReceived', { requestId, loaderId, response, type }

        cRes.on 'data', (chunk) ->
          process.send { method: 'Network._cacheResponseContent', requestId, chunk: chunk.toString() }
          sendMessage 'Network.emit_dataReceived', { requestId, dataLength: chunk.length, encodedDataLength: chunk.length }

        cRes.on 'end', ->
          sendMessage 'Network.emit_loadingFinished', { requestId }
          sendMessage 'Timeline.emit_eventRecorded',
            record:
              type: 'ResourceReceiveResponse',
              startTime: cResStartTime,
              endTime: Date.now(),
              data: { requestId, mimeType, statusCode: cRes.statusCode }

        cRes.on 'error', (err) ->
          sendMessage 'Network.emit_loadingFailed', { requestId, errorText: err.message }
          sendMessage 'Timeline.emit_eventRecorded',
            record:
              type: 'ResourceReceiveResponse',
              startTime: cResStartTime,
              endTime: Date.now(),
              data: { requestId, mimeType, statusCode: cRes.statusCode }

        cb(cRes)

    patchedClientRequest(oldRequest options, patchedClientResponseCallback(cb))

load = (scriptContext, safe = false) ->
  return if safe
  for protocolLib in [http, https]
    patchProtocolLib(protocolLib)

module.exports = {load}
