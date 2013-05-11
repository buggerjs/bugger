
{EventEmitter} = require 'events'

module.exports = debugClient = (debugConnection) ->
  client = new EventEmitter()

  return client
