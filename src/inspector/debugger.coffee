Net = require 'net'
{EventEmitter} = require 'events'
{Buffer} = require 'buffer'
callbackHandler = require('./callback').create()

makeMessage = ->
  headersDone: false
  headers: null
  contentLength: 0

exports.attachDebugger = (port) ->
  connected = false
  debugBuffer = ''
  msg = false
  conn = Net.connect port
  conn.setEncoding 'utf8'

  parse = ->
    if msg and msg.headersDone
      # parse body
      if Buffer.byteLength(debugBuffer) >= msg.contentLength
        b = new Buffer debugBuffer
        msg.body = b.toString 'utf8', 0, msg.contentLength
        debugBuffer = b.toString 'utf8', msg.contentLength, b.length

        if msg.body.length > 0
          obj = JSON.parse msg.body
          if obj.type is 'response' and obj.request_seq > 0
            callbackHandler.processResponse obj.request_seq, [obj]
          else if obj.type is 'event'
            debugr.emit obj.event, obj

        msg = false
        parse()
    else
      msg = makeMessage() unless msg

      offset = debugBuffer.indexOf '\r\n\r\n'
      if offset > 0
        msg.headersDone = true
        msg.headers = debugBuffer.substr 0, offset + 4
        contentLengthMatch = /Content-Length: (\d+)/.exec msg.headers
        if contentLengthMatch[1]
          msg.contentLength = parseInt contentLengthMatch[1], 10
        else
          console.warn 'no Content-Length'
        debugBuffer = debugBuffer.slice offset + 4
        parse()

  debugr = Object.create(EventEmitter.prototype,
    send:
      value: (data) ->
        if connected
          conn.write "Content-Length: #{data.length}\r\n\r\n#{data}"

    request:
      value: (command, params, callback) ->
        msg =
          seq: 0
          type: 'request'
          command: command

        if 'function' is typeof callback
          msg.seq = callbackHandler.wrap callback

        if params
          Object.keys(params).forEach (key) ->
            msg[key] = params[key]

        @send JSON.stringify msg

    close:
      value: -> conn.end()

    connected:
      get: -> connected
  )

  conn.on('connect', ->
    connected = true
    debugr.emit 'connect'
  ).on('data', (data) ->
    debugBuffer += data
    parse()
  ).on('error', (e) ->
    debugr.emit 'error', e
  ).on('end', ->
    debugr.close()
  ).on('close', ->
    connected = false
    debugr.emit 'close'
  )

  debugr
