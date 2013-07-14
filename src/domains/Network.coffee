# Domain bindings for Network
{EventEmitter} = require 'events'

module.exports = (agentContext) ->
  Network = new EventEmitter()

  responseDataCache = {}

  # Enables network tracking, network events will now be delivered to the client.
  Network.enable = ({}, cb) ->
    # Not implemented

  # Disables network tracking, prevents network events from being sent to the client.
  Network.disable = ({}, cb) ->
    # Not implemented

  # Allows overriding user agent with the given string.
  #
  # @param userAgent string User agent to use.
  Network.setUserAgentOverride = ({userAgent}, cb) ->
    # Not implemented

  # Specifies whether to always send extra HTTP headers with the requests from this page.
  #
  # @param headers Headers Map with extra HTTP headers.
  Network.setExtraHTTPHeaders = ({headers}, cb) ->
    # Not implemented

  # Returns content served for the given request.
  #
  # @param requestId RequestId Identifier of the network request to get content for.
  # @returns body string Response body.
  # @returns base64Encoded boolean True, if content was sent as base64.
  Network.getResponseBody = ({requestId}, cb) ->
    # Not implemented
    cb null, body: responseDataCache[requestId], base64Encoded: false

  # This method sends a new XMLHttpRequest which is identical to the original one. The following parameters should be identical: method, url, async, request body, extra headers, withCredentials attribute, user, password.
  #
  # @param requestId RequestId Identifier of XHR to replay.
  Network.replayXHR = ({requestId}, cb) ->
    # Not implemented

  # Tells whether clearing browser cache is supported.
  #
  # @returns result boolean True if browser cache can be cleared.
  Network.canClearBrowserCache = ({}, cb) ->
    # Not implemented

  # Clears browser cache.
  Network.clearBrowserCache = ({}, cb) ->
    # Not implemented

  # Tells whether clearing browser cookies is supported.
  #
  # @returns result boolean True if browser cookies can be cleared.
  Network.canClearBrowserCookies = ({}, cb) ->
    # Not implemented

  # Clears browser cookies.
  Network.clearBrowserCookies = ({}, cb) ->
    # Not implemented

  # Toggles ignoring cache for each request. If <code>true</code>, cache will not be used.
  #
  # @param cacheDisabled boolean Cache disabled state.
  Network.setCacheDisabled = ({cacheDisabled}, cb) ->
    # Not implemented

  # [bugger] Cache response data from the child process
  Network._cacheResponseContent = ({requestId, chunk}) ->
    requestId = requestId.toString()
    responseDataCache[requestId] ?= ''
    responseDataCache[requestId] += chunk.toString()

  # Fired when page is about to send HTTP request.
  #
  # @param requestId RequestId Request identifier.
  # @param frameId FrameId Frame identifier.
  # @param loaderId LoaderId Loader identifier.
  # @param documentURL string URL of the document this request is loaded for.
  # @param request Request Request data.
  # @param timestamp Timestamp Timestamp.
  # @param initiator Initiator Request initiator.
  # @param redirectResponse Response? Redirect response data.
  Network.emit_requestWillBeSent = (params) ->
    notification = {params, method: 'Network.requestWillBeSent'}
    @emit 'notification', notification

  # Fired if request ended up loading from cache.
  #
  # @param requestId RequestId Request identifier.
  Network.emit_requestServedFromCache = (params) ->
    notification = {params, method: 'Network.requestServedFromCache'}
    @emit 'notification', notification

  # Fired when HTTP response is available.
  #
  # @param requestId RequestId Request identifier.
  # @param frameId FrameId Frame identifier.
  # @param loaderId LoaderId Loader identifier.
  # @param timestamp Timestamp Timestamp.
  # @param type Page.ResourceType Resource type.
  # @param response Response Response data.
  Network.emit_responseReceived = (params) ->
    notification = {params, method: 'Network.responseReceived'}
    @emit 'notification', notification

  # Fired when data chunk was received over the network.
  #
  # @param requestId RequestId Request identifier.
  # @param timestamp Timestamp Timestamp.
  # @param dataLength integer Data chunk length.
  # @param encodedDataLength integer Actual bytes received (might be less than dataLength for compressed encodings).
  Network.emit_dataReceived = (params) ->
    notification = {params, method: 'Network.dataReceived'}
    @emit 'notification', notification

  # Fired when HTTP request has finished loading.
  #
  # @param requestId RequestId Request identifier.
  # @param timestamp Timestamp Timestamp.
  # @param sourceMapURL string? URL of source map associated with this resource (if any).
  Network.emit_loadingFinished = (params) ->
    notification = {params, method: 'Network.loadingFinished'}
    @emit 'notification', notification

  # Fired when HTTP request has failed to load.
  #
  # @param requestId RequestId Request identifier.
  # @param timestamp Timestamp Timestamp.
  # @param errorText string User friendly error message.
  # @param canceled boolean? True if loading was canceled.
  Network.emit_loadingFailed = (params) ->
    notification = {params, method: 'Network.loadingFailed'}
    @emit 'notification', notification

  # Fired when HTTP request has been served from memory cache.
  #
  # @param requestId RequestId Request identifier.
  # @param frameId FrameId Frame identifier.
  # @param loaderId LoaderId Loader identifier.
  # @param documentURL string URL of the document this request is loaded for.
  # @param timestamp Timestamp Timestamp.
  # @param initiator Initiator Request initiator.
  # @param resource CachedResource Cached resource data.
  Network.emit_requestServedFromMemoryCache = (params) ->
    notification = {params, method: 'Network.requestServedFromMemoryCache'}
    @emit 'notification', notification

  # Fired when WebSocket is about to initiate handshake.
  #
  # @param requestId RequestId Request identifier.
  # @param timestamp Timestamp Timestamp.
  # @param request WebSocketRequest WebSocket request data.
  Network.emit_webSocketWillSendHandshakeRequest = (params) ->
    notification = {params, method: 'Network.webSocketWillSendHandshakeRequest'}
    @emit 'notification', notification

  # Fired when WebSocket handshake response becomes available.
  #
  # @param requestId RequestId Request identifier.
  # @param timestamp Timestamp Timestamp.
  # @param response WebSocketResponse WebSocket response data.
  Network.emit_webSocketHandshakeResponseReceived = (params) ->
    notification = {params, method: 'Network.webSocketHandshakeResponseReceived'}
    @emit 'notification', notification

  # Fired upon WebSocket creation.
  #
  # @param requestId RequestId Request identifier.
  # @param url string WebSocket request URL.
  Network.emit_webSocketCreated = (params) ->
    notification = {params, method: 'Network.webSocketCreated'}
    @emit 'notification', notification

  # Fired when WebSocket is closed.
  #
  # @param requestId RequestId Request identifier.
  # @param timestamp Timestamp Timestamp.
  Network.emit_webSocketClosed = (params) ->
    notification = {params, method: 'Network.webSocketClosed'}
    @emit 'notification', notification

  # Fired when WebSocket frame is received.
  #
  # @param requestId RequestId Request identifier.
  # @param timestamp Timestamp Timestamp.
  # @param response WebSocketFrame WebSocket response data.
  Network.emit_webSocketFrameReceived = (params) ->
    notification = {params, method: 'Network.webSocketFrameReceived'}
    @emit 'notification', notification

  # Fired when WebSocket frame error occurs.
  #
  # @param requestId RequestId Request identifier.
  # @param timestamp Timestamp Timestamp.
  # @param errorMessage string WebSocket frame error message.
  Network.emit_webSocketFrameError = (params) ->
    notification = {params, method: 'Network.webSocketFrameError'}
    @emit 'notification', notification

  # Fired when WebSocket frame is sent.
  #
  # @param requestId RequestId Request identifier.
  # @param timestamp Timestamp Timestamp.
  # @param response WebSocketFrame WebSocket response data.
  Network.emit_webSocketFrameSent = (params) ->
    notification = {params, method: 'Network.webSocketFrameSent'}
    @emit 'notification', notification

  # # Types
  # Unique loader identifier.
  Network.LoaderId = {"id":"LoaderId","type":"string","description":"Unique loader identifier."}
  # Unique frame identifier.
  Network.FrameId = {"id":"FrameId","type":"string","description":"Unique frame identifier.","hidden":true}
  # Unique request identifier.
  Network.RequestId = {"id":"RequestId","type":"string","description":"Unique request identifier."}
  # Number of seconds since epoch.
  Network.Timestamp = {"id":"Timestamp","type":"number","description":"Number of seconds since epoch."}
  # Request / response headers as keys / values of JSON object.
  Network.Headers = {"id":"Headers","type":"object","description":"Request / response headers as keys / values of JSON object."}
  # Timing information for the request.
  Network.ResourceTiming = {"id":"ResourceTiming","type":"object","description":"Timing information for the request.","properties":[{"name":"requestTime","type":"number","description":"Timing's requestTime is a baseline in seconds, while the other numbers are ticks in milliseconds relatively to this requestTime."},{"name":"proxyStart","type":"number","description":"Started resolving proxy."},{"name":"proxyEnd","type":"number","description":"Finished resolving proxy."},{"name":"dnsStart","type":"number","description":"Started DNS address resolve."},{"name":"dnsEnd","type":"number","description":"Finished DNS address resolve."},{"name":"connectStart","type":"number","description":"Started connecting to the remote host."},{"name":"connectEnd","type":"number","description":"Connected to the remote host."},{"name":"sslStart","type":"number","description":"Started SSL handshake."},{"name":"sslEnd","type":"number","description":"Finished SSL handshake."},{"name":"sendStart","type":"number","description":"Started sending request."},{"name":"sendEnd","type":"number","description":"Finished sending request."},{"name":"receiveHeadersEnd","type":"number","description":"Finished receiving response headers."}]}
  # HTTP request data.
  Network.Request = {"id":"Request","type":"object","description":"HTTP request data.","properties":[{"name":"url","type":"string","description":"Request URL."},{"name":"method","type":"string","description":"HTTP request method."},{"name":"headers","$ref":"Headers","description":"HTTP request headers."},{"name":"postData","type":"string","optional":true,"description":"HTTP POST request data."}]}
  # HTTP response data.
  Network.Response = {"id":"Response","type":"object","description":"HTTP response data.","properties":[{"name":"url","type":"string","description":"Response URL. This URL can be different from CachedResource.url in case of redirect."},{"name":"status","type":"number","description":"HTTP response status code."},{"name":"statusText","type":"string","description":"HTTP response status text."},{"name":"headers","$ref":"Headers","description":"HTTP response headers."},{"name":"headersText","type":"string","optional":true,"description":"HTTP response headers text."},{"name":"mimeType","type":"string","description":"Resource mimeType as determined by the browser."},{"name":"requestHeaders","$ref":"Headers","optional":true,"description":"Refined HTTP request headers that were actually transmitted over the network."},{"name":"requestHeadersText","type":"string","optional":true,"description":"HTTP request headers text."},{"name":"connectionReused","type":"boolean","description":"Specifies whether physical connection was actually reused for this request."},{"name":"connectionId","type":"number","description":"Physical connection id that was actually used for this request."},{"name":"fromDiskCache","type":"boolean","optional":true,"description":"Specifies that the request was served from the disk cache."},{"name":"timing","$ref":"ResourceTiming","optional":true,"description":"Timing information for the given request."}]}
  # WebSocket request data.
  Network.WebSocketRequest = {"id":"WebSocketRequest","type":"object","description":"WebSocket request data.","hidden":true,"properties":[{"name":"headers","$ref":"Headers","description":"HTTP response headers."}]}
  # WebSocket response data.
  Network.WebSocketResponse = {"id":"WebSocketResponse","type":"object","description":"WebSocket response data.","hidden":true,"properties":[{"name":"status","type":"number","description":"HTTP response status code."},{"name":"statusText","type":"string","description":"HTTP response status text."},{"name":"headers","$ref":"Headers","description":"HTTP response headers."}]}
  # WebSocket frame data.
  Network.WebSocketFrame = {"id":"WebSocketFrame","type":"object","description":"WebSocket frame data.","hidden":true,"properties":[{"name":"opcode","type":"number","description":"WebSocket frame opcode."},{"name":"mask","type":"boolean","description":"WebSocke frame mask."},{"name":"payloadData","type":"string","description":"WebSocke frame payload data."}]}
  # Information about the cached resource.
  Network.CachedResource = {"id":"CachedResource","type":"object","description":"Information about the cached resource.","properties":[{"name":"url","type":"string","description":"Resource URL. This is the url of the original network request."},{"name":"type","$ref":"Page.ResourceType","description":"Type of this resource."},{"name":"response","$ref":"Response","optional":true,"description":"Cached response data."},{"name":"bodySize","type":"number","description":"Cached response body size."},{"name":"sourceMapURL","type":"string","optional":true,"description":"URL of source map associated with this resource (if any)."}]}
  # Information about the request initiator.
  Network.Initiator = {"id":"Initiator","type":"object","description":"Information about the request initiator.","properties":[{"name":"type","type":"string","enum":["parser","script","other"],"description":"Type of this initiator."},{"name":"stackTrace","$ref":"Console.StackTrace","optional":true,"description":"Initiator JavaScript stack trace, set for Script only."},{"name":"url","type":"string","optional":true,"description":"Initiator URL, set for Parser type only."},{"name":"lineNumber","type":"number","optional":true,"description":"Initiator line number, set for Parser type only."}]}

  return Network
