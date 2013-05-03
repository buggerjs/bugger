
{EventEmitter} = require 'events'

class DebugClient extends EventEmitter
  init: ({@connection}) ->
    @connection.setEncoding 'utf8'
    @connected = @connection.writable
    @socketBuffer = ''
    @msg = false
    @callbackHandler = require('./callback').create()
    @sourceIDs = {}
    @sourceUrls = {}
    @sourceMaps = {}
    @breakpoints = {}

    @_registerConnectionEvents(@connection)

  send: (data) ->
    if @connected
      @connection.write "Content-Length: #{data.length}\r\n\r\n#{data}"
    else
      console.error '[debug] Not connected'

  request: (command, params, requestCallback) ->
    messageObj = { seq: 0, type: 'request', command: command }

    if 'function' is typeof requestCallback
      messageObj.seq = @callbackHandler.wrap requestCallback

    if params
      Object.keys(params).forEach (key) ->
        messageObj[key] = params[key]

    @send JSON.stringify messageObj

  close: ->
    @connection.end()

  _registerConnectionEvents: (conn) ->
    conn.on 'connect', =>
      @connected = true
      @emit 'connect'

    conn.on 'data', (data) =>
      @socketBuffer += data
      @_continueParsing()

    conn.on 'error', (e) => @emit 'error', e

    conn.on 'end', => @close()

    conn.on 'close', =>
      @connected = false
      @emit 'close'

  _continueParsing: ->
    if @msg and @msg.headersDone
      # parse body
      if Buffer.byteLength(@socketBuffer) >= @msg.contentLength
        b = new Buffer @socketBuffer
        @msg.body = b.toString 'utf8', 0, @msg.contentLength
        @socketBuffer = b.toString 'utf8', @msg.contentLength, b.length

        if @msg.body.length > 0
          obj = JSON.parse @msg.body
          if obj.type is 'response' and obj.request_seq > 0
            @callbackHandler.processResponse obj.request_seq, [obj]
          else if obj.type is 'event'
            @emit obj.event, obj

        @msg = false
        # In case that the remaining string contains another event or response
        @_continueParsing()
    else
      @msg = @_makeMessage() unless @msg

      offset = @socketBuffer.indexOf '\r\n\r\n'
      if offset > 0
        @msg.headersDone = true
        @msg.headers = @socketBuffer.substr 0, offset + 4
        contentLengthMatch = /Content-Length: (\d+)/.exec @msg.headers
        if contentLengthMatch[1]
          @msg.contentLength = parseInt contentLengthMatch[1], 10
        else
          console.warn 'No Content-Length'
        @socketBuffer = @socketBuffer.slice offset + 4
        @_continueParsing()

  _makeMessage: -> { headersDone: false, headers: null, contentLength: 0 }

module.exports = new DebugClient
