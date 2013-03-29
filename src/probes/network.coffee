
http = require 'http'
url = require 'url'

_ = require 'underscore'
{Probe} = require '../probes'

lastRequestId = 0
_responseContentCache = {}

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

networkProbe = new Probe('Network')

networkProbe.getResponseBody = ({requestId}, cb) ->
  cb null, _responseContentCache[requestId].toString(), false

sendMessage = (method, params) ->
  message = _.extend { method, timestamp: Math.floor((new Date()).getTime() / 1000) }, params
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

makeStackTrace = () ->
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

patchProtocol = (protocol) ->
  protocolLib = require protocol
  oldRequest = protocolLib.request
  protocolLib.request = (options, cb) ->
    if typeof options is 'string'
      options = url.parse options

    requestId = (++lastRequestId).toString()
    loaderId = requestId
    documentURL = url.format options

    patchedClientRequest = (cReq) ->
      _end = cReq.end
      cReq.end = ->
        timestamp = (new Date()).getTime()
        request = { headers: _renderHeaders.apply(cReq), method: cReq.method, postData: '', url: documentURL }
        stackTrace = makeStackTrace()
        initiator = { stackTrace, type: 'script' }
        sendMessage 'Network.requestWillBeSent', { requestId, loaderId, documentURL, request, stackTrace, initiator }
        _end.apply this, arguments

      cReq

    patchedClientResponseCallback = (cb) ->
      (cRes) ->
        _responseContentCache[requestId] = ''
        mimeType = cRes.headers['content-type']?.split(';')[0] ? 'text/plain'
        type = mimeTypeToResponseType(mimeType)
        response = {
          connectionId: requestId
          connectionReused: false
          headers: removeArraysFromHeaders(cRes.headers)
          mimeType: mimeType
          status: cRes.statusCode
          statusText: http.STATUS_CODES[cRes.statusCode]
          url: documentURL
        }
        sendMessage 'Network.responseReceived', { requestId, loaderId, response, type }

        cRes.on 'data', (chunk) ->
          _responseContentCache[requestId] += chunk.toString()
          sendMessage 'Network.dataReceived', { requestId, dataLength: chunk.length, encodedDataLength: chunk.length }

        cRes.on 'end', ->
          sendMessage 'Network.loadingFinished', { requestId }

        cRes.on 'error', (err) ->
          sendMessage 'Network.loadingFailed', { requestId, errorText: err.message }

        cb(cRes)

    patchedClientRequest(oldRequest options, patchedClientResponseCallback(cb))

for protocol in ['http', 'https']
  patchProtocol(protocol)
