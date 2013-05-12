
{EventEmitter} = require 'events'

LAST_CLIENT_ID = 0

createClient = (socket) ->
  client = new EventEmitter()
  client.socket = socket
  client.id = ++LAST_CLIENT_ID

  handleRequest = (req) ->
    {method, params, id} = req
    params ?= {}

    unless method
      err = new Error "Invalid request: #{JSON.stringify req}"
      throw err

    callback =
      if id > 0
        (error, result) ->
          sendResponse id, error, result
      else
        ->

    client.emit 'request', {method, params, callback, id}

  sendResponse = (id, error, result = {}) ->
    if socket and socket.connected
      response =
        if error?
          errorMessage =
            if 'string' is typeof error
              error
            else (error.stack ? error.message)
          { id, result: null, error: errorMessage }
        else
          { id, result, error: null }
      socket.send JSON.stringify response
    else
      client.emit 'error', new Error('Tried to write to non-connected socket')

  client.dispatchEvent = ({method, params}) ->
    params ?= {}
    if socket and socket.connected
      socket.send JSON.stringify { method, params }
    else
      errorMessage = "Could not dispatch #{method}(#{JSON.stringify params}"
      client.emit 'error', new Error(errorMessage)

  socket.on 'message', (data) ->
    try
      req = JSON.parse data.utf8Data
      handleRequest req
    catch err
      err.utf8Data = data.utf8Data
      client.emit 'error', err

  socket.on 'close', ->
    client.emit 'close'
    do client.removeAllListeners

  return client

module.exports = createClient
