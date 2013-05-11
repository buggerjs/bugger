
{createServer} = require 'http'
WebSocketServer = require('websocket').server

module.exports = ->
  # frontendOverrides = (root) ->
  #   # debugger always enabled
  #   root.WebInspector.settings.debuggerEnabled.set true
  #   # source maps always enabled
  #   root.WebInspector.settings.sourceMapsEnabled.set true
  #   root.dumpInspectorProtocolMessages = false

  #   preloadMessageBuffer = []
  #   root.InspectorFrontendHost.sendMessageToBackend = (message) ->
  #     preloadMessageBuffer.push message

  #   root.InspectorFrontendHost.loaded = ->
  #     root.InspectorFrontendAPI.dispatchQueryParameters()
  #     root.WebInspector._doLoadedDoneWithCapabilities()

  server = createServer (req, res) ->
    res.write server.DEFAULT_URL + "\n"
    res.end()

  server.websocket = new WebSocketServer {
    httpServer: server,
    autoAcceptConnections: true
  }

  server.on 'listening', ->
    {address, port} = @address()
    @QUERY_STRING = "ws=#{address}:#{port}/websocket"
    @DEFAULT_URL = "chrome://devtools/devtools.html?#{@QUERY_STRING}"

  return server

unless module.parent
  server = module.exports()
  server.listen 8058, ->
    console.log "Open Devtools:\n#{@DEFAULT_URL}"
