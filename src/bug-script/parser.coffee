{EventEmitter} = require 'events'

module.exports = debugParser = (stream) ->
  buffer = ''
  emitter = new EventEmitter()

  emptyMessage = ->
    { headers: null, contentLength: 0 }
  currentMessage = emptyMessage()

  parseHeaders = ->
    offset = buffer.indexOf '\r\n\r\n'
    return false unless offset > 0
    currentMessage.headers = buffer.substr 0, offset + 4
    contentLengthMatch = /Content-Length: (\d+)/.exec currentMessage.headers
    if contentLengthMatch[1]
      currentMessage.contentLength = parseInt contentLengthMatch[1], 10
    else
      emitter.emit 'error', new Error('No Content-Length')

    buffer = buffer.substr offset + 4
    true

  parseBody = ->
    {contentLength} = currentMessage
    return false unless Buffer.byteLength(buffer) >= contentLength

    # parse body
    b = new Buffer buffer
    body = b.toString 'utf8', 0, currentMessage.contentLength
    buffer = b.toString 'utf8', currentMessage.contentLength, b.length

    if body.length > 0
      try
        obj = JSON.parse body
        emitter.emit "parsed:#{obj.type}", obj
      catch error
        emitter.emit 'error', error

    currentMessage = emptyMessage()
    true

  parseBuffer = ->
    madeProgress = true
    while madeProgress
      madeProgress =
        unless currentMessage.headers?
          parseHeaders()
        else
          parseBody()

  stream.on 'data', (chunk) ->
    buffer += chunk
    parseBuffer buffer

  return emitter
