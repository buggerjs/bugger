# Domain bindings for Network
{EventEmitter} = require 'events'

module.exports = (agentContext) ->
  Network = new EventEmitter()

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

  # Toggles ignoring cache for each request. If <code>true</code>, cache will not be used.
  #
  # @param cacheDisabled boolean Cache disabled state.
  Network.emit_setCacheDisabled = (params) ->
    notification = {params, method: 'Network.setCacheDisabled'}
    @emit 'notification', notification

  # Toggles ignoring cache for each request. If <code>true</code>, cache will not be used.
  #
  # @param cacheDisabled boolean Cache disabled state.
  Network.emit_setCacheDisabled = (params) ->
    notification = {params, method: 'Network.setCacheDisabled'}
    @emit 'notification', notification

  # Toggles ignoring cache for each request. If <code>true</code>, cache will not be used.
  #
  # @param cacheDisabled boolean Cache disabled state.
  Network.emit_setCacheDisabled = (params) ->
    notification = {params, method: 'Network.setCacheDisabled'}
    @emit 'notification', notification

  # Toggles ignoring cache for each request. If <code>true</code>, cache will not be used.
  #
  # @param cacheDisabled boolean Cache disabled state.
  Network.emit_setCacheDisabled = (params) ->
    notification = {params, method: 'Network.setCacheDisabled'}
    @emit 'notification', notification

  # Toggles ignoring cache for each request. If <code>true</code>, cache will not be used.
  #
  # @param cacheDisabled boolean Cache disabled state.
  Network.emit_setCacheDisabled = (params) ->
    notification = {params, method: 'Network.setCacheDisabled'}
    @emit 'notification', notification

  # Toggles ignoring cache for each request. If <code>true</code>, cache will not be used.
  #
  # @param cacheDisabled boolean Cache disabled state.
  Network.emit_setCacheDisabled = (params) ->
    notification = {params, method: 'Network.setCacheDisabled'}
    @emit 'notification', notification

  # Toggles ignoring cache for each request. If <code>true</code>, cache will not be used.
  #
  # @param cacheDisabled boolean Cache disabled state.
  Network.emit_setCacheDisabled = (params) ->
    notification = {params, method: 'Network.setCacheDisabled'}
    @emit 'notification', notification

  # Toggles ignoring cache for each request. If <code>true</code>, cache will not be used.
  #
  # @param cacheDisabled boolean Cache disabled state.
  Network.emit_setCacheDisabled = (params) ->
    notification = {params, method: 'Network.setCacheDisabled'}
    @emit 'notification', notification

  # Toggles ignoring cache for each request. If <code>true</code>, cache will not be used.
  #
  # @param cacheDisabled boolean Cache disabled state.
  Network.emit_setCacheDisabled = (params) ->
    notification = {params, method: 'Network.setCacheDisabled'}
    @emit 'notification', notification

  # Toggles ignoring cache for each request. If <code>true</code>, cache will not be used.
  #
  # @param cacheDisabled boolean Cache disabled state.
  Network.emit_setCacheDisabled = (params) ->
    notification = {params, method: 'Network.setCacheDisabled'}
    @emit 'notification', notification

  # Toggles ignoring cache for each request. If <code>true</code>, cache will not be used.
  #
  # @param cacheDisabled boolean Cache disabled state.
  Network.emit_setCacheDisabled = (params) ->
    notification = {params, method: 'Network.setCacheDisabled'}
    @emit 'notification', notification

  # Toggles ignoring cache for each request. If <code>true</code>, cache will not be used.
  #
  # @param cacheDisabled boolean Cache disabled state.
  Network.emit_setCacheDisabled = (params) ->
    notification = {params, method: 'Network.setCacheDisabled'}
    @emit 'notification', notification

  # Toggles ignoring cache for each request. If <code>true</code>, cache will not be used.
  #
  # @param cacheDisabled boolean Cache disabled state.
  Network.emit_setCacheDisabled = (params) ->
    notification = {params, method: 'Network.setCacheDisabled'}
    @emit 'notification', notification

  # Toggles ignoring cache for each request. If <code>true</code>, cache will not be used.
  #
  # @param cacheDisabled boolean Cache disabled state.
  Network.emit_setCacheDisabled = (params) ->
    notification = {params, method: 'Network.setCacheDisabled'}
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
