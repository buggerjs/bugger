
{Stream} = require 'stream'

runBugger = require './run_bugger'
WebSocketClient = require('websocket').client

path = require 'path'
{readFileSync} = require 'fs'

fixtures =
  chrome_connect: readFileSync(path.join __dirname, '..', 'fixtures', 'chrome_connect')

nextId = 0

parseFixture = (chunk) ->
  lines = chunk.toString().split('\n')
  reqArr = []
  cmdMarker = 'Command: '
  argMarker = '>  '
  while lines.length > 0
    line = lines.shift()
    continue if line.length < 1 || line[0] == '['
    pIdx = line.indexOf '('
    if line.indexOf(cmdMarker) == 0 && pIdx > 0
      cmd = line.substring cmdMarker.length, pIdx
      argLine = lines.shift().substr(argMarker.length)
      reqArr.push { method: cmd, params: JSON.parse argLine }
  reqArr

class FakeChrome extends Stream
  constructor: (@child) ->
    doConnect = =>
      @ws = new WebSocketClient()
      @ws.connect 'http://127.0.0.1:8058/websocket'
      @ws.on 'connect', (connection) =>
        connection.on 'message', (data) =>
          response = JSON.parse data.utf8Data
          if response.method # this is an event
            @emit response.method, (response.params ? {})
          else
            @emit 'response', response

        @c = connection
        @emit 'readable'
        @emit 'ready', this

    # We have to make sure that the debug server is running correctly
    setTimeout doConnect, 500

    @child.stderr.pipe process.stderr

  write: (req, encoding, callback) ->
    req.id ?= ++nextId
    req.params ?= {}
    @c.send JSON.stringify req

  writeFixture: (name) ->
    reqArr = parseFixture fixtures[name]
    @write req for req in reqArr

  end: ->
    @emit 'end'
    @emit 'close'
    @child.kill()

module.exports = (args, cb) ->
  args = [ '--brk' ].concat args
  child = runBugger args, cb

  new FakeChrome child
