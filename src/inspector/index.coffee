
{createServer} = require 'http'
{EventEmitter} = require 'events'

webSocket = require('websocket')

createClient = require './client'

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
  inspector = new EventEmitter()
  inspector.clients = {}

  httpServer = inspector.httpServer = createServer (req, res) ->
    res.write server.DEFAULT_URL + "\n"
    res.end()

  websocket = inspector.websocket = new webSocket.server {
    httpServer: httpServer,
    autoAcceptConnections: true
  }

  websocket.on 'connect', (socket) ->
    client = createClient socket

    client.on 'error', (err) ->
      inspector.emit 'error', err

    client.on 'request', (request) ->
      inspector.emit 'request', request

    client.on 'close', ->
      # Remove client from client list
      delete inspector.clients[client.id]
      inspector.emit 'disconnect', client

    inspector.clients[client.id] = client
    inspector.emit 'join', client

  inspector.dispatchEvent = (notification) ->
    notification.params ?= {}
    for clientId, client of inspector.clients
      client.dispatchEvent notification
    null # for CS

  httpServer.on 'listening', ->
    {address, port} = @address()
    query = "ws=#{address}:#{port}/websocket"
    @DEFAULT_URL = "chrome://devtools/devtools.html?#{query}"
    inspector.DEFAULT_URL = @DEFAULT_URL

  inspector.listen = ->
    httpServer.listen arguments...

  return inspector

unless module.parent
  inspector = module.exports()
  inspector.listen 8058, ->
    console.log "Open Devtools:\n#{@DEFAULT_URL}"
