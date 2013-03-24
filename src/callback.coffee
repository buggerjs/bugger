###
Create a callback container
@return {Object} that wraps callbacks and returns a one-time id.
###

lastId = 1
callbacks = {}

module.exports.create = ->
  wrap: (callback) ->
    callbacks[lastId] = callback || ->
    lastId++

  processResponse: (callbackId, args) ->
    callback = callbacks[callbackId]
    callback.apply null, args
    delete callbacks[callbackId]

  removeResponseCallbackEntry: (callbackId) ->
    delete callbacks[callbackId]
