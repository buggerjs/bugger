Http = require 'http'
{EventEmitter} = require 'events'
io = require 'socket.io'
send = require('send')
Session = require './session'
urlLib = require 'url'
path = require 'path'
fs = require 'fs'

session = null
config = {}
connectionTimeout = null

serveStaticFiles = (req, res) ->
  re = /^\/_sourcemap\/(\d+)$/

  if (smMatch = req.url.match(re))?
    res.setHeader 'Content-Type', 'application/json'
    sourceMap = getSession().getSourceMap(smMatch[1])
    sourceMap.sourcesContent ?= []

    # sourcesContent for sources
    sourceMap.sources.forEach (source, idx) ->
      unless sourceMap.sourcesContent[idx]
        sourceMap.sourcesContent[idx] =
          try
            fs.readFileSync(source).toString()
          catch err
            ''
    return res.end JSON.stringify getSession().getSourceMap(smMatch[1])
  else
    publicDirectory =
      if req.url in [ '/InspectorBackendCommands.js', '/InspectorBackend.js', '/Overrides.js' ]
        __dirname
      else
        path.join __dirname, '..', 'public'

    # Rewrite backend to stubbed one
    req.url = req.url.replace '/InspectorBackend.js', '/InspectorBackendStub.js'

    send(req, urlLib.parse(req.url).pathname).root(publicDirectory).pipe(res)

getSession = ->
  unless session
    session = Session.create config.debugConnection, config
    session.on 'ws_closed', ->
      connectionTimeout = setTimeout( ->
        session.close()
      , 3000)

    session.on 'close', ->
      session = null

    session.attach()
  session

handleWebSocketConnection = (socket) ->
  clearTimeout(connectionTimeout)
  getSession().join(socket)

handleServerListening = ->
  console.log(
    'visit http://' + (config.webHost || '0.0.0.0') + ':' +
    config.webPort +
    '/inspector.html to start debugging')

class DebugServer extends EventEmitter
  start: (options) ->
    config = options
    httpServer = Http.createServer serveStaticFiles
    ws = io.listen httpServer
    ws.configure ->
      ws.set 'transports', ['websocket']
      ws.set 'log level', 1
    ws.sockets.on 'connection', handleWebSocketConnection
    @wsServer = ws
    httpServer.on 'listening', handleServerListening
    httpServer.listen config.webPort, config.webHost
    return this

  close: ->
    if @wsServer
      @wsServer.close()
      @emit 'close'

exports.DebugServer = DebugServer
