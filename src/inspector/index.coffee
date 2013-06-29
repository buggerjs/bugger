
{createServer} = require 'http'
{EventEmitter} = require 'events'

webSocket = require('websocket')

createClient = require './client'

module.exports = ->
  inspector = new EventEmitter()
  inspector.clients = {}

  sourceMaps = {}

  httpServer = inspector.httpServer = createServer (req, res) ->
    res.setHeader 'Access-Control-Allow-Origin', '*'

    if 0 is req.url.indexOf '/source-map/'
      res.setHeader 'Content-Type', 'application/json'

      scriptId = req.url.replace(/\/source-map\/(\d+)/, '$1')
      res.write sourceMaps[scriptId]
    else
      res.write httpServer.DEFAULT_URL + "\n"
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

    if notification.method is 'Debugger.scriptParsed'
      script = notification.params
      if script.scriptSource?
        regex = /\/\/@ sourceMappingURL=data:application\/json;base64,(.*)/
        match = regex.exec script.scriptSource
        if match
          tempMap = try JSON.parse(new Buffer(match[1], 'base64').toString('utf8'))
          if tempMap?
            tempMap.sourcesContent = tempMap.sources.map (sourceFile) ->
              try require('fs').readFileSync sourceFile, 'utf8'

            tempMap.sources = tempMap.sources.map (sourceFile) ->
              'file://' + sourceFile + '.src'

            sourceMaps[script.scriptId] = JSON.stringify tempMap
            script.sourceMapURL = "#{httpServer.BASE_URL}/source-map/#{script.scriptId}"

        delete script.scriptSource

    for clientId, client of inspector.clients
      client.dispatchEvent notification
    null # for CS

  httpServer.on 'listening', ->
    {address, port} = @address()
    query = "ws=#{address}:#{port}/websocket"
    httpServer.DEFAULT_URL = "chrome://devtools/devtools.html?#{query}"
    inspector.DEFAULT_URL = httpServer.DEFAULT_URL
    httpServer.BASE_URL = "http://#{address}:#{port}"

  inspector.listen = ->
    httpServer.listen arguments...

  return inspector

unless module.parent
  inspector = module.exports()
  inspector.listen 8058, ->
    console.log "Open Devtools:\n#{@DEFAULT_URL}"
