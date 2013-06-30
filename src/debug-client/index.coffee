
{EventEmitter} = require 'events'

debugParser = require './parser'
callbackWrapper = require './callback-wrapper'
commandsWith = require './commands'

module.exports = (debugConnection) ->
  client = new EventEmitter()
  client.running = true
  client.debugConnection = debugConnection

  nextObjectId = 0
  client.nextObjectId = -> ++nextObjectId

  client.commands = commandsWith client

  debugConnection.setEncoding 'utf8'

  {wrapCallback, unwrapCallback} = callbackWrapper client

  sendString = (data) ->
    if debugConnection.writable
      debugConnection.write "Content-Length: #{data.length}\r\n\r\n#{data}"
    else
      client.emit 'error', new Error('Debug connection not writable')
      client.emit 'close'

  client.sendRequest = (command, params, cb) ->
    messageObj =
      type: 'request'
      command: command
      seq: wrapCallback(cb)

    if Object.keys(params).length > 0
      messageObj.arguments = params

    sendString JSON.stringify messageObj

  updateRunning = (running) ->
    if running != client.running
      client.running = running
      eventName = if running then 'running' else 'stopped'
      client.emit eventName

  parser = debugParser debugConnection
  parser.on 'parsed:response', (obj) ->
    updateRunning obj.running if obj.running?
    if Array.isArray obj.refs
      refMap = {}
      refMap[ref.handle.toString()] = ref for ref in obj.refs
      obj.refMap = refMap

    unwrapCallback obj

  parser.on 'parsed:event', (obj) ->
    {success, running} = obj
    updateRunning running if running?

    {event, body, refs} = obj
    refMap = {}
    if Array.isArray refs
      refMap[ref.handle.toString()] = ref for ref in refs

    client.emit event, body, refMap

  return client
