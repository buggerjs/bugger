Http = require 'http'
{EventEmitter} = require 'events'
io = require 'socket.io'
send = require('send')
Session = require './session'
urlLib = require 'url'
path = require 'path'

sessions = {}
config = {}
connectionTimeout = null

serveStaticFiles = (req, res) ->
  re = /^\/debug/
  if re.test req.url
    config.debugPort = getDebuggerPort req.url, config.debugPort
    req.url = req.url.replace re, '/'

  send(req, urlLib.parse(req.url).pathname).root(path.join __dirname, '..', 'public').pipe(res)

getDebuggerPort = (url, defaultPort) ->
  parseInt((/\?port=(\d+)/.exec(url) || [null, defaultPort])[1], 10);

getSession = (debuggerPort) ->
  session = sessions[debuggerPort]
  unless session
    session = Session.create debuggerPort, config
    sessions[debuggerPort] = session
    session.on 'ws_closed', ->
      connectionTimeout = setTimeout( ->
        session.close()
      , 3000)

    session.on 'close', ->
      sessions[debuggerPort] = null

    session.attach()
  session

handleWebSocketConnection = (socket) ->
  clearTimeout(connectionTimeout)
  getSession(config.debugPort).join(socket)

handleServerListening = ->
  console.log(
    'visit http://' + (config.webHost || '0.0.0.0') + ':' +
    config.webPort +
    '/debug?port=' + config.debugPort + ' to start debugging')

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
