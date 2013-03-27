
http = require 'http'
fs = require 'fs'
path = require 'path'
urlLib = require 'url'

{EventEmitter} = require 'events'
WebSocketServer = require('websocket').server
send = require 'send'
SocketChannel = require './socket_channel'

debug = require '../debug-client'

servePatchedStaticFiles = (req, res) ->
  sourceMapMatch = req.url.match /^\/_sourcemap\/(\d+)$/
  if sourceMapMatch?
    sourceMapId = sourceMapMatch[1]
    res.setHeader 'Content-Type', 'application/json'
    res.write debug.sourceMaps[sourceMapId] ? ''
    res.end()
  else
    publicDirectory =
      if req.url in [ '/InspectorBackendCommands.js', '/InspectorBackend.js', '/Overrides.js' ]
        # these files are provided by us
        __dirname
      else
        # everything else is taken from the original web inspector
        path.join __dirname, '..', '..', 'public'

    if req.url.indexOf('/?') is 0
      # We inject an additional javascript into the header for custom overrides
      fs.readFile publicDirectory + '/inspector.html', (err, data) ->
        data = data.toString().replace('</head>', '<title>bugger</title><script type="text/javascript" src="Overrides.js"></script></head>')
        res.setHeader 'Content-Type', 'text/html'
        res.write data
        res.end()
    else
      send(req, urlLib.parse(req.url).pathname).root(publicDirectory).pipe(res)

module.exports = Object.create EventEmitter.prototype, {
  start:
    value: ({webhost, webport, appUrl}) ->
      httpServer = http.createServer servePatchedStaticFiles

      wsServer = new WebSocketServer {
        httpServer: httpServer,
        autoAcceptConnections: true
      }
      wsServer.on 'connect', (wsConnection) =>
        new SocketChannel {
          socketConnection: wsConnection,
          httpServer: httpServer,
          socketServer: wsServer
        }

      httpServer.on 'listening', ->
        console.log "[bugger] Visit #{appUrl} to start debugging"

      httpServer.listen webport, webhost

  close:
    value: ->
      if @wsServer
        @wsServer.close()
        @emit 'close'
}
